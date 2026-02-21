from django.contrib import admin
from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "title",
        "owner",
        "price",
        "quantity",
        "status",
        "created_at",
    )
    list_filter = ("status",)
    search_fields = ("title", "owner__username")