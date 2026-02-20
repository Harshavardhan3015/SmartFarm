from celery import shared_task
from uploads.models import Upload
from ml_inference.services import run_inference_on_image
import logging

logger = logging.getLogger(__name__)

@shared_task(bind=True, max_retries=3, default_retry_delay=60)
def async_run_inference(self, upload_id):
    """
    Asynchronous ML inference with automatic retries.
    Updates Upload.status and logs progress.
    """
    try:
        upload = Upload.objects.get(id=upload_id)
        
        # Prevent double-processing
        if upload.status in ["done", "processing"]:
            logger.info(f"Upload ID {upload_id} already {upload.status}. Skipping inference.")
            return

        # Mark as processing
        upload.status = "processing"
        upload.save()
        logger.info(f"Started inference for Upload ID {upload_id}")

        # Run ML service
        inf = run_inference_on_image(upload)

        logger.info(f"Inference completed for Upload ID {upload_id}: Disease={inf.disease}")

    except Upload.DoesNotExist:
        logger.error(f"Upload not found: {upload_id}")

    except Exception as e:
        # Mark as failed before retrying
        try:
            upload = Upload.objects.get(id=upload_id)
            upload.status = "failed"
            upload.save()
        except Exception:
            pass  # Ignore if upload not found while failing

        logger.exception(f"Inference failed for Upload ID: {upload_id}. Retrying...")
        raise self.retry(exc=e)