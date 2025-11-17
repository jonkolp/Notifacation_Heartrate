# 🩺 Health Monitor System — FastAPI + Flutter

This project is a health alert prototype that uses a trained TensorFlow model to detect dangerous health conditions based on heart rate, body temperature, and oxygen saturation data. The system consists of:

- ⚙️ A **FastAPI backend** to serve the model and handle predictions.
- 📱 A **Flutter frontend** that streams mock health data and alerts users to danger conditions.

---

## 🚀 Backend: FastAPI + TensorFlow

### 1️⃣ Setup Virtual Environment

```bash
# Create a virtual environment
python -m venv venv

# Activate it
# On Windows
venv\Scripts\activate
# On macOS/Linux
source venv/bin/activate
```

### 2️⃣ Install Dependencies
```bash
pip install -r requirements.txt
```
If you don’t have a requirements.txt, install manually:
```bash
pip install fastapi uvicorn pydantic tensorflow numpy joblib scikit-learn
```
### 3️⃣ Add Required Files

Make sure these files are in your project directory:

    health_alert_model.h5 — your trained TensorFlow model

    scaler.save — the StandardScaler used during training (saved with joblib)

### 4️⃣ Run the FastAPI App
```bash
uvicorn app:app --reload
```
    App runs at: http://127.0.0.1:8000

    POST endpoint: http://127.0.0.1:8000/predict

## 📱 Frontend: Flutter App
### 1️⃣ Setup Flutter

Ensure Flutter is installed:
```bash
flutter --version
```

If not installed: Flutter Installation Guide
### 2️⃣ Get Dependencies

Navigate to your Flutter project folder and run:

flutter pub get

### 3️⃣ Connect to FastAPI Server

In your HealthModelService (ml_model_service.dart), confirm the IP and port match your backend:

final String apiUrl = "http://10.0.2.2:8000/predict"; // For Android emulator

For a real device, use your machine's local network IP (e.g., http://192.168.1.x:8000/predict) and ensure both devices are on the same WiFi.
### 4️⃣ Run the Flutter App
```bash
flutter run
```
The app simulates health data, sends it to the FastAPI model, and displays alerts.
- 🧪 Example API Call (Optional)

Test the FastAPI API using curl or Postman:
```bash
curl -X POST http://127.0.0.1:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"heart_rate": 72, "temperature": 36.7, "oxygen": 98}'
```
```bash
Expected response:

{
  "prediction": 0.12
}
```
- 📂 Project Structure
```bash
health_monitor/
├── backend/
│   ├── main.py
│   ├── health_alert_model.h5
│   ├── scaler.save
├── frontend/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── ml_model_service.dart
│   │   └── health_data_simulator.dart
```
- ✅ Features

     Real-time danger detection

    Notification system

    Custom model deployment via FastAPI

    Flutter UI with dynamic updates

- 📌 Notes

    If the model returns incorrect predictions, retrain or re-tune the model.

    Ensure CORS issues are handled if deploying to production.

    Use https and device IP for real-world testing.