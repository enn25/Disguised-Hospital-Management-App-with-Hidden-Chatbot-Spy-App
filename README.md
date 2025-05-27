# 🏥 Disguised Hospital Management App with Hidden Chatbot (Spy App)

This is a **Flutter-based disguised application** that appears to be a hospital management system, but secretly embeds a **private chatbot** behind a hidden access gesture. The chatbot is hosted using **Firebase** and enables private communication between trusted users. The project was developed as a secure, experimental concept with Claude AI's assistance.

---

## 👁️‍🗨️ Core Concept

The app looks and functions like a basic hospital management app, showing tiles such as:
- Patient Records
- Doctor Directory
- Vaccine Info
- Appointment Scheduler

🔐 **Secret Access:**
- Tap and hold the **“Vaccine” tile three times** to unlock the **chatbot interface**.
- The chatbot is powered by Firebase (Firestore + Realtime Database).

---

## 🎥 Demo

> 📸 *Screenshots and screen recording are available at the end of this file.*

---

## 🛠️ Tech Stack

- **Flutter** (3.x)
- **Firebase** (Firestore, Realtime DB)
- **Dart**
- **State Management** (e.g., Provider or GetX)
- **GestureDetector** for long-press detection

---

## 🧪 Features

| Feature                     | Description                              |
|----------------------------|------------------------------------------|
| Disguised UI               | Looks like a hospital admin dashboard    |
| Secret Chatbot Access      | Triple long press on Vaccine tile        |
| Firebase-based Messaging   | Supports secure, real-time communication |
| Hidden Mode Persistence    | Returns to dashboard when screen is off  |
| Lightweight & Deceptive UI | No trace of spy elements in layout       |

---

## 🔐 How It Works

1. App opens to a **hospital dashboard**
2. User **long-presses “Vaccine” tile three times**
3. Hidden route is triggered to open `ChatScreen()`
4. Firebase stores and syncs messages in real-time
5. On screen off or tap of “Kill Switch,” app returns to dashboard

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/spy-chat-hospital-app.git
cd spy-chat-hospital-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

- Add your Firebase project files (`google-services.json` for Android and `GoogleService-Info.plist` for iOS)
- Ensure Firestore and Realtime Database are enabled

### 4. Run the App

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── chat_screen.dart
│   └── splash_screen.dart
├── services/
│   ├── auth_service.dart
│   └── chat_service.dart
├── widgets/
│   ├── dashboard_tile.dart
│   └── message_bubble.dart

android/
└── app/
    └── src/
        └── main/
            └── res/
                ├── mipmap-hdpi/
                ├── mipmap-mdpi/
                ├── mipmap-xhdpi/
                ├── mipmap-xxhdpi/
                └── mipmap-xxxhdpi/

assets/
├── screenshot_dashboard.png
├── screenshot_chatbot.png
├── demo_screenrecord.mp4
```

---

## ⚠️ Disclaimer

This project was created for **educational and personal experimentation only**. While it features a disguised interface, it **must not be used for malicious spying, unauthorized surveillance, or deceptive purposes**. Always respect privacy and legal boundaries.

> ⚠️ **App Icon Notice:**  
> The default application icon was removed due to copyright concerns.  
> To add your own custom app icon, place image files in the appropriate directories:

```
android/app/src/main/res/
├── mipmap-hdpi/
├── mipmap-mdpi/
├── mipmap-xhdpi/
├── mipmap-xxhdpi/
└── mipmap-xxxhdpi/
```

Each folder should contain a version of your app icon (e.g., `ic_launcher.png`) optimized for that resolution bucket.

---

## 📸 Screenshots & Recording

<div align="center">
  <img src="https://github.com/user-attachments/assets/c29ea8b9-bcf8-4399-9fe2-2bd508e4ce3c" alt="random_announcements" width="400"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/bfc7c4ad-03c2-4078-9dfe-12dc7b20272b" alt="static_random_live" width="400"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/c6f3d40f-c4e3-49e2-a5f2-a882ce48d66a" alt="dashboard" width="400"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/24a61fc6-bfd6-4c80-9915-685ea93ece6a" alt="chatting_page" width="400"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/326b389e-b1f7-44bd-9453-0ce9888409e3" alt="firebase_chat" width="400"/>
  <br/>
  <img src="https://github.com/user-attachments/assets/657395a0-0cc9-4be8-a445-44df0c9ff92e" alt="profile_page" width="400"/>
</div>


https://github.com/user-attachments/assets/48206ec7-004e-407a-824f-75d33f2ed647

https://github.com/user-attachments/assets/a7ed61c3-08dc-4898-a90b-2f26074fa3a9




