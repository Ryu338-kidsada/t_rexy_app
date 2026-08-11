import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: const Center(
        child: Text(
          'Home Screen (Coming soon)',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      ),
    );
  }
}