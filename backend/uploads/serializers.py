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
            "is_public",
            "created_at",
        ]
        read_only_fields = ["id", "owner", "status", "created_at", "is_public"]

    def validate_file(self, value):
        max_size = 5 * 1024 * 1024  # 5MB

        if value.size > max_size:
            raise serializers.ValidationError("File too large (max 5MB).")

        allowed_types = ["image/jpeg", "image/png"]

        if value.content_type not in allowed_types:
            raise serializers.ValidationError("Only JPEG and PNG allowed.")

        return value


class InferenceResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = InferenceResult
        fields = [
            "disease",
            "confidence",
            "suggested_actions",
            "created_at",
        ]