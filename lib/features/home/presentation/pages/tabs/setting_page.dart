import 'package:alpha_school/features/home/presentation/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ✅ ใช้ไฟล์ profile.dart ของคุณแทน (แก้ path ให้ตรง)
// ตัวอย่าง:
// import 'profile.dart';
// import '../pages/profile.dart';
// import 'package:your_app/pages/profile.dart';

/// ✅ Settings page UI (updated)
/// - Back arrow (left)
/// - "Settings" centered
/// - Account -> ProfilePage (from profile.dart)
/// - Dark/Light mode toggle
/// - Language picker (bottom sheet overlay) with flags (Laos / English)
/// - Logout as red button
/// - Smooth stagger animations (flutter_animate)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.title = 'Settings'});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _bg = Colors.white;
  static const _titleColor = Color(0xFF111827);
  static const _textColor = Color(0xFF6B7280);
  static const _iconColor = Color(0xFF111827);
  static const _chevColor = Color(0xFF9CA3AF);
  static const _divider = Color(0xFFF1F5F9);

  bool _isDarkMode = false;

  /// 'lo' or 'en'
  String _lang = 'lo';

  void _back() => Navigator.of(context).maybePop();

  void _openProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      // Account -> Profile
      _SettingsTile(
        icon: FontAwesomeIcons.user,
        label: 'Account',
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 26,
          color: _chevColor,
        ),
        onTap: _openProfile,
        iconColor: _iconColor.withOpacity(.75),
        textColor: _textColor,
      ),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(height: 1, color: _divider),
      ),

      // Dark/Light toggle
      _SettingsSwitchTile(
        icon: FontAwesomeIcons.moon,
        label: _isDarkMode ? 'Dark mode' : 'Light mode',
        value: _isDarkMode,
        onChanged: (v) => setState(() => _isDarkMode = v),
        iconColor: _iconColor.withOpacity(.75),
        textColor: _textColor,
      ),

      const SizedBox(height: 14),

      // Language
      _SettingsTile(
        icon: FontAwesomeIcons.globe,
        label: 'Language',
        valueText: _lang == 'lo' ? 'Laos' : 'English',
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 26,
          color: _chevColor,
        ),
        onTap: _openLanguageSheet,
        iconColor: _iconColor.withOpacity(.75),
        textColor: _textColor,
      ),

      const SizedBox(height: 18),

      // Logout button
      _LogoutButton(
        onTap: () {
          // TODO: your logout logic
        },
      ),
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Top Bar =====
            Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                  child: _TopBar(title: widget.title, onBack: _back),
                )
                .animate()
                .fadeIn(duration: 260.ms)
                .slideY(begin: -0.10, end: 0, duration: 320.ms),

            const SizedBox(height: 8),

            // ===== Content =====
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                children: [
                  _SectionCard(
                    child: Column(
                      children: [
                        for (int i = 0; i < tiles.length; i++)
                          tiles[i]
                              .animate()
                              .fadeIn(
                                delay: (80 + (i * 55)).ms,
                                duration: 240.ms,
                              )
                              .slideY(
                                begin: 0.10,
                                end: 0,
                                delay: (80 + (i * 55)).ms,
                                duration: 300.ms,
                                curve: Curves.easeOutCubic,
                              ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 120.ms, duration: 280.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        final items = [
          _LangItem(
            code: 'lo',
            title: 'Laos',
            flag: const Text('🇱🇦', style: TextStyle(fontSize: 22)),
          ),
          _LangItem(
            code: 'en',
            title: 'English',
            flag: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
          ),
        ];

        return _BottomSheetShell(
          title: 'Select language',
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++)
                _LanguageRow(
                      item: items[i],
                      selected: _lang == items[i].code,
                      onTap: () {
                        setState(() => _lang = items[i].code);
                        Navigator.of(context).pop();
                      },
                    )
                    .animate()
                    .fadeIn(delay: (60 + i * 70).ms, duration: 220.ms)
                    .slideY(
                      begin: 0.12,
                      end: 0,
                      delay: (60 + i * 70).ms,
                      duration: 280.ms,
                      curve: Curves.easeOutCubic,
                    ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _SettingsPageState._titleColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
              color: _SettingsPageState._titleColor,
              splashRadius: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 0,
            offset: Offset(0, 8),
            color: Color(0x0A111827),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
    required this.iconColor,
    required this.textColor,
    this.valueText,
  });

  final IconData icon;
  final String label;
  final String? valueText;
  final Widget trailing;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Center(child: FaIcon(icon, size: 20, color: iconColor)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (valueText != null) ...[
                Text(
                  valueText!,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.iconColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Center(child: FaIcon(icon, size: 20, color: iconColor)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.95,
                child: Switch.adaptive(value: value, onChanged: onChanged),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFFEF2F2),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                    size: 18,
                    color: Color(0xFFDC2626),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 220.ms, duration: 260.ms)
        .slideY(
          begin: 0.10,
          end: 0,
          delay: 220.ms,
          duration: 320.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _BottomSheetShell extends StatelessWidget {
  const _BottomSheetShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, 12),
              color: Color(0x14000000),
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
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 20,
                  color: const Color(0xFF9CA3AF),
                ),
              ],
            ),
            const SizedBox(height: 6),
            child,
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _LangItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected ? const Color(0xFF111827) : const Color(0xFFF1F5F9);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            color: selected ? const Color(0xFFF9FAFB) : Colors.white,
          ),
          child: Row(
            children: [
              item.flag,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_rounded, color: Color(0xFF111827)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangItem {
  const _LangItem({
    required this.code,
    required this.title,
    required this.flag,
  });

  final String code;
  final String title;
  final Widget flag;
}
