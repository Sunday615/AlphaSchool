import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppTabItem {
  final String label;
  final IconData icon;
  final int? count;

  const AppTabItem({required this.label, required this.icon, this.count});
}

/// A reusable, responsive, modern TabBar:
/// - icon + label + count badge
/// - gradient indicator (default blue)
/// - white label on selected
/// - compact-safe for small screens
class AppModernCountTabBar extends StatelessWidget {
  final TabController controller;
  final List<AppTabItem> items;

  /// outer container styling
  final bool animate;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  /// indicator gradient override
  final Gradient? indicatorGradient;

  /// label colors override
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const AppModernCountTabBar({
    super.key,
    required this.controller,
    required this.items,
    this.animate = true,
    this.padding = const EdgeInsets.all(6),
    this.borderRadius = 22,
    this.indicatorGradient,
    this.labelColor,
    this.unselectedLabelColor,
  }) : assert(items.length > 0);

  static const Gradient _defaultIndicatorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    // Responsive tuning (prevents overflow on small phones)
    final w = MediaQuery.sizeOf(context).width;
    final compact = w < 390;
    final iPhone14Like = w <= 390;

    final tabH = (compact ? 40 : (iPhone14Like ? 42 : 44)).toDouble();
    final iconSize = compact ? 16.0 : 18.0;
    final gap = compact ? 5.0 : 7.0;
    final outerPad = compact ? 5.0 : 6.0;

    final outerBg = isDark
        ? Colors.white.withOpacity(.08)
        : Colors.white.withOpacity(.92);
    final outerBorder = isDark
        ? Colors.white.withOpacity(.14)
        : Colors.black.withOpacity(.06);
    final outerShadow = isDark
        ? Colors.black.withOpacity(.35)
        : Colors.black.withOpacity(.08);

    final effectiveLabelColor = labelColor ?? Colors.white;
    final effectiveUnselected =
        unselectedLabelColor ??
        (isDark
            ? Colors.white.withOpacity(.70)
            : Colors.black.withOpacity(.55));

    final labelStyle = t.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: .1,
      fontSize: compact ? 12.6 : 13.2,
      height: 1.0,
    );

    final unselectedStyle = t.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w800,
      letterSpacing: .1,
      fontSize: compact ? 12.6 : 13.2,
      height: 1.0,
    );

    final widgetTree = Container(
      padding: EdgeInsets.all(outerPad),
      decoration: BoxDecoration(
        color: outerBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: outerBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: outerShadow,
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        splashBorderRadius: BorderRadius.circular(borderRadius - 4),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.zero,
        isScrollable: false,

        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedStyle,
        labelColor: effectiveLabelColor,
        unselectedLabelColor: effectiveUnselected,

        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 4),
          gradient: indicatorGradient ?? _defaultIndicatorGradient,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: const Color(0xFF3B82F6).withOpacity(.28),
            ),
          ],
        ),
        tabs: [
          for (final it in items)
            _TabPill(
              height: tabH,
              text: it.label,
              icon: it.icon,
              count: it.count,
              iconSize: iconSize,
              gap: gap,
              compact: compact,
              animate: animate,
            ),
        ],
      ),
    );

    return animate
        ? widgetTree
              .animate()
              .fadeIn(duration: 220.ms)
              .slideY(
                begin: -.08,
                end: 0,
                duration: 420.ms,
                curve: Curves.easeOutCubic,
              )
        : widgetTree;
  }
}

class _TabPill extends StatelessWidget {
  final String text;
  final IconData icon;
  final int? count;

  final double height;
  final double iconSize;
  final double gap;
  final bool compact;
  final bool animate;

  const _TabPill({
    required this.text,
    required this.icon,
    required this.count,
    required this.height,
    required this.iconSize,
    required this.gap,
    required this.compact,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeBg = isDark
        ? Colors.white.withOpacity(.18)
        : Colors.white.withOpacity(.22);
    final badgeBorder = Colors.white.withOpacity(.28);

    final badge = count == null
        ? const SizedBox.shrink()
        : _CountBadge(
            count: count!,
            bg: badgeBg,
            border: badgeBorder,
            compact: compact,
          );

    return SizedBox(
      height: height,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize),
              SizedBox(width: gap),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 78 : 92),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              if (count != null) ...[
                SizedBox(width: gap),
                animate
                    ? badge
                          .animate()
                          .fadeIn(duration: 180.ms)
                          .scale(
                            begin: const Offset(.96, .96),
                            end: const Offset(1, 1),
                            duration: 220.ms,
                            curve: Curves.easeOutCubic,
                          )
                    : badge,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color bg;
  final Color border;
  final bool compact;

  const _CountBadge({
    required this.count,
    required this.bg,
    required this.border,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';

    return Container(
      constraints: BoxConstraints(minWidth: compact ? 22 : 24),
      height: compact ? 18 : 20,
      padding: EdgeInsets.symmetric(horizontal: compact ? 5.5 : 6.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: border),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: compact ? 10.8 : 11.5,
          letterSpacing: .15,
        ),
      ),
    );
  }
}
