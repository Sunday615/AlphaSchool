import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../shared/models/student_card_item.dart';

import '../../../students/presentation/pages/choose_students.dart'
    show StudentsCardListPage;

//Tab pages list at homepage
import 'tabs/explore_page.dart';
import 'tabs/shop_page.dart';
import 'tabs/alerts_page.dart';
import 'tabs/profile_page.dart';

class HomeShellPage extends StatefulWidget {
  final StudentCardItem selectedStudent;

  const HomeShellPage({super.key, required this.selectedStudent});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOutCubic,
  );

  PageRouteBuilder _smoothRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        );
        final fade = Tween<double>(begin: 0, end: 1).animate(curved);
        final slide = Tween<Offset>(
          begin: const Offset(0, .02),
          end: Offset.zero,
        ).animate(curved);
        final scale = Tween<double>(begin: .99, end: 1).animate(curved);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
    );
  }

  void _changeStudent() {
    Navigator.of(
      context,
    ).pushReplacement(_smoothRoute(const StudentsCardListPage()));
  }

  void _openNotifications() {
    // ✅ demo action: เปลี่ยนเป็น push ไปหน้า notifications จริงของคุณได้ทีหลัง
    setState(() => _index = 2);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  ThemeData _effectiveTheme(Locale locale, bool dark) {
    final base = dark
        ? AppTheme.darkTheme(locale)
        : AppTheme.lightTheme(locale);
    return base.copyWith(scaffoldBackgroundColor: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode, // ✅ ตาม global theme
      builder: (context, mode, _) {
        final dark = mode == ThemeMode.dark;

        return AnimatedTheme(
          data: _effectiveTheme(locale, dark),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              // ✅ พื้นหลังหลัก: Light=ขาวล้วน / Dark=เข้ม (link จาก YearPicker)
              final bg = isDark ? AppColors.dark : Colors.white;

              final titleColor = isDark ? Colors.white : AppColors.blue500;
              final muted = isDark
                  ? AppColors.grayUltraLight.withOpacity(.82)
                  : AppColors.blue500.withOpacity(.65);

              final pages = <Widget>[
                const ExplorePage(),
                const ShopPage(),
                const AlertsPage(),
                const ProfilePage(),
              ];

              final navItems = const [
                AppBottomNavItem(
                  icon: FontAwesomeIcons.house,
                  label: "ໜ້າຫຼັກ",
                ),
                AppBottomNavItem(
                  icon: FontAwesomeIcons.chalkboardUser,
                  label: "ຫ້ອງຮຽນ",
                ),
                AppBottomNavItem(
                  icon: FontAwesomeIcons.chartLine,
                  label: "ຜົນການຮຽນ",
                ),
                AppBottomNavItem(
                  icon: FontAwesomeIcons.sackXmark,
                  label: "ຄ່າທຳນຽມ",
                ),
              ];

              return Scaffold(
                backgroundColor: bg,
                body: FadeTransition(
                  opacity: _fade,
                  child: SafeArea(
                    child: Column(
                      children: [
                        // ===== top header =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                          child: _StudentHeader(
                            student: widget.selectedStudent,
                            onChange: _changeStudent,
                            onNotifications: _openNotifications, // ✅ ADD
                            isDark: isDark,
                            titleColor: titleColor,
                            muted: muted,
                          ),
                        ),

                        // ===== content =====
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            child: pages[_index],
                          ),
                        ),

                        // ===== global bottom nav =====
                        AppBottomNav(
                          currentIndex: _index,
                          onChanged: (i) => setState(() => _index = i),
                          items: navItems,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StudentHeader extends StatelessWidget {
  final StudentCardItem student;
  final VoidCallback onChange;

  // ✅ ADD
  final VoidCallback onNotifications;

  final bool isDark;
  final Color titleColor;
  final Color muted;

  const _StudentHeader({
    required this.student,
    required this.onChange,
    required this.onNotifications, // ✅ ADD
    required this.isDark,
    required this.titleColor,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    final cardBg = isDark ? AppColors.blue500.withOpacity(.16) : Colors.white;

    final shadow = Colors.black.withOpacity(isDark ? .22 : .06);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      child: Row(
        children: [
          _Avatar(photoUrl: student.photoUrl, isDark: isDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 3),
                // ✅ เปลี่ยน Student ID -> Student class
                Text(
                  "Student class: ${student.studentId}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // ✅ ADD: notification icon next to Change
          _IconPill(
            isDark: isDark,
            onTap: onNotifications,
            icon: FontAwesomeIcons.bell,
            tooltip: "Notifications",
          ),
          const SizedBox(width: 10),

          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onChange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.blue500, AppColors.blue300],
                ),
              ),
              child: const Text(
                "Change",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  final IconData icon;
  final String tooltip;

  const _IconPill({
    required this.isDark,
    required this.onTap,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.14)
        : AppColors.slate.withOpacity(.12);

    final bg = isDark
        ? Colors.white.withOpacity(.08)
        : AppColors.blue500.withOpacity(.06);

    final iconColor = isDark ? Colors.white : AppColors.blue500;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border),
          ),
          child: Center(child: FaIcon(icon, size: 16, color: iconColor)),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photoUrl;
  final bool isDark;

  const _Avatar({required this.photoUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const size = 46.0;

    final bg = isDark
        ? Colors.white.withOpacity(.08)
        : AppColors.blue200.withOpacity(.15);

    final iconColor = isDark
        ? Colors.white.withOpacity(.88)
        : AppColors.blue500;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: size,
        height: size,
        color: bg,
        child: photoUrl == null
            ? Icon(Icons.person, color: iconColor)
            : Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                frameBuilder: (context, child, frame, wasSyncLoaded) {
                  if (wasSyncLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: child,
                  );
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, color: iconColor),
              ),
      ),
    );
  }
}

class _StubPage extends StatelessWidget {
  final String title;
  final StudentCardItem student;

  final bool isDark;
  final Color titleColor;
  final Color muted;

  const _StubPage({
    required this.title,
    required this.student,
    required this.isDark,
    required this.titleColor,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    final cardBg = isDark ? AppColors.blue500.withOpacity(.12) : Colors.white;

    final shadow = Colors.black.withOpacity(isDark ? .22 : .06);

    return Padding(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: titleColor,
              letterSpacing: -.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: shadow,
                ),
              ],
            ),
            child: Text(
              "Selected student:\n- ${student.name}\n- ${student.studentId}",
              style: TextStyle(fontWeight: FontWeight.w800, color: muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _StubSimple extends StatelessWidget {
  final String title;
  final bool isDark;
  final Color titleColor;

  const _StubSimple({
    required this.title,
    required this.isDark,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22,
          color: titleColor,
        ),
      ),
    );
  }
}
