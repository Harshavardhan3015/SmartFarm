from celery import shared_task
from .models import Farm, SensorReading
from .services.simulation_engine import simulate_next_state
from .services.health_engine import calculate_health
from .services.irrigation_engine import irrigation_decision


@shared_task
def run_simulation():
    farms = Farm.objects.all()

    for farm in farms:
        state = simulate_next_state(farm)
        health = calculate_health(state)
        irrigation = irrigation_decision(state)

        SensorReading.objects.create(
            farm=farm,
            temperature=state.temperature,
            humidity=state.humidity,
            soil_moisture=state.soil_moisture,
            soil_ph=state.soil_ph,
            nitrogen=state.nitrogen,
            phosphorus=state.phosphorus,
            potassium=state.potassium,
            health_score=health,
            irrigation_decision=irrigation,
        )