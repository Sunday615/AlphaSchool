import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Profile page UI inspired by the provided design.
/// - Header uses background image
/// - Title centered in header (smaller)
/// - Big white profile card (avatar bigger)
/// - Verified check mark is GREEN
/// - "GENERAL" section with modern menu tiles
/// - Smooth animations using flutter_animate
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.title = 'Profile',
    this.name = 'Your Name',
    this.email = 'you@email.com',
    this.verified = true,
    this.avatarImage = const AssetImage('assets/images/profile/me.jpg'),
    this.headerImage = const AssetImage(
      'assets/images/homepagewall/mainbg.jpeg',
    ),
    this.onEdit,
    this.items,
  });

  final String title;
  final String name;
  final String email;
  final bool verified;
  final ImageProvider avatarImage;

  /// ✅ header background image
  final ImageProvider headerImage;

  final VoidCallback? onEdit;

  /// Optional custom menu items. If null, demo items are shown.
  final List<ProfileMenuItem>? items;

  static const _pageBg = Color(0xFFF3F5F9);

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;

    final menu =
        items ??
        const [
          ProfileMenuItem(
            icon: FontAwesomeIcons.gear,
            title: 'Profile Settings',
            subtitle: 'Update and modify your profile',
          ),
          ProfileMenuItem(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'Privacy',
            subtitle: 'Change your password',
          ),
          ProfileMenuItem(
            icon: FontAwesomeIcons.bell,
            title: 'Notifications',
            subtitle: 'Change your notification settings',
          ),
        ];

    void goBackHomeShell() {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      backgroundColor: _pageBg,
      body: Stack(
        children: [
          // ✅ Header background IMAGE ONLY
          SizedBox(
            height: 330 + safeTop,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child:
                      Image(
                            image: headerImage,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFF0B5FE0)),
                          )
                          .animate()
                          .fadeIn(duration: 260.ms)
                          .scale(
                            begin: const Offset(1.02, 1.02),
                            end: const Offset(1, 1),
                            duration: 520.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CenteredTopBar(
                        title: title,
                        onBack: goBackHomeShell,
                        onEdit: onEdit,
                      )
                      .animate()
                      .fadeIn(duration: 280.ms)
                      .slideY(begin: -0.06, end: 0, duration: 320.ms),

                  const SizedBox(height: 18),

                  _ProfileCard(
                        avatarImage: avatarImage,
                        name: name,
                        email: email,
                        verified: verified,
                      )
                      .animate()
                      .fadeIn(duration: 320.ms, delay: 80.ms)
                      .slideY(begin: 0.08, end: 0, duration: 380.ms)
                      .scale(
                        begin: const Offset(0.98, 0.98),
                        end: const Offset(1, 1),
                        duration: 380.ms,
                        curve: Curves.easeOutBack,
                        delay: 80.ms,
                      ),

                  const SizedBox(height: 26),

                  Text(
                        'GENERAL',
                        style: TextStyle(
                          color: Colors.black.withAlpha(120),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 260.ms, delay: 140.ms)
                      .slideY(begin: 0.10, end: 0, duration: 320.ms),

                  const SizedBox(height: 12),

                  ...List.generate(menu.length, (i) {
                    final it = menu[i];
                    return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _MenuTile(item: it),
                        )
                        .animate()
                        .fadeIn(duration: 260.ms, delay: (160 + i * 70).ms)
                        .slideX(begin: 0.06, end: 0, duration: 340.ms);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Top bar with true centered title (smaller)
class _CenteredTopBar extends StatelessWidget {
  const _CenteredTopBar({
    required this.title,
    required this.onBack,
    required this.onEdit,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
              height: 1.0,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _BackPillButton(onTap: onBack),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _EditButton(onTap: onEdit),
          ),
        ],
      ),
    );
  }
}

class _BackPillButton extends StatelessWidget {
  const _BackPillButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Ink(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(40)),
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 260.ms, delay: 90.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 280.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.avatarImage,
    required this.name,
    required this.email,
    required this.verified,
  });

  final ImageProvider avatarImage;
  final String name;
  final String email;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final shadow = Colors.black.withAlpha(25);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(245),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withAlpha(160)),
            boxShadow: [
              BoxShadow(
                color: shadow,
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            children: [
              // ✅ Avatar (bigger a bit more)
              Container(
                    width: 132, // ✅ bigger
                    height: 132, // ✅ bigger
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(20),
                      borderRadius: BorderRadius.circular(34), // ✅ match size
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: Image(
                        image: avatarImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.person_rounded, size: 60),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 280.ms)
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                    duration: 360.ms,
                  ),

              const SizedBox(height: 14),

              // Name + verified (GREEN)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (verified) ...[
                    const SizedBox(width: 8),
                    Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E), // ✅ green
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 240.ms, delay: 120.ms)
                        .scale(curve: Curves.easeOutBack, duration: 320.ms),
                  ],
                ],
              ),

              const SizedBox(height: 6),

              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(120),
                ),
              ).animate().fadeIn(duration: 240.ms, delay: 120.ms),

              const SizedBox(height: 16),

              // Badges row
              Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withAlpha(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Badge(
                          icon: FontAwesomeIcons.medal,
                          bg: Color(0xFFD1FAE5),
                          fg: Color(0xFF10B981),
                        ),
                        _Badge(
                          icon: FontAwesomeIcons.award,
                          bg: Color(0xFFEDE9FE),
                          fg: Color(0xFF7C3AED),
                        ),
                        _Badge(
                          icon: FontAwesomeIcons.shield,
                          bg: Color(0xFFDBEAFE),
                          fg: Color(0xFF2563EB),
                        ),
                        _Badge(
                          icon: FontAwesomeIcons.sackDollar,
                          bg: Color(0xFFFFEDD5),
                          fg: Color(0xFFF97316),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 260.ms, delay: 160.ms)
                  .slideY(begin: 0.12, end: 0, duration: 360.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.bg, required this.fg});

  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(child: FaIcon(icon, size: 22, color: fg)),
    ).animate().scale(
      begin: const Offset(0.96, 0.96),
      end: const Offset(1, 1),
      duration: 280.ms,
      curve: Curves.easeOutBack,
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final ProfileMenuItem item;

  @override
  Widget build(BuildContext context) {
    const iconBg = Color(0xFFEAF1FF);
    const iconFg = Color(0xFF2563EB);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: item.onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withAlpha(14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(14),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: FaIcon(item.icon, size: 20, color: iconFg),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.black.withAlpha(90),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Ink(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(28),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(40)),
              ),
              child: const Center(
                child: Icon(Icons.edit_rounded, color: Colors.white),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 260.ms, delay: 120.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 280.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
}
