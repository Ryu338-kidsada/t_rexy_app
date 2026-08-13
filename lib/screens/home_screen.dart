import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      appBar: AppBar(
        backgroundColor: AppColors.deepForest,
        elevation: 0,
        title: const Text(
          'Tyrannosaurus Rex',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const ModelViewer(
        src: 'assets/models/tyrannosaurus_rex_skeleton.glb',
        alt: 'โครงกระดูก Tyrannosaurus Rex',
        ar: false,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.transparent,
        loading: Loading.eager, // โหลดโมเดลทันทีตอนเปิดหน้า
      ),
    );
  }
}