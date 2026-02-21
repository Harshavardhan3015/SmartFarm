import random


def seasonal_temperature(season):
    if season == "summer":
        return random.uniform(30, 38)
    if season == "monsoon":
        return random.uniform(24, 32)
    if season == "winter":
        return random.uniform(15, 24)


def simulate_next_state(farm):
    state = farm.state

    # Temperature based on season
    state.temperature = seasonal_temperature(farm.season)

    # Evaporation
    evaporation = state.temperature * 0.03
    state.soil_moisture -= evaporation

    # Simulated rain in monsoon
    if farm.season == "monsoon":
        rain = random.uniform(0, 10)
        if rain > 5:
            state.soil_moisture += 10

    # Nutrient depletion
    state.nitrogen -= 0.5
    state.phosphorus -= 0.3
    state.potassium -= 0.4

    # Clamp values
    state.soil_moisture = max(10, min(80, state.soil_moisture))
    state.nitrogen = max(5, state.nitrogen)

    state.save()

    return state