from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated

from .models import Upload
from .serializers import UploadSerializer, InferenceResultSerializer
from .permissions import IsOwnerOrReadOnly
from users.permissions import IsAdminRole
from uploads.tasks import run_inference


class UploadViewSet(viewsets.ModelViewSet):
    serializer_class = UploadSerializer
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        user = self.request.user

        if user.role == "admin":
            return Upload.objects.filter(
                is_deleted=False
            ).order_by("-created_at")

        return Upload.objects.filter(
            owner=user,
            is_deleted=False
        ).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def perform_destroy(self, instance):
        if self.request.user.role == "admin" or instance.owner == self.request.user:
            instance.soft_delete()
            return

        return Response(
            {"detail": "You do not have permission to delete this upload."},
            status=status.HTTP_403_FORBIDDEN,
        )

    # -----------------------------
    # RUN INFERENCE
    # -----------------------------
    @action(detail=True, methods=["post"])
    def run_inference(self, request, pk=None):
        upload = self.get_object()

        if upload.status == "processing":
            return Response(
                {"detail": "Inference already in progress."},
                status=status.HTTP_202_ACCEPTED,
            )

        if upload.status in ["done", "approved"]:
            try:
                result = upload.inference
                return Response(
                    InferenceResultSerializer(result).data,
                    status=status.HTTP_200_OK,
                )
            except Exception:
                return Response(
                    {"detail": "Result missing."},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

        run_inference.delay(upload.id)

        return Response(
            {"detail": "Inference started."},
            status=status.HTTP_202_ACCEPTED,
        )

    # -----------------------------
    # STATUS CHECK
    # -----------------------------
    @action(detail=True, methods=["get"])
    def status(self, request, pk=None):
        upload = self.get_object()

        response = {
            "upload_id": upload.id,
            "status": upload.status,
        }

        if upload.status in ["done", "approved"]:
            try:
                result = upload.inference
                response["result"] = InferenceResultSerializer(result).data
            except Exception:
                response["result"] = None

        return Response(response)

    # -----------------------------
    # ADMIN APPROVAL
    # -----------------------------
    @action(
        detail=True,
        methods=["post"],
        permission_classes=[IsAuthenticated, IsAdminRole],
    )
    def approve(self, request, pk=None):
        upload = self.get_object()

        if upload.status != "done":
            return Response(
                {"detail": "Cannot approve before inference completes."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        upload.is_public = True
        upload.status = "approved"
        upload.save(update_fields=["is_public", "status"])

        return Response(
            {"detail": "Upload approved."},
            status=status.HTTP_200_OK,
        )