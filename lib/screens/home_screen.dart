import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import 'get_started_screen.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

const _accentGreen = Color(0xFF6FCF3C);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await context.read<AuthProvider>().signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.displayName ?? 'Guest';

      return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bg_jungle.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.85),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
        child: Column(
          children: [
            _HeaderSection(
              userName: userName,
              onLogout: () => _handleLogout(context),
            ),
            const Divider(color: _accentGreen, thickness: 2, height: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RAPTOR',
                      style: TextStyle(
                        color: _accentGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Siamraptor',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'suwatii',
                      style: TextStyle(
                        color: Color(0xFFB6E388),
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'สยามแรปเตอร์ สุวัธนี่ · ตั้งชื่อโดย Chokchaloemwong',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    const SizedBox(height: 16),

                    const _DinosaurMediaViewer(),

                    const SizedBox(height: 20),
                    const Divider(color: Color.fromARGB(75, 112, 207, 60), thickness: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: _StatItem(label: 'ความยาว', value: '10 เมตร')),
                        Expanded(child: _StatItem(label: 'น้ำหนัก', value: '3-4 ตัน')),
                        Expanded(child: _StatItem(label: 'ฟัน', value: '60 ซี่')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color.fromARGB(75, 112, 207, 60), thickness: 1),
                    const SizedBox(height: 20),
                    const Text(
                      'เจาะลึก Siam Raptor',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ข้อมูลเชิงลึกเกี่ยวกับพฤติกรรม ลักษณะทางกายภาพ และวิวัฒนาการ',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        _TabChip(label: 'เรื่องราว', selected: true),
                        SizedBox(width: 8),
                        _TabChip(label: 'ใบไม้ลาย'),
                        SizedBox(width: 8),
                        _TabChip(label: 'กายวิภาค'),
                        SizedBox(width: 8),
                        _TabChip(label: 'เพิ่มเติม'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: _accentGreen.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ข้อมูล',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'โลกที่มันเคยเดิน',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'สำรวจแผนที่ประเทศที่พบซากดึกดำบรรพ์และแหล่งฟอสซิล',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'ภาพสถานที่ 16:9',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const _HeaderSection({required this.userName, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo_trexy.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$userName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Welcome to T-REX dinosure',
                  style: TextStyle(color: AppColors.whiteFaded, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: _accentGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _accentGreen.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? _accentGreen : Colors.grey.shade700),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _accentGreen : Colors.grey.shade400,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DinosaurMediaViewer extends StatefulWidget {
  const _DinosaurMediaViewer();

  @override
  State<_DinosaurMediaViewer> createState() => _DinosaurMediaViewerState();
}

class _DinosaurMediaViewerState extends State<_DinosaurMediaViewer> {
  bool _is3D = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(235, 13, 43, 29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(207, 42, 119, 0).withOpacity(0.5), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // เนื้อหาหลัก: สลับ 2D/3D ตามปุ่มที่กด
          Positioned.fill(
            child: _is3D
                ? ModelViewer(
                    src: 'assets/models/tyrannosaurus_rex_skeleton.glb',
                    alt: 'โมเดล 3 มิติ Siamraptor',
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: Colors.transparent,
                    loading: Loading.eager,
                  )
                : Image.asset(
                    'assets/images/Siamraptor.png',
                    fit: BoxFit.contain,
                  ),
          ),

          // ปุ่มสลับ 2D / 3D มุมขวาบน
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ToggleButton(
                    label: '2D',
                    selected: !_is3D,
                    onTap: () => setState(() => _is3D = false),
                  ),
                  _ToggleButton(
                    label: '3D',
                    selected: _is3D,
                    onTap: () => setState(() => _is3D = true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? _accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}