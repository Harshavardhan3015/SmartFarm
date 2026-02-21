def irrigation_decision(state):
    if state.soil_moisture < 30:
        return "Irrigate immediately."
    if state.soil_moisture < 45:
        return "Monitor moisture closely."
    return "No irrigation required."