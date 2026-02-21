from django.db import models
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User

User = get_user_model()


class Upload(models.Model):
    UPLOAD_TYPES = (
        ("image", "Image"),
        ("document", "Document"),
    )

    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    file = models.FileField(upload_to="uploads/%Y/%m/%d/")
    upload_type = models.CharField(max_length=20, choices=UPLOAD_TYPES, default="image")
    status = models.CharField(max_length=20, default="pending")
    is_public = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.owner} - {self.file.name} - {self.status}"


class InferenceResult(models.Model):
    upload = models.OneToOneField(
        Upload, on_delete=models.CASCADE, related_name="inference"
    )
    disease = models.CharField(max_length=200)
    confidence = models.FloatField()
    # list of text suggestions, e.g. ["Spray organic fungicide", "Avoid overwatering"]
    suggested_actions = models.JSONField(default=list)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.disease} ({self.confidence:.2f})"
    
class CropImage(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='crop_images/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.uploaded_at}"