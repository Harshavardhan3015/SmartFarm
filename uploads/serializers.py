from rest_framework import serializers
from .models import Upload, InferenceResult


class UploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Upload
        fields = [
            "id",
            "owner",
            "file",
            "upload_type",
            "status",
            "created_at",
        ]
        read_only_fields = ["id", "owner", "status", "created_at"]


class InferenceResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = InferenceResult
        fields = [
            "disease",
            "confidence",
            "suggested_actions",
            "created_at",
        ]
