import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // ไฟล์ที่ flutterfire configure สร้างให้อัตโนมัติ
import 'providers/auth_provider.dart';
import 'screens/get_started_screen.dart';
 
void main() async {
  // ต้องเรียกก่อน runApp เสมอ เพราะ Firebase.initializeApp เป็น async
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  runApp(const TRexyApp());
}
 
class TRexyApp extends StatelessWidget {
  const TRexyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'T-REXY',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const GetStartedScreen(),
      ),
    );
  }
}