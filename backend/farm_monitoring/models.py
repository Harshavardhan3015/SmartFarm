from django.db import models
from django.conf import settings


class Farm(models.Model):
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="farms"
    )
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=255)
    season = models.CharField(
        max_length=20,
        choices=[
            ("summer", "Summer"),
            ("monsoon", "Monsoon"),
            ("winter", "Winter"),
        ],
        default="summer"
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class FarmState(models.Model):
    farm = models.OneToOneField(
        Farm,
        on_delete=models.CASCADE,
        related_name="state"
    )

    temperature = models.FloatField(default=28)
    humidity = models.FloatField(default=60)
    soil_moisture = models.FloatField(default=55)
    soil_ph = models.FloatField(default=6.5)
    nitrogen = models.FloatField(default=40)
    phosphorus = models.FloatField(default=35)
    potassium = models.FloatField(default=45)

    updated_at = models.DateTimeField(auto_now=True)


class SensorReading(models.Model):
    farm = models.ForeignKey(
        Farm,
        on_delete=models.CASCADE,
        related_name="readings"
    )

    temperature = models.FloatField()
    humidity = models.FloatField()
    soil_moisture = models.FloatField()
    soil_ph = models.FloatField()
    nitrogen = models.FloatField()
    phosphorus = models.FloatField()
    potassium = models.FloatField()

    health_score = models.FloatField()
    irrigation_decision = models.CharField(max_length=200)

    created_at = models.DateTimeField(auto_now_add=True)