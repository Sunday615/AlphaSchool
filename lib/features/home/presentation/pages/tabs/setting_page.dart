import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.blue500;

    return Padding(
      key: const ValueKey("SettingPage"),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          _DemoCard(
            isDark: isDark,
            title: "Setting page (demo)",
            subtitle: "You can add settings, info, etc.",
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;

  const _DemoCard({
    required this.isDark,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? AppColors.grayUltraLight.withOpacity(.78)
        : AppColors.blue500.withOpacity(.62);

    final border = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    final cardBg = isDark ? AppColors.blue500.withOpacity(.10) : Colors.white;

    final shadow = Colors.black.withOpacity(isDark ? .20 : .06);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontWeight: FontWeight.w700, color: muted),
          ),
        ],
      ),
    );
  }
}
