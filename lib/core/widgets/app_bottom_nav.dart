import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

class AppBottomNavItem {
  final IconData icon;
  final String label;

  const AppBottomNavItem({required this.icon, required this.label});
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<AppBottomNavItem> items;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
  }) : assert(items.length == 4, "Use exactly 4 menus.");

  @override
  Widget build(BuildContext context) {
    // ✅ tuned to avoid overflow (and look like your reference)
    const outerPad = 14.0;
    const innerPad = 7.0;
    const radius = 22.0;
    const height = 74.0;

    final border = AppColors.slate.withOpacity(.12);
    final shadow = Colors.black.withOpacity(.10);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(outerPad, 8, outerPad, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                    color: shadow,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(innerPad),
              child: LayoutBuilder(
                builder: (context, c) {
                  final n = items.length;

                  // ✅ smooth slide without pixel jump (align -1..1)
                  final t = n <= 1
                      ? 0.0
                      : (currentIndex / (n - 1)).clamp(0.0, 1.0);
                  final ax = -1.0 + (2.0 * t);
                  final align = Alignment(ax, 0);

                  return Stack(
                    children: [
                      // ✅ highlight pill (behind)
                      IgnorePointer(
                        child: AnimatedAlign(
                          alignment: align,
                          duration: 320.ms,
                          curve: Curves.easeOutCubic,
                          child: FractionallySizedBox(
                            widthFactor: 1 / n,
                            heightFactor: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _HighlightPill()
                                  .animate(key: ValueKey("hl-$currentIndex"))
                                  .fadeIn(duration: 140.ms)
                                  .scale(
                                    begin: const Offset(.985, .985),
                                    end: const Offset(1, 1),
                                    duration: 220.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                            ),
                          ),
                        ),
                      ),

                      // ✅ items
                      Row(
                        children: List.generate(n, (i) {
                          final active = i == currentIndex;

                          final iconColor = active
                              ? Colors.white
                              : AppColors.blue500;

                          return Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  if (i == currentIndex) return;
                                  onChanged(i);
                                },
                                child: Center(
                                  child: Padding(
                                    // ✅ keeps content vertically centered and avoids overflow
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: 220.ms,
                                      switchInCurve: Curves.easeOutCubic,
                                      switchOutCurve: Curves.easeOutCubic,
                                      transitionBuilder: (child, anim) {
                                        return FadeTransition(
                                          opacity: anim,
                                          child: SlideTransition(
                                            position:
                                                Tween<Offset>(
                                                  begin: const Offset(0, .10),
                                                  end: Offset.zero,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: anim,
                                                    curve: Curves.easeOutCubic,
                                                  ),
                                                ),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: active
                                          // ✅ ACTIVE: icon + text (text to the RIGHT like reference)
                                          ? _ActiveContent(
                                              key: ValueKey("active-$i"),
                                              icon: items[i].icon,
                                              label: items[i].label,
                                            )
                                          // ✅ INACTIVE: icon only (like reference)
                                          : Icon(
                                                  items[i].icon,
                                                  key: ValueKey("inactive-$i"),
                                                  size: 22,
                                                  color: iconColor,
                                                )
                                                .animate(target: active ? 1 : 0)
                                                .scale(
                                                  begin: const Offset(1, 1),
                                                  end: const Offset(1.06, 1.06),
                                                  duration: 180.ms,
                                                  curve: Curves.easeOutCubic,
                                                ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActiveContent({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    // ✅ keep it compact in 1/4 width
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.white)
              .animate()
              .scale(
                begin: const Offset(.95, .95),
                end: const Offset(1, 1),
                duration: 200.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 120.ms),
          const SizedBox(width: 10),
          Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.0,
                  height: 1.0,
                  letterSpacing: -.1,
                ),
              )
              .animate()
              .fadeIn(duration: 160.ms)
              .slideX(
                begin: -0.08,
                end: 0,
                duration: 220.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }
}

class _HighlightPill extends StatelessWidget {
  const _HighlightPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue500, AppColors.blue300],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.blue500.withOpacity(.25),
          ),
        ],
      ),
    );
  }
}
