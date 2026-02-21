from django.db import models
from rest_framework import viewsets, permissions, status
from rest_framework.exceptions import PermissionDenied
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Product
from .serializers import ProductSerializer


class ProductViewSet(viewsets.ModelViewSet):
    serializer_class = ProductSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        user = self.request.user

        # 🛡 Admin sees ALL products (including deleted)
        if user.is_authenticated and user.role == "admin":
            return Product.objects.all().order_by("-created_at")

        # 👤 Authenticated farmer
        if user.is_authenticated:
            return Product.objects.filter(
                models.Q(status="active") | models.Q(owner=user),
                is_deleted=False,
            ).order_by("-created_at")

        # 🌍 Anonymous
        return Product.objects.filter(
            status="active",
            is_deleted=False,
        ).order_by("-created_at")

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def perform_update(self, serializer):
        product = self.get_object()

        if self.request.user.role == "admin":
            serializer.save()
            return

        if product.owner == self.request.user:
            serializer.save()
            return

        raise PermissionDenied("You do not have permission to update this product.")

    def perform_destroy(self, instance):
        if self.request.user.role == "admin":
            instance.soft_delete()
            return

        if instance.owner == self.request.user:
            instance.soft_delete()
            return

        raise PermissionDenied("You do not have permission to delete this product.")

    # 🔥 Restore endpoint (Admin only)
    @action(detail=True, methods=["post"])
    def restore(self, request, pk=None):
        product = self.get_object()

        if request.user.role != "admin":
            return Response(
                {"detail": "Only admin can restore products."},
                status=status.HTTP_403_FORBIDDEN,
            )

        product.restore()

        return Response(
            {"detail": "Product restored successfully."},
            status=status.HTTP_200_OK,
        )