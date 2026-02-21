from django.db import models
from django.conf import settings


class Upload(models.Model):

    UPLOAD_TYPE_CHOICES = [
        ("image", "Image"),
        ("document", "Document"),
    ]

    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("processing", "Processing"),
        ("done", "Done"),
        ("approved", "Approved"),
        ("failed", "Failed"),
    ]

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="uploads",
    )

    file = models.FileField(upload_to="uploads/%Y/%m/%d/")
    upload_type = models.CharField(
        max_length=20,
        choices=UPLOAD_TYPE_CHOICES,
        default="image",
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="pending",
    )

    is_public = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Upload {self.id} - {self.owner.username}"


class InferenceResult(models.Model):
    upload = models.OneToOneField(
        Upload,
        on_delete=models.CASCADE,
        related_name="inference",
    )

    disease = models.CharField(max_length=200)
    confidence = models.FloatField()
    suggested_actions = models.JSONField(default=list)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Inference for Upload {self.upload.id}"