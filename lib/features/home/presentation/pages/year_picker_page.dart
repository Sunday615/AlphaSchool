import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../auth/presentation/pages/login_page.dart';

class YearPickerPage extends StatefulWidget {
  /// ✅ compatibility เก่า (ยังเก็บไว้ได้ ไม่ทำให้ error)
  final VoidCallback? onToggleTheme;
  final ThemeMode? themeMode;

  const YearPickerPage({super.key, this.onToggleTheme, this.themeMode});

  @override
  State<YearPickerPage> createState() => _YearPickerPageState();
}

class _YearPickerPageState extends State<YearPickerPage> {
  static const double _maxWidth = 520;

  final years = const ["2024-2025", "2025-2026", "2026-2027"];
  int? selectedIndex;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    // ✅ compatibility: ถ้ามีคนส่ง themeMode มา ให้ sync เข้ากับ global
    if (widget.themeMode != null) {
      AppTheme.setThemeMode(widget.themeMode!);
    }
  }

  void _toggleThemeGlobal() {
    if (_navigating) return;
    AppTheme.toggleThemeMode();
    widget.onToggleTheme?.call();
  }

  Future<void> _selectAndGo(int i) async {
    if (_navigating) return;

    setState(() {
      _navigating = true;
      selectedIndex = i;
    });

    HapticFeedback.selectionClick();

    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;

    try {
      await Navigator.of(
        context,
      ).push(_smoothRoute(LoginPage(academicYear: years[i])));
    } finally {
      if (!mounted) return;
      setState(() {
        _navigating = false;
        selectedIndex = null;
      });
    }
  }

  PageRouteBuilder _smoothRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 300),
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
        final scale = Tween<double>(begin: .985, end: 1).animate(curved);

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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, mode, _) {
        final base = (mode == ThemeMode.dark)
            ? AppTheme.darkTheme(locale)
            : AppTheme.lightTheme(locale);

        final themed = base.copyWith(
          scaffoldBackgroundColor: Colors.transparent,
        );

        return AnimatedTheme(
          data: themed,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final bgTop = isDark
                  ? AppColors.blue500
                  : AppColors.grayUltraLight.withOpacity(.16);
              final bgMid = isDark
                  ? AppColors.blue400.withOpacity(.22)
                  : AppColors.blue100.withOpacity(.06);
              final bgBottom = isDark ? AppColors.dark : Colors.white;

              final glowA = (isDark ? AppColors.blue100 : AppColors.blue200)
                  .withOpacity(isDark ? .24 : .10);
              final glowB = (isDark ? AppColors.blue200 : AppColors.blue300)
                  .withOpacity(isDark ? .20 : .08);

              final titleColor = isDark ? Colors.white : AppColors.blue500;
              final muted = isDark
                  ? AppColors.grayUltraLight.withOpacity(.86)
                  : AppColors.gray;

              final surface = isDark
                  ? AppColors.blue500.withOpacity(.38)
                  : Colors.white;
              final stroke = isDark
                  ? Colors.white.withOpacity(.10)
                  : AppColors.slate.withOpacity(.12);

              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [bgTop, bgMid, bgBottom],
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Positioned(
                          top: -110,
                          left: -95,
                          child: _Glow(size: 320, color: glowA),
                        ),
                        Positioned(
                          bottom: -170,
                          right: -140,
                          child: _Glow(size: 420, color: glowB),
                        ),

                        // ===== top bar =====
                        Positioned(
                          top: 10,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: [
                              const Spacer(),
                              _ThemePill(
                                isDark: isDark,
                                disabled: _navigating,
                                onTap: _toggleThemeGlobal,
                              ),
                            ],
                          ),
                        ),

                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _maxWidth,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                72,
                                16,
                                18,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Choose Academic Year",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: titleColor,
                                          letterSpacing: -.25,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Select a year to continue",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: muted,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,
                                          sigmaY: 12,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: surface.withOpacity(
                                              isDark ? .52 : .66,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                            border: Border.all(color: stroke),
                                          ),
                                          child: ListView.separated(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.all(12),
                                            itemBuilder: (context, i) {
                                              final selected =
                                                  selectedIndex == i;
                                              return _YearCard(
                                                year: years[i],
                                                isDark: isDark,
                                                selected: selected,
                                                disabled: _navigating,
                                                onTap: () => _selectAndGo(i),
                                              );
                                            },
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 12),
                                            itemCount: years.length,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: _navigating ? 1 : 0,
                                    child: _navigating
                                        ? Row(
                                            children: [
                                              const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  color: muted,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

class _ThemePill extends StatelessWidget {
  final bool isDark;
  final bool disabled;
  final VoidCallback? onTap;

  const _ThemePill({
    required this.isDark,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? AppColors.blue500.withOpacity(.55)
        : Colors.white.withOpacity(.75);
    final bd = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);
    final fg = isDark ? Colors.white : AppColors.blue500;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: bd),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(isDark ? .22 : .08),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 18,
              color: fg,
            ),
            const SizedBox(width: 8),
            Text(
              isDark ? "Light" : "Dark",
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w900,
                letterSpacing: -.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearCard extends StatelessWidget {
  final String year;
  final bool isDark;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _YearCard({
    required this.year,
    required this.isDark,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? Colors.white.withOpacity(selected ? .14 : .10)
        : Colors.white.withOpacity(selected ? .96 : .88);

    final bd = isDark
        ? Colors.white.withOpacity(selected ? .24 : .14)
        : AppColors.slate.withOpacity(selected ? .16 : .12);

    final fg = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? AppColors.grayUltraLight.withOpacity(.82)
        : AppColors.gray;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: bd),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.blue200, AppColors.blue300]
                        : [AppColors.blue100, AppColors.blue300],
                  ),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      year,
                      style: TextStyle(
                        color: fg,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: -.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected ? "Selected" : "Tap to continue",
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: disabled ? .35 : 1,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: (isDark ? Colors.white : AppColors.slate).withOpacity(
                    .65,
                  ),
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
