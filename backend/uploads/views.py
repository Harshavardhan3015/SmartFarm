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
    """
    /api/uploads/
    /api/uploads/{id}/
    /api/uploads/{id}/run_inference/
    /api/uploads/{id}/approve/
    """

    serializer_class = UploadSerializer
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        """
        Farmers see only their uploads.
        Admins see all uploads.
        """
        user = self.request.user

        if user.role == "admin":
            return Upload.objects.all().order_by("-created_at")

        return Upload.objects.filter(owner=user).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    # -----------------------------
    # RUN INFERENCE
    # -----------------------------
    @action(detail=True, methods=["post"])
    def run_inference(self, request, pk=None):
        upload = self.get_object()

        if upload.status == "processing":
            return Response(
                {"detail": "Inference already in progress.", "status": upload.status},
                status=status.HTTP_202_ACCEPTED,
            )

        if upload.status == "done":
            try:
                result = upload.inferenceresult
                return Response(
                    InferenceResultSerializer(result).data,
                    status=status.HTTP_200_OK,
                )
            except Exception:
                return Response(
                    {
                        "detail": "Inference already completed but result missing.",
                        "status": upload.status,
                    },
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

        run_inference.delay(upload.id)
        upload.status = "processing"
        upload.save()

        return Response(
            {"detail": "Inference started in background.", "status": upload.status},
            status=status.HTTP_202_ACCEPTED,
        )

    # -----------------------------
    # CHECK STATUS
    # -----------------------------
    @action(detail=True, methods=["get"])
    def status(self, request, pk=None):
        upload = self.get_object()

        response = {
            "upload_id": upload.id,
            "status": upload.status,
        }

        if upload.status == "done":
            try:
                result = upload.inferenceresult
                response["result"] = InferenceResultSerializer(result).data
            except Exception:
                response["result"] = None

        return Response(response, status=status.HTTP_200_OK)

    # -----------------------------
    # ADMIN APPROVAL
    # -----------------------------
    @action(
        detail=True,
        methods=["post"],
        permission_classes=[IsAuthenticated, IsAdminRole],
    )
    def approve(self, request, pk=None):
        """
        Only admin can approve an upload and make it public.
        """
        upload = self.get_object()

        if upload.status != "done":
            return Response(
                {"detail": "Cannot approve before inference is completed."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        upload.is_public = True
        upload.status = "approved"
        upload.save()

        return Response(
            {"detail": "Upload approved and published to marketplace."},
            status=status.HTTP_200_OK,
        )