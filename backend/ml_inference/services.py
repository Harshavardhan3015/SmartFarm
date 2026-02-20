"""
ML Inference Services
"""

from uploads.models import Upload, InferenceResult

# 🔹 Mock inference (replace with real model later)
def run_inference_on_image(upload: Upload) -> InferenceResult:
    """
    Run inference on a single image upload.
    Handles status update and result creation.
    """
    if upload.upload_type != "image":
        raise ValueError("Inference supported only for image uploads.")

    if upload.status == "done":
        raise ValueError("Inference already completed.")

    # Mark as processing
    upload.status = "processing"
    upload.save()

    try:
        # MOCKED ML LOGIC
        result = {
            "disease": "Leaf Blight",
            "confidence": 0.92,
            "suggested_actions": [
                "Spray recommended fungicide",
                "Avoid overhead watering",
                "Remove heavily affected leaves",
            ],
        }

        # Save inference result
        inf = InferenceResult.objects.create(
            upload=upload,
            disease=result["disease"],
            confidence=result["confidence"],
            suggested_actions=result["suggested_actions"],
        )

        upload.status = "done"
        upload.save()

    except Exception as e:
        upload.status = "failed"
        upload.save()
        raise RuntimeError("Inference failed.") from e

    return inf