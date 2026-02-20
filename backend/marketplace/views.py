from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from uploads.models import Upload
from uploads.serializers import UploadSerializer

class MarketplaceViewSet(viewsets.ReadOnlyModelViewSet):
    """
    /api/marketplace/uploads/
    Only approved uploads are visible in marketplace.
    """

    serializer_class = UploadSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        # Marketplace shows only public uploads
        return Upload.objects.filter(is_public=True).order_by("-created_at")