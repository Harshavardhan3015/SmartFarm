from django.contrib import admin
from .models import Upload, InferenceResult

@admin.register(Upload)
class UploadAdmin(admin.ModelAdmin):
    list_display = ("id", "owner", "upload_type", "status", "created_at")
    list_filter = ("upload_type", "status")
    search_fields = ("owner__username",)

@admin.register(InferenceResult)
class InferenceResultAdmin(admin.ModelAdmin):
    list_display = ("upload", "disease", "confidence", "created_at")

