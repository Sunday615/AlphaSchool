import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../shared/models/student_card_item.dart';

//Tab pages list at homepage
import 'tabs/mainhomepage.dart';
import 'tabs/classroom.dart';
import 'tabs/score.dart';
import 'tabs/fee.dart';
import 'tabs/setting_page.dart';

class HomeShellPage extends StatefulWidget {
  /// ✅ ทำให้ nullable กันเคสเข้า route นี้โดยไม่ได้ส่ง student (เช่น back มาจาก page อื่น)
  final StudentCardItem? selectedStudent;

  /// ✅ สามารถกำหนดแท็บเริ่มต้นได้ (0=Explore)
  final int initialIndex;

  const HomeShellPage({super.key, this.selectedStudent, this.initialIndex = 0});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  bool _didInitFromArgs = false;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOutCubic,
  );

  void _onPlus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final card = isDark ? AppColors.dark : Colors.white;
        final border = isDark
            ? Colors.white.withOpacity(.10)
            : AppColors.slate.withOpacity(.12);

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                    color: Colors.black.withOpacity(isDark ? .35 : .12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(
                        .12,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SheetAction(
                    icon: Icons.add_task_rounded,
                    title: "Create task",
                    onTap: () => Navigator.pop(ctx),
                  ),
                  _SheetAction(
                    icon: Icons.payments_rounded,
                    title: "Quick payment",
                    onTap: () => Navigator.pop(ctx),
                  ),
                  _SheetAction(
                    icon: Icons.event_available_rounded,
                    title: "New appointment",
                    onTap: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 4);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ รองรับ route arguments: {'tab': 0}
    if (_didInitFromArgs) return;
    _didInitFromArgs = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final tab = args['tab'];
      if (tab is int) {
        _index = tab.clamp(0, 4);
      }
    }
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

  // ✅ Android back / iOS gesture:
  // - ถ้าไม่ได้อยู่แท็บ Explore -> สลับกลับ Explore ก่อน (BottomNav ไม่หายแน่นอน)
  // - ถ้าอยู่ Explore แล้ว -> ให้ระบบทำงานปกติ (ออกแอป/กลับหน้าอื่น)
  Future<bool> _onWillPop() async {
    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, mode, _) {
        final dark = mode == ThemeMode.dark;

        return AnimatedTheme(
          data: _effectiveTheme(locale, dark),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final bg = isDark ? AppColors.dark : Colors.white;

              final pages = <Widget>[
                const ExplorePage(),
                const ClassroomPage(),
                const StudyPlanPage(),
                const FeePage(),
                const SettingsPage(),
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
                AppBottomNavItem(icon: FontAwesomeIcons.gear, label: "ຕັ້ງຄ່າ"),
              ];

              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                  backgroundColor: bg,
                  extendBody: true,

                  bottomNavigationBar: AppBottomNav(
                    currentIndex: _index,
                    onChanged: (i) => setState(() => _index = i),
                    items: navItems,
                    onPlusPressed: _onPlus,
                  ),

                  body: FadeTransition(
                    opacity: _fade,
                    child: SafeArea(
                      bottom: false,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        // ✅ ใส่ key ชัดๆ ให้ switcher ทำงานนิ่ง
                        child: KeyedSubtree(
                          key: ValueKey<int>(_index),
                          child: pages[_index],
                        ),
                      ),
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

class _SheetAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SheetAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
          color: isDark ? Colors.white.withOpacity(.06) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.blue500),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.blue500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: (isDark ? Colors.white : Colors.black).withOpacity(.35),
            ),
          ],
        ),
      ),
    );
  }
}
