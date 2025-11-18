from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import Upload, InferenceResult
from .serializers import UploadSerializer, InferenceResultSerializer


# 🔹 Mock inference function (replace with real AI model later)
def mock_infer(image_path: str) -> dict:
    """
    Dummy AI logic – just returns a fixed disease.
    Later, you will:
    - load your ML model
    - preprocess the image
    - run prediction
    - return actual disease + confidence + suggestions
    """
    return {
        "disease": "Leaf Blight",
        "confidence": 0.92,
        "suggested_actions": [
            "Spray recommended fungicide",
            "Avoid overhead watering",
            "Remove heavily affected leaves",
        ],
    }


class UploadViewSet(viewsets.ModelViewSet):
    """
    /api/uploads/                   (GET, POST)
    /api/uploads/{id}/              (GET, PUT, DELETE)
    /api/uploads/{id}/run_inference/   (POST)
    """

    queryset = Upload.objects.all().order_by("-created_at")
    serializer_class = UploadSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        # attach logged-in user as owner
        serializer.save(owner=self.request.user)

    @action(detail=True, methods=["post"])
    def run_inference(self, request, pk=None):
        """
        Custom action:
        POST /api/uploads/{id}/run_inference/

        1. Takes the uploaded file
        2. Calls mock_infer()
        3. Saves InferenceResult
        4. Returns JSON with disease, confidence, suggestions
        """
        upload = self.get_object()

        if upload.upload_type != "image":
            return Response(
                {"detail": "Inference is only supported for image uploads right now."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Call dummy AI function
        result = mock_infer(upload.file.path)

        inf, created = InferenceResult.objects.get_or_create(
            upload=upload,
            defaults={
                "disease": result["disease"],
                "confidence": result["confidence"],
                "suggested_actions": result["suggested_actions"],
            },
        )

        # mark upload as processed
        upload.status = "done"
        upload.save()

        return Response(InferenceResultSerializer(inf).data, status=status.HTTP_200_OK)
