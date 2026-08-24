import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import 'get_started_screen.dart';

const _accentGreen = Color(0xFF6FCF3C);
const _accentGreenSoft = Color(0xFFB6E388);
const _surfaceDark = Color(0xCC0D2B1D);
const _surfaceCard = Color(0x990D3B24);
final _demoStoreUrl = Uri.parse('https://example.com/trexy-shop');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  static const _tabs = ['เรื่องราว', 'ไทม์ไลน์', 'กายวิภาค', 'เพิ่มเติม'];

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
      backgroundColor: AppColors.deepForest,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg_jungle.jpg',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  AppColors.deepForest.withValues(alpha: 0.92),
                  AppColors.deepForest,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _HeaderSection(
                      userName: userName,
                      onLogout: () => _handleLogout(context),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategoryBadge(label: 'RAPTOR'),
                        const SizedBox(height: 10),
                        const Text(
                          'Siamraptor',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Text(
                          'suwatii',
                          style: TextStyle(
                            color: _accentGreenSoft,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'สยามแรปเตอร์ สุวัธนี่ · ตั้งชื่อโดย Chokchaloemwong',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _DinosaurMediaViewer(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: const [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.straighten_rounded,
                            label: 'ความยาว',
                            value: '7.9 เมตร',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.scale_rounded,
                            label: 'น้ำหนัก',
                            value: '3-4 ตัน',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.emoji_nature_rounded,
                            label: 'ฟัน',
                            value: '60 ซี่',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(
                          title: 'เจาะลึก Siam Raptor',
                          subtitle:
                              'ข้อมูลเชิงลึกเกี่ยวกับพฤติกรรม ลักษณะทางกายภาพ และวิวัฒนาการ',
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _tabs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 4),
                            itemBuilder: (context, index) {
                              return _TabItem(
                                label: _tabs[index],
                                selected: _selectedTab == index,
                                onTap: () =>
                                    setState(() => _selectedTab = index),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          color: _accentGreen.withValues(alpha: 0.35),
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: KeyedSubtree(
                            key: ValueKey(_selectedTab),
                            child: _DeepDiveTabBody(tabIndex: _selectedTab),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _accentGreen.withValues(alpha: 0.55),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _accentGreen.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
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
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Welcome to T-REX dinosure',
                  style: TextStyle(color: AppColors.whiteFaded, fontSize: 12),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.logout_rounded,
                    color: AppColors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;

  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _accentGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _accentGreen.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _accentGreen,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.2,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accentGreen.withValues(alpha: 0.85), size: 18),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: _accentGreen,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 44,
          margin: const EdgeInsets.only(top: 2, right: 12),
          decoration: BoxDecoration(
            color: _accentGreen,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: _accentGreen.withValues(alpha: 0.45),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? _accentGreen : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? _accentGreen : Colors.grey.shade400,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeepDiveTabBody extends StatelessWidget {
  final int tabIndex;

  const _DeepDiveTabBody({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 1:
        return const _TimelinePanel();
      case 2:
        return const _AnatomyPanel();
      case 3:
        return const _MorePanel();
      default:
        return const _StoryPanel();
    }
  }
}

class _MorePanel extends StatelessWidget {
  const _MorePanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoPanel(
          icon: Icons.info_outline_rounded,
          title: 'เพิ่มเติม',
          body:
              'ตั้งชื่อวิทยาศาสตร์ว่า Siamraptor suwati โดย Chokchaloemwong และคณะ '
              'ซากถูกพบในกลุ่มหินโคราช จังหวัดนครราชสีมา '
              'ถือเป็นหลักฐานสำคัญของไดโนเสาร์นักล่าขนาดใหญ่ในเอเชียตะวันออกเฉียงใต้',
        ),
        SizedBox(height: 28),
        _SectionTitle(
          title: 'ผลิตภัณฑ์ของที่ระลึก',
          subtitle: 'เลือกเก็บความทรงจำจากโลกของ Siamraptor',
        ),
        SizedBox(height: 14),
        _SouvenirBanner(),
        SizedBox(height: 16),
        _SouvenirCatalog(),
        SizedBox(height: 30),
        _SectionTitle(
          title: 'นักพัฒนา',
          subtitle: 'ติดตามผลงานและติดต่อทีมพัฒนา T-REXY',
        ),
        SizedBox(height: 14),
        _DeveloperContactPanel(),
      ],
    );
  }
}

class _DeveloperContactPanel extends StatelessWidget {
  const _DeveloperContactPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentGreen.withValues(alpha: 0.32)),
      ),
      child: Column(
        children: const [
          _DeveloperContactTile(
            icon: Icons.camera_alt_outlined,
            title: 'Instagram',
            contact: '@ryu338_kidsada',
            iconColor: Color(0xFFE66A8D),
          ),
          Divider(height: 1, color: Colors.white12),
          _DeveloperContactTile(
            icon: Icons.code_rounded,
            title: 'GitHub',
            contact: 'github.com/Ryu338-kidsada/t_rexy_app',
            iconColor: _accentGreenSoft,
          ),
        ],
      ),
    );
  }
}

class _DeveloperContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String contact;
  final Color iconColor;

  const _DeveloperContactTile({
    required this.icon,
    required this.title,
    required this.contact,
    required this.iconColor,
  });

  Future<void> _copyContact(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: contact));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('คัดลอกข้อมูล $title แล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _copyContact(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy_rounded, color: Colors.grey.shade500, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SouvenirBanner extends StatelessWidget {
  const _SouvenirBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/demo/dinobanner.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.deepForest.withValues(alpha: 0.50),
                    AppColors.deepForest.withValues(alpha: 0.10),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'T-REXY COLLECTION',
                    style: TextStyle(
                      color: _accentGreenSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'พกโลกยุคดึกดำบรรพ์ไปกับคุณ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SouvenirCatalog extends StatelessWidget {
  const _SouvenirCatalog();

  static const _products = [
    _SouvenirProduct(
      name: 'เสื้อยืด Siamraptor',
      description: 'เสื้อคอตตอนลายสยามแรปเตอร์ สำหรับนักสำรวจตัวน้อย',
      price: '฿ 390',
      assetPath: 'assets/images/demo/demo.jpg',
      badge: 'แนะนำ',
    ),
    _SouvenirProduct(
      name: 'โปสเตอร์นักล่าแห่งโคราช',
      description: 'โปสเตอร์ภาพประกอบ Siamraptor สำหรับตกแต่งห้อง',
      price: '฿ 149',
      assetPath: 'assets/images/demo/poster.jpg',
      badge: 'สินค้าใหม่',
    ),
    _SouvenirProduct(
      name: 'เข็มกลัด T-REXY',
      description: 'เข็มกลัดโลโก้ T-REXY รุ่นสะสม จำนวนจำกัด',
      price: '฿ 99',
      assetPath: 'assets/images/demo/images.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._products.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SouvenirProductCard(product: product),
          ),
        ),
        Text(
          'สินค้าเป็นตัวอย่างเพื่อการศึกษา ยังไม่รองรับการสั่งซื้อจริง',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }
}

class _SouvenirProduct {
  final String name;
  final String description;
  final String price;
  final String assetPath;
  final String? badge;

  const _SouvenirProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.assetPath,
    this.badge,
  });
}

class _SouvenirProductCard extends StatelessWidget {
  final _SouvenirProduct product;

  const _SouvenirProductCard({required this.product});

  Future<void> _contactStore(BuildContext context) async {
    final opened = await launchUrl(
      _demoStoreUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดหน้าร้านค้าได้')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentGreen.withValues(alpha: 0.32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(product.assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.badge != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _accentGreen.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.badge!,
                      style: const TextStyle(
                        color: _accentGreenSoft,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        color: _accentGreenSoft,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: FilledButton.icon(
                        onPressed: () => _contactStore(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: _accentGreen,
                          foregroundColor: AppColors.deepForest,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: const Text('ติดต่อร้านค้า'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoPanel(
          icon: Icons.menu_book_rounded,
          title: 'เรื่องราว',
          body:
              'สยามแรปเตอร์ สุวัธนี่ คือไดโนเสาร์นักล่าที่เคยอาศัยในดินแดนไทยเมื่อกว่า 113 ล้านปีก่อน '
              'มันล่าเหยื่อในระบบนิเวศป่าชื้นและที่ราบน้ำท่วมถึงของยุคครีเทเชียสตอนต้น '
              'ฟอสซิลที่พบช่วยเล่าเรื่องวิวัฒนาการของวงศ์นักล่าขนาดใหญ่ในภูมิภาคนี้',
        ),
        SizedBox(height: 22),
        _SectionTitle(
          title: 'พฤติกรรม',
          subtitle: 'รูปแบบการล่าและชนิดอาหาร (ข้อมูลจำลอง)',
        ),
        SizedBox(height: 14),
        _BehaviorPanel(),
        SizedBox(height: 28),
        _DiscoveryPanel(),
        SizedBox(height: 28),
        _SectionTitle(
          title: 'โลกที่มันเคยเดิน',
          subtitle: 'สำรวจแผนที่ประเทศที่พบซากดึกดำบรรพ์และแหล่งฟอสซิล',
        ),
        SizedBox(height: 14),
        _HabitatMapCard(),
      ],
    );
  }
}

class _DiscoveryPanel extends StatelessWidget {
  const _DiscoveryPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SmallHeading(
          title: 'การขุดค้นพบฟอสซิล',
          subtitle: 'แหล่งขุดค้นและบริบทของการพบซากครั้งแรก',
        ),
        SizedBox(height: 12),
        _FossilCard(
          item: _FossilItem(
            assetPath: 'assets/images/discovery_first.jpg',
            part: 'นครราชสีมา',
            title: 'เหมืองหินในกลุ่มหินโคราช',
            description:
                'ซากของ Siamraptor ถูกพบครั้งแรกที่เหมืองหินในจังหวัดนครราชสีมา '
                'ภายในกลุ่มหินโคราช ช่วงยุคครีเทเชียสตอนต้น '
                'การขุดค้นครั้งนั้นได้ชิ้นส่วนกระดูกหลายชิ้น ซึ่งต่อมาถูกใช้ศึกษาและตั้งชื่อวิทยาศาสตร์ในปี ค.ศ. 2019 '
                'โดย Chokchaloemwong และคณะ',
            placeholderLabel: 'รอใส่ภาพการขุดค้น',
          ),
        ),
      ],
    );
  }
}

class _FossilItem {
  final String assetPath;
  final String part;
  final String title;
  final String description;
  final String placeholderLabel;

  const _FossilItem({
    required this.assetPath,
    required this.part,
    required this.title,
    required this.description,
    this.placeholderLabel = 'รอใส่ภาพฟอสซิล',
  });
}

class _FossilGallery extends StatelessWidget {
  const _FossilGallery();

  static const _items = [
    _FossilItem(
      assetPath: 'assets/images/fossil_jaw.jpg',
      part: 'ขากรรไกรบน',
      title: 'กระดูกขากรรไกร',
      description:
          'ฟอสซิลขากรรไกรบนช่วยยืนยันลักษณะฟันหยักของนักล่า '
          'และเป็นหลักฐานสำคัญที่ใช้ตั้งชื่อ Siamraptor suwati',
    ),
    _FossilItem(
      assetPath: 'assets/images/fossil_vertebra.jpg',
      part: 'กระดูกสันหลัง',
      title: 'กระดูกสันหลังส่วนคอ',
      description:
          'รูปร่างของกระดูกสันหลังบ่งชี้คอที่แข็งแรง เหมาะกับการจับและฉีกเหยื่อ '
          'สอดคล้องกับพฤติกรรมไดโนเสาร์กินเนื้อขนาดใหญ่',
    ),
    _FossilItem(
      assetPath: 'assets/images/fossil_limb.jpg',
      part: 'แขนและมือ',
      title: 'กระดูกแขนส่วนหน้า',
      description:
          'ชิ้นส่วนแขนและอุ้งมือช่วยเล่าถึงการเคลื่อนไหวและการใช้กรงเล็บ '
          'ขณะไล่ล่าในภูมิประเทศยุคครีเทเชียสของไทย',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SmallHeading(
          title: 'ภาพฟอสซิลและคำอธิบาย',
          subtitle: 'หลักฐานซากดึกดำบรรพ์ที่ช่วยเล่าเรื่องของมัน',
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _items.length; i++) ...[
          _FossilCard(item: _items[i]),
          if (i != _items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SmallHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SmallHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 42,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: _accentGreen,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: _accentGreen.withValues(alpha: 0.45),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FossilCard extends StatelessWidget {
  final _FossilItem item;

  const _FossilCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: const Color(0xFF0A1F16),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _FossilPlaceholder(
                      label: item.placeholderLabel,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _accentGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      item.part,
                      style: const TextStyle(
                        color: _accentGreenSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FossilPlaceholder extends StatelessWidget {
  final String label;

  const _FossilPlaceholder({this.label = 'รอใส่ภาพ'});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _surfaceCard,
            AppColors.primaryGreen.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search_rounded,
            color: _accentGreen.withValues(alpha: 0.85),
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BehaviorPanel extends StatelessWidget {
  const _BehaviorPanel();

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        children: [
          const _BehaviorGroup(
            icon: Icons.groups_rounded,
            label: 'รูปแบบการล่า',
            selected: 'ล่าเดี่ยว',
            options: ['ล่าเดี่ยว', 'ล่าฝูง'],
            note:
                'สันนิษฐานจากขนาดลำตัวที่ใหญ่ เหมาะกับการไล่ล่าเหยื่อตามลำพัง',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          const _BehaviorGroup(
            icon: Icons.restaurant_rounded,
            label: 'ชนิดอาหาร',
            selected: 'กินเนื้อ',
            options: ['กินพืช', 'กินเนื้อ', 'กินทั้งสองอย่าง'],
            note: 'ฟันหยักคมและกรามแข็งแรง บ่งชี้ว่าเป็นนักล่ากินเนื้อ',
          ),
        ],
      ),
    );
  }
}

class _BehaviorGroup extends StatelessWidget {
  final IconData icon;
  final String label;
  final String selected;
  final List<String> options;
  final String note;

  const _BehaviorGroup({
    required this.icon,
    required this.label,
    required this.selected,
    required this.options,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _accentGreen, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              _BehaviorChip(
                label: option,
                selected: option == selected,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          note,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _BehaviorChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _BehaviorChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? _accentGreen.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? _accentGreen.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _accentGreenSoft : Colors.grey.shade400,
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _HabitatMapCard extends StatelessWidget {
  const _HabitatMapCard();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _GlassPanel(
        padding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _surfaceCard,
                    AppColors.primaryGreen.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: _GridPatternPainter(
                color: _accentGreen.withValues(alpha: 0.08),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentGreen.withValues(alpha: 0.15),
                    border: Border.all(
                      color: _accentGreen.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: _accentGreen,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'ภาพสถานที่ 16:9',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _accentGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _accentGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent {
  final String period;
  final String title;
  final String detail;

  const _TimelineEvent({
    required this.period,
    required this.title,
    required this.detail,
  });
}

class _TimelinePanel extends StatelessWidget {
  const _TimelinePanel();

  static const _events = [
    _TimelineEvent(
      period: '125–113 ล้านปีก่อน',
      title: 'มีชีวิตในยุคครีเทเชียสตอนต้น',
      detail:
          'Siamraptor อาศัยอยู่ในพื้นที่ที่ปัจจุบันคือภาคตะวันออกเฉียงเหนือของไทย ช่วง Aptian',
    ),
    _TimelineEvent(
      period: 'กลุ่มหินโคราช',
      title: 'พบซากดึกดำบรรพ์',
      detail:
          'ฟอสซิลถูกค้นพบที่เหมืองหินในจังหวัดนครราชสีมา ช่วยยืนยันการมีอยู่ของนักล่าขนาดใหญ่ในภูมิภาคนี้',
    ),
    _TimelineEvent(
      period: 'ค.ศ. 2019',
      title: 'ตั้งชื่อวิทยาศาสตร์',
      detail:
          'ได้รับการตั้งชื่อว่า Siamraptor suwati โดย Chokchaloemwong และคณะ จากหลักฐานกระดูกที่ศึกษาได้',
    ),
    _TimelineEvent(
      period: 'ปัจจุบัน',
      title: 'หลักฐานทางบรรพชีวิน',
      detail:
          'ยังถูกใช้ศึกษาวิวัฒนาการของวงศ์ Carcharodontosauridae และระบบนิเวศไดโนเสาร์ในเอเชียตะวันออกเฉียงใต้',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _events.length; i++)
          _TimelineNode(
            event: _events[i],
            isFirst: i == 0,
            isLast: i == _events.length - 1,
          ),
      ],
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final _TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({
    required this.event,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : _accentGreen.withValues(alpha: 0.45),
                  ),
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentGreen,
                    boxShadow: [
                      BoxShadow(
                        color: _accentGreen.withValues(alpha: 0.45),
                        blurRadius: 8,
                      ),
                    ],
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.35)),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : _accentGreen.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _GlassPanel(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.period,
                      style: const TextStyle(
                        color: _accentGreenSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.detail,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: _surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
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
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentGreen.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: _accentGreen.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0D3B29),
                  AppColors.deepForest.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _is3D
                ? ModelViewer(
                    key: const ValueKey('3d'),
                    src: 'assets/models/tyrannosaurus_rex_skeleton.glb',
                    alt: 'โมเดล 3 มิติ Siamraptor',
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: Colors.transparent,
                    loading: Loading.eager,
                  )
                : Image.asset(
                    key: const ValueKey('2d'),
                    'assets/images/Siamraptor.png',
                    fit: BoxFit.contain,
                  ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accentGreen.withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Anatomy Panel ──────────────────────────────────────────────────────────

class _AnatomyPart {
  final int number;
  final String label;
  final String detail;

  /// ตำแหน่งบนรูป (สัดส่วน 0.0–1.0 ของ width/height)
  final double left;
  final double top;

  const _AnatomyPart({
    required this.number,
    required this.label,
    required this.detail,
    required this.left,
    required this.top,
  });
}

class _AnatomyPanel extends StatefulWidget {
  const _AnatomyPanel();

  @override
  State<_AnatomyPanel> createState() => _AnatomyPanelState();
}

class _AnatomyPanelState extends State<_AnatomyPanel> {
  int? _selected;
  bool _showMarkers = true;

  static const _parts = [
    _AnatomyPart(
      number: 1,
      label: 'กะโหลกและขากรรไกร',
      detail:
          'กะโหลกยาวและแข็งแรง มีฟันหยักประมาณ 60 ซี่ เหมาะสำหรับฉีกเนื้อเหยื่อขนาดใหญ่',
      left: 0.17,
      top: 0.30,
    ),
    _AnatomyPart(
      number: 2,
      label: 'คอ',
      detail: 'คอกล้ามเนื้อหนาและยืดหยุ่น รองรับน้ำหนักหัวขนาดใหญ่ขณะล่าเหยื่อ',
      left: 0.25,
      top: 0.35,
    ),
    _AnatomyPart(
      number: 3,
      label: 'กระดูกสันหลัง',
      detail:
          'กระดูกสันหลังเรียงต่อกันตลอดลำตัว ทำหน้าที่เป็นโครงสร้างหลักรับแรงกระแทก',
      left: 0.37,
      top: 0.35,
    ),
    _AnatomyPart(
      number: 4,
      label: 'แขนหน้า',
      detail:
          'แขนหน้าสั้นแต่มีกรงเล็บโค้งแหลม 3 นิ้ว ใช้จับและยึดเหยื่อขณะโจมตี',
      left: 0.34,
      top: 0.62,
    ),
    _AnatomyPart(
      number: 5,
      label: 'ขาหลัง',
      detail: 'ขาหลังแข็งแรงยาว ประมาณการว่าวิ่งได้ 25–35 กม./ชม. บนพื้นราบ',
      left: 0.47,
      top: 0.62,
    ),
    _AnatomyPart(
      number: 6,
      label: 'หาง',
      detail:
          'หางยาวแข็ง ทำหน้าที่ถ่วงสมดุลน้ำหนักลำตัวและช่วยเปลี่ยนทิศทางขณะวิ่ง',
      left: 0.70,
      top: 0.40,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _selected != null
        ? _parts.firstWhere((p) => p.number == _selected)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── รูปไดโนเสาร์ + markers ──
        _GlassPanel(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  return Stack(
                    children: [
                      // พื้นหลัง gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0D3B29),
                              AppColors.deepForest.withValues(alpha: 0.95),
                            ],
                          ),
                        ),
                      ),
                      // รูปไดโนเสาร์
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/images/Siamraptor.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // markers — ซ่อน/แสดงตาม _showMarkers
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _showMarkers ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: !_showMarkers,
                          child: Stack(
                            children: [
                              for (final part in _parts)
                                Positioned(
                                  left: part.left * w - 14,
                                  top: part.top * h - 14,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _selected = _selected == part.number
                                          ? null
                                          : part.number;
                                    }),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _selected == part.number
                                            ? _accentGreen
                                            : Colors.black
                                                .withValues(alpha: 0.65),
                                        border: Border.all(
                                          color: _selected == part.number
                                              ? Colors.white
                                              : _accentGreen.withValues(
                                                  alpha: 0.8),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _accentGreen.withValues(
                                                alpha: _selected == part.number
                                                    ? 0.55
                                                    : 0.25),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${part.number}',
                                          style: TextStyle(
                                            color: _selected == part.number
                                                ? Colors.black
                                                : _accentGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // ── ปุ่มซ่อน/แสดงหมายเลข ──
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => setState(() => _showMarkers = !_showMarkers),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _showMarkers
                      ? _accentGreen.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _showMarkers
                        ? _accentGreen.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showMarkers
                          ? Icons.label_rounded
                          : Icons.label_off_rounded,
                      size: 14,
                      color: _showMarkers ? _accentGreen : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _showMarkers ? 'ซ่อนหมายเลข' : 'แสดงหมายเลข',
                      style: TextStyle(
                        color:
                            _showMarkers ? _accentGreen : Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── กรอบ detail เมื่อ tap marker ──
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: selected != null
              ? _GlassPanel(
                  key: ValueKey(selected.number),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _accentGreen,
                          boxShadow: [
                            BoxShadow(
                              color: _accentGreen.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${selected.number}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.label,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selected.detail,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),

        const SizedBox(height: 8),

        // ── รายการส่วนทั้งหมด (legend) — tap เพื่อเลือก ──
        for (final part in _parts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _selected = _selected == part.number ? null : part.number;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _selected == part.number
                      ? _accentGreen.withValues(alpha: 0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selected == part.number
                        ? _accentGreen.withValues(alpha: 0.45)
                        : Colors.transparent,
                  ),
                ),
                child: _GlassPanel(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selected == part.number
                              ? _accentGreen
                              : _accentGreen.withValues(alpha: 0.12),
                          border: Border.all(
                              color: _accentGreen.withValues(alpha: 0.55)),
                        ),
                        child: Center(
                          child: Text(
                            '${part.number}',
                            style: TextStyle(
                              color: _selected == part.number
                                  ? Colors.black
                                  : _accentGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          part.label,
                          style: TextStyle(
                            color: _selected == part.number
                                ? AppColors.white
                                : Colors.grey.shade300,
                            fontSize: 13,
                            fontWeight: _selected == part.number
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        _selected == part.number
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: _selected == part.number
                            ? _accentGreen
                            : Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '* แตะหมายเลขบนรูปหรือในรายการเพื่อดูรายละเอียด (ข้อมูลจำลอง)',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
        ),
        const SizedBox(height: 22),
        const _FossilGallery(),
      ],
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  final Color color;

  _GridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
