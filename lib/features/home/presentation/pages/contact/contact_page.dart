import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/app_page_template.dart';

/// ✅ Model: Contact info ของโรงเรียน
class SchoolContactInfo {
  final String schoolName;

  /// Asset path โลโก้โรงเรียน
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

  /// ✅ ใช้ background ของ template (รูปดิบ 100%)
  final String backgroundAsset;

  const ContactPage({
    super.key,
    this.info = SchoolContactInfo.demo,
    this.backgroundAsset = 'assets/images/homepagewall/mainbg.jpeg',
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, mode, _) {
        final locale = Localizations.localeOf(context);
        final base = (mode == ThemeMode.dark)
            ? AppTheme.darkTheme(locale)
            : AppTheme.lightTheme(locale);

        return AnimatedTheme(
          data: base,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Builder(
            builder: (context) {
              final t = Theme.of(context);
              final cs = t.colorScheme;
              final isDark = t.brightness == Brightness.dark;

              // ✅ make card look correct inside template big container
              final cardColor = isDark
                  ? Colors.white.withOpacity(.06)
                  : const Color(0xFFFFFFFF);

              final border = isDark
                  ? Colors.white.withOpacity(.10)
                  : Colors.black.withOpacity(.06);

              final shadow = Colors.black.withOpacity(isDark ? .45 : .10);
              final muted = cs.onSurface.withOpacity(.70);

              final items = <_ContactItem>[
                _ContactItem(
                  'Phone',
                  info.phone,
                  FontAwesomeIcons.phone,
                  iconColor: const Color(0xFF22C55E),
                ),
                _ContactItem(
                  'Email',
                  info.email,
                  FontAwesomeIcons.envelope,
                  iconColor: const Color(0xFF3B82F6),
                ),
                _ContactItem(
                  'Facebook',
                  info.facebook,
                  FontAwesomeIcons.facebookF,
                  iconColor: const Color(0xFF2563EB),
                ),
                _ContactItem(
                  'WhatsApp',
                  info.whatsapp,
                  FontAwesomeIcons.whatsapp,
                  iconColor: const Color(0xFF16A34A),
                ),
                _ContactItem(
                  'Website',
                  info.website,
                  FontAwesomeIcons.globe,
                  iconColor: const Color(0xFF14B8A6),
                ),
                _ContactItem(
                  'Location',
                  info.location,
                  FontAwesomeIcons.locationDot,
                  iconColor: const Color(0xFFF59E0B),
                  maxLines: 3,
                ),
              ];

              return AppPageTemplate(
                title: 'ຕິດຕໍ່ໂຮງຮຽນ',
                backgroundAsset: backgroundAsset,

                /// template already animates bg/topbar/container
                animate: true,
                showBack: true,

                /// ✅ let template do scrolling; inside just Column (no scroll)
                scrollable: true,
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

                /// ✅ keep premium dark gradient on dark mode
                premiumDark: true,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderCard(info: info, shadow: shadow)
                        .animate()
                        .fadeIn(duration: 180.ms)
                        .slideY(
                          begin: .05,
                          end: 0,
                          duration: 220.ms,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 14),
                    _ContactCard(
                          items: items,
                          cardColor: cardColor,
                          border: border,
                          shadow: shadow,
                        )
                        .animate()
                        .fadeIn(delay: 60.ms, duration: 220.ms)
                        .slideY(
                          begin: .04,
                          end: 0,
                          duration: 240.ms,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 14),
                    Text(
                      '',
                      textAlign: TextAlign.center,
                      style: t.textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final SchoolContactInfo info;
  final Color shadow;

  const _HeaderCard({required this.info, required this.shadow});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    // ✅ Dark-blue gradient header + white text (always)
    const headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF071A33), Color(0xFF0B2B5B), Color(0xFF123B7A)],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: headerGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      child: Column(
        children: [
          _LogoAvatar(assetPath: info.logoAsset),
          const SizedBox(height: 12),
          Text(
            info.schoolName,
            textAlign: TextAlign.center,
            style: t.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Phone • Email • Social • Website • Location',
            textAlign: TextAlign.center,
            style: t.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.78),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.85),
                  Colors.white.withOpacity(.35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoAvatar extends StatelessWidget {
  final String assetPath;

  const _LogoAvatar({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(.10),
        border: Border.all(color: Colors.white.withOpacity(.22), width: 1.6),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(.22),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipOval(
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: FaIcon(
                FontAwesomeIcons.school,
                size: 44,
                color: cs.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactItem {
  final String label;
  final String value;
  final IconData icon;
  final int maxLines;
  final Color iconColor;

  const _ContactItem(
    this.label,
    this.value,
    this.icon, {
    this.maxLines = 1,
    required this.iconColor,
  });
}

class _ContactCard extends StatelessWidget {
  final List<_ContactItem> items;
  final Color cardColor;
  final Color border;
  final Color shadow;

  const _ContactCard({
    required this.items,
    required this.cardColor,
    required this.border,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final isDark = t.brightness == Brightness.dark;

    final dividerColor = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.06);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(blurRadius: 18, offset: const Offset(0, 10), color: shadow),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _ContactRow(
              item: items[i],
              onCopy: () => _copy(context, items[i].value),
            ),
            if (i != items.length - 1)
              Divider(height: 1, thickness: 1, color: dividerColor),
          ],
        ],
      ),
    );
  }

  static Future<void> _copy(BuildContext context, String text) async {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: cleaned));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0B2B5B)
            : null,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final _ContactItem item;
  final VoidCallback onCopy;

  const _ContactRow({required this.item, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final isDark = t.brightness == Brightness.dark;

    final labelColor = cs.onSurface.withOpacity(.62);
    final valueColor = cs.onSurface;

    final hasValue = item.value.trim().isNotEmpty;

    // ✅ icon bubble
    final bubbleBg = isDark
        ? Colors.white.withOpacity(.10)
        : const Color(0xFFF3F4F6);

    final bubbleBorder = isDark
        ? Colors.white.withOpacity(.12)
        : Colors.black.withOpacity(.06);

    return InkWell(
      onTap: hasValue ? onCopy : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: item.maxLines > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bubbleBg,
                border: Border.all(color: bubbleBorder),
              ),
              child: Center(
                child: FaIcon(item.icon, color: item.iconColor, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: t.textTheme.labelLarge?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasValue ? item.value : '-',
                    maxLines: item.maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: t.textTheme.bodyLarge?.copyWith(
                      color: hasValue ? valueColor : labelColor,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FaIcon(
              FontAwesomeIcons.copy,
              size: 18,
              color: hasValue
                  ? (isDark
                        ? Colors.white.withOpacity(.70)
                        : Colors.black.withOpacity(.45))
                  : cs.onSurface.withOpacity(.25),
            ),
          ],
        ),
      ),
    );
  }
}
