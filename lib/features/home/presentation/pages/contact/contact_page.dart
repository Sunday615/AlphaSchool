import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

/// ✅ Model: Contact info ของโรงเรียน
///
/// แนะนำ: ตอนเรียกหน้า ให้ส่ง info ที่เป็นข้อมูลจริงเข้ามา
/// เช่น ContactPage(info: SchoolContactInfo(...))
class SchoolContactInfo {
  final String schoolName;

  /// Asset path โลโก้โรงเรียน
  /// - ใส่ไฟล์จริงใน assets แล้วประกาศใน pubspec.yaml
  final String logoAsset;

  final String phone;
  final String email;

  /// Social
  final String facebook;
  final String whatsapp;

  /// Website
  final String website;

  /// Location (ข้อความที่อยู่)
  final String location;

  const SchoolContactInfo({
    required this.schoolName,
    required this.logoAsset,
    required this.phone,
    required this.email,
    required this.facebook,
    required this.whatsapp,
    required this.website,
    required this.location,
  });

  /// ✅ ตัวอย่าง (เปลี่ยนเป็นข้อมูลจริงของคุณได้)
  static const demo = SchoolContactInfo(
    schoolName: 'Your School Name',
    logoAsset: 'assets/images/school_logo.png',
    phone: '+856 20 0000 0000',
    email: 'school@email.com',
    facebook: 'facebook.com/your-school',
    whatsapp: '+856 20 0000 0000',
    website: 'https://your-school.com',
    location: 'Vientiane, Lao PDR',
  );
}

class ContactPage extends StatelessWidget {
  final SchoolContactInfo info;

  const ContactPage({super.key, this.info = SchoolContactInfo.demo});

  static const double _maxWidth = 560;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode, // ✅ ผูกกับ year_picker (global)
      builder: (context, mode, _) {
        final locale = Localizations.localeOf(context);
        final base = (mode == ThemeMode.dark)
            ? AppTheme.darkTheme(locale)
            : AppTheme.lightTheme(locale);

        return AnimatedTheme(
          data: base,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final t = Theme.of(context);
              final isDark = t.brightness == Brightness.dark;
              final cs = t.colorScheme;

              final titleColor = isDark ? Colors.white : AppColors.blue500;
              final muted = isDark
                  ? Colors.white.withOpacity(.74)
                  : AppColors.blue500.withOpacity(.62);

              final border = isDark
                  ? Colors.white.withOpacity(.10)
                  : AppColors.slate.withOpacity(.12);

              final cardBg = isDark ? AppTheme.darkBluePremium : cs.surface;
              final shadow = Colors.black.withOpacity(isDark ? .25 : .08);

              final bgGradient = isDark
                  ? AppTheme.premiumDarkGradient
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.blue500.withOpacity(.10),
                        Colors.white,
                        AppColors.blue400.withOpacity(.05),
                      ],
                    );

              return Scaffold(
                backgroundColor: t.scaffoldBackgroundColor,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  foregroundColor: titleColor,
                  title: const Text('Contact'),
                  centerTitle: true,
                ),
                body: Container(
                  decoration: BoxDecoration(gradient: bgGradient),
                  child: SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _maxWidth),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ===== Header Card =====
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardBg.withOpacity(isDark ? .88 : 1),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: border),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                      color: shadow,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _LogoFrame(
                                          assetPath: info.logoAsset,
                                          isDark: isDark,
                                          borderColor: border,
                                        )
                                        .animate()
                                        .fadeIn(duration: 220.ms)
                                        .slideY(
                                          begin: .06,
                                          end: 0,
                                          duration: 220.ms,
                                          curve: Curves.easeOut,
                                        ),
                                    const SizedBox(height: 14),
                                    Text(
                                      info.schoolName,
                                      textAlign: TextAlign.center,
                                      style: t.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: titleColor,
                                        letterSpacing: -.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Phone • Email • Social • Website • Location',
                                      textAlign: TextAlign.center,
                                      style: t.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ===== Contact List Card =====
                              Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: cardBg.withOpacity(
                                        isDark ? .86 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: border),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                          color: shadow,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        _ContactTile(
                                          icon: Icons.phone_rounded,
                                          label: 'Phone',
                                          value: info.phone,
                                          isDark: isDark,
                                          accent: const Color(0xFF22C55E),
                                          onCopy: () =>
                                              _copy(context, info.phone),
                                        ),
                                        const SizedBox(height: 10),
                                        _ContactTile(
                                          icon: Icons.email_rounded,
                                          label: 'Email',
                                          value: info.email,
                                          isDark: isDark,
                                          accent: const Color(0xFF3B82F6),
                                          onCopy: () =>
                                              _copy(context, info.email),
                                        ),
                                        const SizedBox(height: 10),
                                        _ContactTile(
                                          icon: Icons.facebook,
                                          label: 'Facebook',
                                          value: info.facebook,
                                          isDark: isDark,
                                          accent: const Color(0xFF1877F2),
                                          onCopy: () =>
                                              _copy(context, info.facebook),
                                        ),
                                        const SizedBox(height: 10),
                                        _ContactTile(
                                          icon: Icons.message_rounded,
                                          label: 'WhatsApp',
                                          value: info.whatsapp,
                                          isDark: isDark,
                                          accent: const Color(0xFF25D366),
                                          onCopy: () =>
                                              _copy(context, info.whatsapp),
                                        ),
                                        const SizedBox(height: 10),
                                        _ContactTile(
                                          icon: Icons.language_rounded,
                                          label: 'Website',
                                          value: info.website,
                                          isDark: isDark,
                                          accent: const Color(0xFFF59E0B),
                                          onCopy: () =>
                                              _copy(context, info.website),
                                        ),
                                        const SizedBox(height: 10),
                                        _ContactTile(
                                          icon: Icons.location_on_rounded,
                                          label: 'Location',
                                          value: info.location,
                                          isDark: isDark,
                                          accent: const Color(0xFFEF4444),
                                          onCopy: () =>
                                              _copy(context, info.location),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 80.ms, duration: 240.ms)
                                  .slideY(
                                    begin: .05,
                                    end: 0,
                                    duration: 240.ms,
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: 14),

                              // ===== Tip =====
                              Text(
                                'Tip: Tap the copy icon to copy each field.',
                                textAlign: TextAlign.center,
                                style: t.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
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

  static Future<void> _copy(BuildContext context, String text) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text.trim()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }
}

class _LogoFrame extends StatelessWidget {
  final String assetPath;
  final bool isDark;
  final Color borderColor;

  const _LogoFrame({
    required this.assetPath,
    required this.isDark,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final ring = isDark
        ? Colors.white.withOpacity(.16)
        : AppColors.slate.withOpacity(.12);

    final bg = isDark
        ? Colors.white.withOpacity(.06)
        : AppColors.grayUltraLight.withOpacity(.55);

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 1.2),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(isDark ? .30 : .08),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              // ✅ ถ้า asset ยังไม่มี -> แสดงไอคอนแทน เพื่อไม่ให้แอปพัง
              return Icon(
                Icons.school_rounded,
                size: 52,
                color: isDark
                    ? Colors.white.withOpacity(.82)
                    : AppColors.blue500,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final Color accent;
  final VoidCallback onCopy;
  final int maxLines;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.accent,
    required this.onCopy,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final tileBg = isDark
        ? Colors.white.withOpacity(.06)
        : AppColors.grayUltraLight.withOpacity(.50);

    final stroke = isDark
        ? Colors.white.withOpacity(.10)
        : AppColors.slate.withOpacity(.12);

    final valueColor = isDark ? Colors.white : AppColors.blue500;
    final muted = isDark
        ? Colors.white.withOpacity(.72)
        : AppColors.blue500.withOpacity(.62);

    final hasValue = value.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: stroke),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(isDark ? .18 : .12),
              border: Border.all(color: accent.withOpacity(isDark ? .30 : .18)),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: t.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: muted,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasValue ? value : '-',
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: hasValue ? valueColor : muted,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Copy',
            onPressed: hasValue ? onCopy : null,
            icon: Icon(
              Icons.copy_rounded,
              color: hasValue
                  ? (isDark ? Colors.white.withOpacity(.88) : AppColors.blue500)
                  : muted,
            ),
          ),
        ],
      ),
    );
  }
}
