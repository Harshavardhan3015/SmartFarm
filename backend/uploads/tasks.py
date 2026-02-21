from celery import shared_task
from django.db import transaction
from django.db.utils import OperationalError
from django.core.exceptions import ObjectDoesNotExist
import logging

from .models import Upload, InferenceResult
from ml_models.infer import predict

logger = logging.getLogger(__name__)


def generate_actions(disease: str):
    recommendations = {
        "Leaf Blight": [
            "Spray recommended fungicide",
            "Remove infected leaves",
            "Avoid overhead irrigation",
        ],
        "Rust": [
            "Apply sulfur-based spray",
            "Ensure proper spacing between plants",
        ],
        "Powdery Mildew": [
            "Apply neem oil solution",
            "Increase air circulation",
        ],
        "Healthy": [
            "No treatment required",
            "Continue regular monitoring",
        ],
    }

    return recommendations.get(
        disease,
        [
            "Consult agricultural expert",
            "Monitor crop condition",
        ],
    )


@shared_task(
    bind=True,
    autoretry_for=(OperationalError,),  # Retry only DB-level transient errors
    retry_backoff=True,
    retry_backoff_max=600,
    retry_kwargs={"max_retries": 3},
)
def run_inference(self, upload_id: int):
    """
    Background ML inference task.

    Safe against:
    - Duplicate runs
    - Missing upload
    - DB race conditions
    - Model failures
    """

    logger.info(f"[Inference Start] Upload ID: {upload_id}")

    try:
        upload = Upload.objects.select_for_update().get(id=upload_id)
    except ObjectDoesNotExist:
        logger.warning(f"[Inference Abort] Upload {upload_id} does not exist.")
        return

    # Prevent duplicate processing
    if upload.status in ["processing", "approved"]:
        logger.info(f"[Inference Skip] Upload {upload_id} already in status {upload.status}")
        return

    try:
        upload.status = "processing"
        upload.save(update_fields=["status"])

        # 🔥 ML Inference
        result = predict(upload.file.path)

        with transaction.atomic():
            InferenceResult.objects.update_or_create(
                upload=upload,
                defaults={
                    "disease": result["disease"],
                    "confidence": result["confidence"],
                    "suggested_actions": generate_actions(result["disease"]),
                },
            )

            upload.status = "done"
            upload.save(update_fields=["status"])

        logger.info(f"[Inference Success] Upload {upload.id}")

    except Exception as e:
        logger.error(f"[Inference Error] Upload {upload_id}: {str(e)}")

        try:
            upload.status = "failed"
            upload.save(update_fields=["status"])
        except Exception as db_error:
            logger.critical(f"[Inference Critical] Failed to update status: {str(db_error)}")

        # Retry only for transient issues
        raise e