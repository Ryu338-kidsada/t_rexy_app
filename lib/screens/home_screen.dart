import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import 'get_started_screen.dart';

const _accentGreen = Color(0xFF6FCF3C);
const _accentGreenSoft = Color(0xFFB6E388);
const _surfaceDark = Color(0xCC0D2B1D);
const _surfaceCard = Color(0x990D3B24);

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
                            value: '10 เมตร',
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
        return const _InfoPanel(
          icon: Icons.accessibility_new_rounded,
          title: 'กายวิภาค',
          body: 'ฟันหยักแบบนักล่าขนาดใหญ่ ประมาณ 60 ซี่ ลำตัวยาวราว 10 เมตร '
              'น้ำหนักประมาณ 3–4 ตัน จัดอยู่ในกลุ่ม Carcharodontosauridae '
              'มีกระดูกที่แข็งแรงเหมาะกับการวิ่งไล่เหยื่อในพื้นที่ราบลุ่มยุคครีเทเชียส',
        );
      case 3:
        return const _InfoPanel(
          icon: Icons.info_outline_rounded,
          title: 'เพิ่มเติม',
          body:
              'ตั้งชื่อวิทยาศาสตร์ว่า Siamraptor suwati โดย Chokchaloemwong และคณะ '
              'ซากถูกพบในกลุ่มหินโคราช จังหวัดนครราชสีมา '
              'ถือเป็นหลักฐานสำคัญของไดโนเสาร์นักล่าขนาดใหญ่ในเอเชียตะวันออกเฉียงใต้',
        );
      default:
        return const _StoryPanel();
    }
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
        SizedBox(height: 28),
        _SectionTitle(
          title: 'พฤติกรรม',
          subtitle: 'รูปแบบการล่าและชนิดอาหาร (ข้อมูลจำลอง)',
        ),
        SizedBox(height: 14),
        _BehaviorPanel(),
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
