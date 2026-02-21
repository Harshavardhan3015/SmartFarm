from celery import shared_task
from django.db import transaction
from django.utils import timezone
import logging
import random

from .models import Upload, InferenceResult

logger = logging.getLogger(__name__)


@shared_task(
    bind=True,
    autoretry_for=(Exception,),
    retry_backoff=True,        # exponential backoff
    retry_backoff_max=600,     # max 10 min delay
    retry_kwargs={"max_retries": 3},
)
def run_inference(self, upload_id):

    try:
        upload = Upload.objects.get(id=upload_id)

        # Mark as processing
        upload.status = "processing"
        upload.save(update_fields=["status"])

        # --- SIMULATED ML LOGIC ---
        # Replace this with your real ML inference call

        disease_list = ["Leaf Blight", "Rust", "Healthy", "Powdery Mildew"]
        disease = random.choice(disease_list)
        confidence = round(random.uniform(0.75, 0.99), 2)

        # Simulate random failure (for testing retry)
        # Remove this in production
        if random.random() < 0.2:
            raise Exception("Simulated ML crash")

        with transaction.atomic():
            InferenceResult.objects.update_or_create(
                upload=upload,
                defaults={
                    "disease": disease,
                    "confidence": confidence,
                    "suggested_actions": [
                        "Apply fungicide",
                        "Improve irrigation control",
                        "Monitor for 7 days",
                    ],
                },
            )

            upload.status = "done"
            upload.save(update_fields=["status"])

        logger.info(f"Inference successful for upload {upload.id}")

    except Exception as e:
        logger.error(f"Inference failed for upload {upload_id}: {str(e)}")

        upload = Upload.objects.filter(id=upload_id).first()
        if upload:
            upload.status = "failed"
            upload.save(update_fields=["status"])

        raise self.retry(exc=e)