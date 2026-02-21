from rest_framework.routers import DefaultRouter
from .views import FarmViewSet, SensorReadingViewSet

router = DefaultRouter()
router.register(r"farms", FarmViewSet, basename="farm")
router.register(r"readings", SensorReadingViewSet, basename="reading")

urlpatterns = router.urls