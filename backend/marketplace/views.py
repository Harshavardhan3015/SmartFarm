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

        # 🛡 Admin → can see everything
        if user.is_authenticated and user.role == "admin":
            return Product.objects.all().order_by("-created_at")

        # 👤 Authenticated Farmer
        if user.is_authenticated:
            return Product.objects.filter(
                models.Q(status="active") | models.Q(owner=user)
            ).order_by("-created_at")

        # 🌍 Anonymous → only active products
        return Product.objects.filter(status="active").order_by("-created_at")

    def perform_create(self, serializer):
        if not self.request.user.is_authenticated:
            raise PermissionDenied("Authentication required to create products.")

        serializer.save(owner=self.request.user)

    def perform_update(self, serializer):
        product = self.get_object()

        # 🛡 Admin can update anything
        if self.request.user.role == "admin":
            serializer.save()
            return

        # 👤 Owner can update own product
        if product.owner == self.request.user:
            serializer.save()
            return

        raise PermissionDenied("You do not have permission to update this product.")

    def perform_destroy(self, instance):
        # 🛡 Admin can delete anything
        if self.request.user.role == "admin":
            instance.delete()
            return

        # 👤 Owner can delete own product
        if instance.owner == self.request.user:
            instance.delete()
            return

        raise PermissionDenied("You do not have permission to delete this product.")