from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Farm, SensorReading
from .serializers import FarmSerializer, SensorReadingSerializer


class FarmViewSet(viewsets.ModelViewSet):
    serializer_class = FarmSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Farm.objects.filter(owner=self.request.user)

    def perform_create(self, serializer):
        farm = serializer.save(owner=self.request.user)
        # Create default state automatically
        from .models import FarmState
        FarmState.objects.create(farm=farm)


class SensorReadingViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = SensorReadingSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return SensorReading.objects.filter(
            farm__owner=self.request.user
        ).order_by("-created_at")