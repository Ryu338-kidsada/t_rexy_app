T-REXY

แอพศึกษาข้อมูลไดโนเสาร์ พัฒนาด้วย Flutter + Firebase

Tech Stack
Flutter (Dart) — Android
Firebase Authentication — Email/Password (รองรับ Google/Facebook เพิ่มได้ในอนาคต)
Cloud Firestore — เก็บข้อมูลไดโนเสาร์
Provider — state management
โครงสร้างโปรเจค
lib/
├── main.dart
├── firebase_options.dart
├── screens/          # หน้าจอต่างๆ
├── widgets/          # UI components ใช้ซ้ำได้
├── providers/         # state management
├── repositories/      # ติดต่อ Firebase
└── utils/             # helper functions, สี, validators
Setup
Clone repo นี้
รัน flutter pub get
ตั้งค่า Firebase ของตัวเอง: flutterfire configure
รันแอพ: flutter run
หน้าจอ
 Get Started
 Login
 Sign Up
 Home (กำลังพัฒนา)
ผู้พัฒนา

โปรเจคนี้เป็นส่วนหนึ่งของการเรียน ระดับชั้น ปวช.2