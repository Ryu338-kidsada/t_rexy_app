import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
 
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TODO: เปลี่ยนเป็นรูปพื้นหลังป่าจริงจาก Figma
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/bg_get_started.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // ตอนนี้ใช้ gradient แทนไปก่อน ระหว่างรอไฟล์รูปจริง
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF14432B),
              AppColors.deepForest,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
 
                // โลโก้วงกลม (กะโหลกไดโนเสาร์)
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1),
                    // TODO: เปลี่ยนเป็นรูปโลโก้จริงจาก Figma
                    // image: const DecorationImage(
                    //   image: AssetImage('assets/images/logo_trexy.png'),
                    //   fit: BoxFit.cover,
                    // ),
                    color: Colors.white10,
                  ),
                  child: const Icon(
                    Icons.pets, // placeholder ไอคอน รอรูปจริง
                    size: 60,
                    color: AppColors.white,
                  ),
                ),
 
                const SizedBox(height: 20),
 
                const Text(
                  'T-REXY',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: AppColors.white,
                  ),
                ),
 
                const Spacer(flex: 5),
 
                PrimaryButton(
                  label: 'Get Started',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
 
                const SizedBox(height: 12),
 
                const Text(
                  'Log in or create an account to access the experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.whiteFaded, fontSize: 12),
                ),
 
                Spacer(flex: 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}