from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel, ValidationError
import tensorflow as tf
import numpy as np
import joblib

scaler = joblib.load("scaler.pkl")

app = FastAPI()

# Define input schema
class HealthInput(BaseModel):
    heart_rate: float
    temperature: float
    oxygen: float

# Try to load the model and handle errors
try:
    model = tf.keras.models.load_model("health_alert_model.h5", compile=False)
    print("✅ Model loaded successfully.")
except Exception as e:
    print(f"❌ Failed to load model: {e}")
    model = None

# Pydantic v2: Import RequestValidationError for request validation exceptions
from fastapi.exceptions import RequestValidationError

# Updated: handle validation errors for requests
@app.exception_handler(RequestValidationError)
async def request_validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code=422,
        content={"error": "Invalid input data", "details": exc.errors()},
    )

@app.post("/predict")
async def predict(input: HealthInput):
    if model is None:
        raise HTTPException(status_code=500, detail="Model not available")

    try:
        features = np.array([[input.heart_rate, input.temperature, input.oxygen]])
        scaled_features = scaler.transform(features)  # 👈 scale before prediction
        prediction = model.predict(scaled_features)[0][0]
        print(f"Prediction: {prediction}")
        return {"prediction": float(prediction)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {e}")

