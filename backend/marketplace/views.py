from django.db import models
from rest_framework import viewsets, permissions
from rest_framework.exceptions import PermissionDenied
from .models import Product
from .serializers import ProductSerializer


class ProductViewSet(viewsets.ModelViewSet):
    serializer_class = ProductSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        user = self.request.user

        # 🛡 Admin sees all non-deleted products
        if user.is_authenticated and user.role == "admin":
            return Product.objects.filter(
                is_deleted=False
            ).order_by("-created_at")

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