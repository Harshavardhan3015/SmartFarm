from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    model = User

    list_display = (
        "id",
        "username",
        "email",
        "role",
        "is_verified",
        "is_staff",
        "is_active",
        "date_joined",
    )

    list_filter = (
        "role",
        "is_verified",
        "is_staff",
        "is_active",
    )

    fieldsets = UserAdmin.fieldsets + (
        (
            "Additional Info",
            {
                "fields": (
                    "role",
                    "phone",
                    "is_verified",
                    "created_at",
                )
            },
        ),
    )

    readonly_fields = ("created_at",)