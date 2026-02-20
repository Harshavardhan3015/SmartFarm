from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated

from .models import Upload
from .serializers import UploadSerializer, InferenceResultSerializer
from .permissions import IsOwnerOrReadOnly
from uploads.tasks import async_run_inference


class UploadViewSet(viewsets.ModelViewSet):
    """
    /api/uploads/
    /api/uploads/{id}/
    /api/uploads/{id}/run_inference/
    """

    serializer_class = UploadSerializer
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        """
        Owners see their uploads; marketplace reads handled elsewhere.
        """
        return Upload.objects.filter(owner=self.request.user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    @action(detail=True, methods=["post"])
    def run_inference(self, request, pk=None):
        upload = self.get_object()

        # Prevent running inference if already processing or done
        if upload.status == "processing":
            return Response(
                {"detail": "Inference already in progress.", "status": upload.status},
                status=status.HTTP_202_ACCEPTED,
            )
        if upload.status == "done":
            # Return existing inference result
            try:
                result = upload.inferenceresult
                return Response(
                    InferenceResultSerializer(result).data,
                    status=status.HTTP_200_OK,
                )
            except Exception:
                return Response(
                    {"detail": "Inference already completed but result missing.", "status": upload.status},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

        # Queue async task
        async_run_inference.delay(upload.id)
        upload.status = "processing"
        upload.save()

        return Response(
            {"detail": "Inference started in background.", "status": upload.status},
            status=status.HTTP_202_ACCEPTED,
        )

    @action(detail=True, methods=["get"])
    def status(self, request, pk=None):
        """
        Get the current status of the upload and inference.
        """
        upload = self.get_object()
        response = {
            "upload_id": upload.id,
            "status": upload.status,
        }

        # Include result if inference is done
        if upload.status == "done":
            try:
                result = upload.inferenceresult
                response["result"] = InferenceResultSerializer(result).data
            except Exception:
                response["result"] = None

        return Response(response, status=status.HTTP_200_OK)