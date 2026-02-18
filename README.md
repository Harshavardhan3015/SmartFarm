# 🌱 Smart Farming Mobile Application

## 📌 Project Overview

Smart Farming is a mobile-based agricultural assistance system designed to help farmers monitor crop health, detect plant diseases, receive treatment recommendations, and access agricultural marketplace services.

The system follows a clean and scalable architecture:

- **Frontend:** Flutter (Mobile Application)
- **Backend:** Django (REST APIs)
- **Machine Learning:** Integrated in Django (Final Phase)
- **Architecture Principle:** Backend-centric logic (Flutter handles UI only)

---

# 🏗️ Project Structure

SmartFarming/
│
├── backend/        # Django Backend (Core logic & APIs)
│
└── mobile_app/     # Flutter Mobile Application (UI Layer)

---

# 📱 Flutter Mobile Application

## ✅ Features Implemented

- Home Dashboard
- Farm Visualization Grid
- Health Legend (Healthy / Risk / Diseased)
- Upload Plant Image Screen
- Disease Result Screen (UI)
- Voice Assistant Screen (UI)
- Scan Document Screen (UI)
- Marketplace Screen
- User Authentication UI
  - Role Selection (User / Admin)
  - User Login
  - Admin Login
  - User Signup

---

## 📂 Flutter Folder Structure

lib/
├── screens/      # Full application screens
├── widgets/      # Reusable UI components
├── services/     # API service stubs
├── models/       # Data models
├── utils/        # Constants & helpers
└── routes/       # Centralized navigation

### Architecture Rules

- Screens → Full pages
- Widgets → Reusable UI components
- Services → API calls only (No business logic)
- Models → Data representation
- Utils → Constants & helper methods
- Routes → Navigation management

---

## 🚀 Running the Flutter App

1. Navigate to the mobile app directory:
   cd mobile_app

2. Install dependencies:
   flutter pub get

3. Run the application:
   flutter run

---

# 🖥️ Django Backend

## 🔹 Backend Responsibilities

All core logic and intelligence are handled inside Django:

- User authentication & authorization
- Admin management
- Image upload & storage
- ML-based disease detection (planned)
- Voice-to-text processing (planned)
- OCR document scanning (planned)
- Marketplace logic
- Recommendation engine

Flutter does NOT contain any decision-making logic.

---

## 📂 Django Backend Structure (Planned Modular Apps)

backend/
├── accounts/      # Authentication APIs
├── crops/         # Image upload + ML inference
├── voice/         # Speech processing
├── documents/     # OCR processing
├── marketplace/   # Products & orders
└── core/          # Shared utilities

---

# 🔄 System Flow

## 🖼 Image Upload Flow

Flutter → Django API → ML Model → JSON Response → Flutter displays result

## 🎙 Voice Query Flow

Flutter → Audio Upload → Django Speech-to-Text → NLP → Response → Flutter display

## 📄 Document Scan Flow

Flutter → Upload Image/PDF → Django OCR → Extract Text → Analysis → Display

---

# 🔐 Authentication Flow

1. User selects role (User/Admin)
2. Credentials sent to Django API
3. Django validates credentials
4. Session or token returned
5. Protected screens enabled

Admin accounts are managed through Django Admin Panel.

---

# 🛠️ Technology Stack

Frontend:
- Flutter

Backend:
- Django
- Django REST Framework

Database:
- SQLite (Development)
- PostgreSQL (Production Ready)

Machine Learning (Planned):
- TensorFlow / PyTorch

OCR (Planned):
- Tesseract / EasyOCR

Voice Processing (Planned):
- SpeechRecognition / Whisper

---

# 📌 Current Project Status

✔ Flutter UI – Completed  
✔ Navigation – Completed  
✔ Authentication UI – Completed  
✔ Backend Structure – Ready  
⏳ Django API Integration – In Progress  
⏳ ML Model Training – Planned (Final Phase)

---

# 👨‍💻 Suggested Team Role Distribution

- Member 1 → Django Authentication & APIs
- Member 2 → ML Model Training & Integration
- Member 3 → OCR & Voice Processing
- Member 4 → Flutter Integration & Testing

---

# 🎯 Project Goals

- Assist farmers with plant disease detection
- Provide actionable treatment recommendations
- Enable digital agricultural marketplace
- Integrate AI-driven agricultural insights
- Maintain clean, scalable architecture

---

# 🔮 Future Enhancements

- Weather API integration
- IoT sensor data integration
- Push notifications
- Online payment gateway
- Real-time crop monitoring

---

# 📜 License

This project is developed for academic and research purposes.

---

# 🌾 Final Architecture Principle

Flutter handles UI only.  
Django handles all business logic and intelligence.
