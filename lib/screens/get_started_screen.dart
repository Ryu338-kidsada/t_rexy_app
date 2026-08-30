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
        // รูปพื้นหลังป่าจริง
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_jungle.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            )
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
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo_trexy.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
 
                const SizedBox(height: 20),
 
                const Text(
                  'SIAM LAP',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: AppColors.white,
                  ),
                ),
 
                const Spacer(flex: 3),
 
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
 
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}