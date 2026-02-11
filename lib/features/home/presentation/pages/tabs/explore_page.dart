import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/theme/app_colors.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const _bgAsset = "assets/images/homepagewall/homepagewallpaper.jpg";

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // ===== Breakpoints =====
          final isSmallPhone = w < 360; // iPhone SE / very small Android
          final isTablet = w >= 600 && w < 1024;
          final isLargeTablet = w >= 1024;

          // ===== Responsive scalars =====
          double clamp(double v, double min, double max) =>
              v.clamp(min, max).toDouble();

          // scale factor: 375 is typical iPhone width
          final s = clamp(w / 375.0, 0.88, 1.35);

          final pagePadH = (isTablet || isLargeTablet) ? 22.0 : 18.0;
          final topPad = isSmallPhone ? 8.0 : 10.0;

          // Header height tuned for small screens and tablets
          final headerH = isLargeTablet
              ? 380.0
              : isTablet
              ? 360.0
              : isSmallPhone
              ? 280.0
              : 320.0;

          // Cards height responsive
          final savingsCardH = isSmallPhone ? 124.0 : 140.0;
          final miniCardH = isSmallPhone ? 86.0 : 96.0;

          // Avatar + icon sizes
          final avatarRadius = isSmallPhone ? 20.0 : 24.0;
          final avatarIconSize = isSmallPhone ? 18.0 : 22.0;

          final topBtnSize = isSmallPhone ? 40.0 : 44.0;
          final topBtnIcon = isSmallPhone ? 18.0 : 20.0;

          // Blur amounts (a bit less on small for perf + clarity)
          final bgBlur = isSmallPhone ? 7.0 : 8.0;
          final headerBlur = isSmallPhone ? 14.0 : 16.0;
          final miniBlur = isSmallPhone ? 12.0 : 14.0;
          final sheetBlur = isSmallPhone ? 16.0 : 18.0;

          return SizedBox(
            height: h,
            width: w,
            child: Stack(
              children: [
                // ===== BACKGROUND IMAGE =====
                Positioned.fill(
                  child:
                      Image.asset(
                            _bgAsset,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            alignment: Alignment.topCenter,
                          )
                          .animate()
                          .fadeIn(duration: 260.ms)
                          .scale(
                            begin: const Offset(1.02, 1.02),
                            end: const Offset(1, 1),
                            duration: 480.ms,
                            curve: Curves.easeOutCubic,
                          ),
                ),

                // ===== SOFT BLUR =====
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: bgBlur, sigmaY: bgBlur),
                    child: const SizedBox.shrink(),
                  ),
                ),

                // ===== DARK OVERLAY =====
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(isDark ? .22 : .16),
                          Colors.black.withOpacity(isDark ? .38 : .28),
                          Colors.black.withOpacity(isDark ? .54 : .42),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== OPTIONAL GLOW BLOBS =====
                Positioned.fill(
                  child: IgnorePointer(
                    child: Stack(
                      children: [
                        Positioned(
                          top: isSmallPhone ? -100.0 : -120.0,
                          left: isSmallPhone ? -70.0 : -90.0,
                          child: _GlowBlob(
                            size: (isSmallPhone ? 240.0 : 280.0) * s,
                            color: Colors.white.withOpacity(.10),
                          ),
                        ),
                        Positioned(
                          top: isSmallPhone ? 20.0 : 30.0,
                          right: isSmallPhone ? -95.0 : -120.0,
                          child: _GlowBlob(
                            size: (isSmallPhone ? 280.0 : 320.0) * s,
                            color: Colors.white.withOpacity(.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // ===== HEADER CONTENT =====
                      SizedBox(
                        height: headerH,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            pagePadH,
                            topPad,
                            pagePadH,
                            0.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // top bar
                              Row(
                                children: [
                                  CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: Colors.white24,
                                        child: FaIcon(
                                          FontAwesomeIcons.user,
                                          color: Colors.white,
                                          size: avatarIconSize,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 220.ms)
                                      .scale(
                                        begin: const Offset(.9, .9),
                                        end: const Offset(1, 1),
                                        curve: Curves.easeOutBack,
                                        duration: 260.ms,
                                      ),
                                  const Spacer(),
                                  _TopIconButton(
                                        icon: FontAwesomeIcons.bell,
                                        onTap: () {},
                                        size: topBtnSize,
                                        iconSize: topBtnIcon,
                                      )
                                      .animate()
                                      .fadeIn(delay: 80.ms, duration: 220.ms)
                                      .slideX(begin: .15, end: 0),
                                ],
                              ),

                              SizedBox(height: isSmallPhone ? 10.0 : 14.0),

                              _SavingsEarnedCard(
                                    height: savingsCardH,
                                    blur: headerBlur,
                                    scale: s,
                                    isSmallPhone: isSmallPhone,
                                  )
                                  .animate()
                                  .fadeIn(delay: 120.ms, duration: 260.ms)
                                  .slideY(
                                    begin: .18,
                                    end: 0,
                                    duration: 320.ms,
                                    curve: Curves.easeOutCubic,
                                  ),

                              SizedBox(height: isSmallPhone ? 10.0 : 12.0),

                              _MiniInfoCard(
                                    height: miniCardH,
                                    blur: miniBlur,
                                    scale: s,
                                    isSmallPhone: isSmallPhone,
                                    isTablet: isTablet || isLargeTablet,
                                  )
                                  .animate()
                                  .fadeIn(delay: 170.ms, duration: 260.ms)
                                  .slideY(
                                    begin: .18,
                                    end: 0,
                                    duration: 320.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: _WalletSheet(
                          isDark: isDark,
                          width: w,
                          isSmallPhone: isSmallPhone,
                          isTablet: isTablet,
                          isLargeTablet: isLargeTablet,
                          blur: sheetBlur,
                          scale: s,
                        ).animate().fadeIn(delay: 120.ms, duration: 240.ms),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SavingsEarnedCard extends StatelessWidget {
  final double height;
  final double blur;
  final double scale;
  final bool isSmallPhone;

  const _SavingsEarnedCard({
    required this.height,
    required this.blur,
    required this.scale,
    required this.isSmallPhone,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = isSmallPhone ? 12.5 : 13.0;
    final valueSize = isSmallPhone ? 16.5 : 18.0;
    final labelSize = isSmallPhone ? 11.5 : 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(.14)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmallPhone ? 14.0 : 16.0,
                    isSmallPhone ? 12.0 : 14.0,
                    isSmallPhone ? 12.0 : 14.0,
                    isSmallPhone ? 12.0 : 14.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.piggyBank,
                            size: isSmallPhone ? 13.0 : 14.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Savings",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: titleSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallPhone ? 8.0 : 10.0),
                      Text(
                        "Yield limit",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.70),
                          fontWeight: FontWeight.w600,
                          fontSize: labelSize,
                        ),
                      ),
                      SizedBox(height: isSmallPhone ? 8.0 : 10.0),
                      const _FakeSlider(valueText: "\$0"),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            "\$0",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.70),
                              fontWeight: FontWeight.w700,
                              fontSize: labelSize,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$0",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.70),
                              fontWeight: FontWeight.w700,
                              fontSize: labelSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: Colors.white.withOpacity(.12)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isSmallPhone ? 14.0 : 16.0,
                    isSmallPhone ? 12.0 : 14.0,
                    isSmallPhone ? 14.0 : 16.0,
                    isSmallPhone ? 12.0 : 14.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.coins,
                            size: isSmallPhone ? 13.0 : 14.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Earned",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: titleSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallPhone ? 10.0 : 14.0),
                      Text(
                        "\$0.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: valueSize,
                        ),
                      ),
                      SizedBox(height: isSmallPhone ? 6.0 : 8.0),
                      Text(
                        "Payout in 00:00:00",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.70),
                          fontWeight: FontWeight.w600,
                          fontSize: labelSize,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final double height;
  final double blur;
  final double scale;
  final bool isSmallPhone;
  final bool isTablet;

  const _MiniInfoCard({
    required this.height,
    required this.blur,
    required this.scale,
    required this.isSmallPhone,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final pillGap = isSmallPhone ? 8.0 : 10.0;

    final pills = <Widget>[
      const _MiniPill(
        icon: FontAwesomeIcons.wallet,
        title: "Wallet",
        subtitle: "—",
      ),
      const SizedBox(width: 10),
      const _MiniPill(
        icon: FontAwesomeIcons.chartLine,
        title: "Trend",
        subtitle: "—",
      ),
      const SizedBox(width: 10),
      const _MiniPill(
        icon: FontAwesomeIcons.bolt,
        title: "Quick",
        subtitle: "—",
      ),
    ];

    final pillsTablet = <Widget>[
      const _MiniPill(
        icon: FontAwesomeIcons.wallet,
        title: "Wallet",
        subtitle: "—",
      ),
      const SizedBox(width: 10),
      const _MiniPill(
        icon: FontAwesomeIcons.chartLine,
        title: "Trend",
        subtitle: "—",
      ),
      const SizedBox(width: 10),
      const _MiniPill(
        icon: FontAwesomeIcons.bolt,
        title: "Quick",
        subtitle: "—",
      ),
      const SizedBox(width: 10),
      const _MiniPill(
        icon: FontAwesomeIcons.shieldHalved,
        title: "Secure",
        subtitle: "—",
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(.14)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallPhone ? 12.0 : 14.0,
              isSmallPhone ? 10.0 : 12.0,
              isSmallPhone ? 12.0 : 14.0,
              isSmallPhone ? 10.0 : 12.0,
            ),
            child: Row(
              children: [
                ...((isTablet) ? pillsTablet : pills)
                    .map((w) => w is SizedBox ? SizedBox(width: pillGap) : w)
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniPill({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isSmallPhone = w < 360;

    final double iconSize = isSmallPhone ? 15.0 : 16.0; // ✅ FIX
    final double titleSize = isSmallPhone ? 12.0 : 12.5;
    final double subSize = isSmallPhone ? 11.0 : 11.5;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallPhone ? 10.0 : 12.0,
          vertical: isSmallPhone ? 9.0 : 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.12)),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: Colors.white.withOpacity(.92), size: iconSize),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: titleSize,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.72),
                      fontWeight: FontWeight.w700,
                      fontSize: subSize,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: size / 2 + 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(.12)),
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: Colors.white.withOpacity(.92),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

// =====================
// ✅ GLASS MENU SHEET (responsive grid)
// =====================
class _WalletSheet extends StatelessWidget {
  final bool isDark;
  final double width;
  final bool isSmallPhone;
  final bool isTablet;
  final bool isLargeTablet;
  final double blur;
  final double scale;

  const _WalletSheet({
    required this.isDark,
    required this.width,
    required this.isSmallPhone,
    required this.isTablet,
    required this.isLargeTablet,
    required this.blur,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final bg = const Color.fromARGB(
      255,
      0,
      30,
      81,
    ).withOpacity(isDark ? .18 : .14);
    final border = Colors.white.withOpacity(isDark ? .18 : .22);

    final crossAxisCount = isLargeTablet ? 6 : (isTablet ? 5 : 4);
    final spacing = isSmallPhone ? 14.0 : 18.0;

    final childAspectRatio = isLargeTablet
        ? 0.95
        : isTablet
        ? 0.92
        : isSmallPhone
        ? 0.88
        : 0.92;

    final titleSize = isSmallPhone ? 16.0 : 18.0;

    final items = <_QuickMenuItem>[
      _QuickMenuItem(
        icon: FontAwesomeIcons.rightLeft,
        label: "ໂອນເງິນ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.receipt,
        label: "ປະຫວັດທຸລະກໍາ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.creditCard,
        label: "ທຸລະກໍາລໍາດັບ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.idCard,
        label: "ບັນຊີຝາກປະຈໍາ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.wallet,
        label: "ເຕີມເງິນເຂົ້າກະເປົ໋າ",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.sackDollar,
        label: "ຈ່າຍສິນເຊື່ອ\nCredit",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.commentSms,
        label: "ສະໝັກແຈ້ງເຕືອນ\nSMS",
        onTap: () {},
      ),
      _QuickMenuItem(
        icon: FontAwesomeIcons.userGroup,
        label: "ໂອນລອຍ",
        onTap: () {},
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        const revealTop = 12.0;

        return Column(
          children: [
            const SizedBox(height: revealTop),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                  0.0,
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                  (isTablet || isLargeTablet) ? 18.0 : 14.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                            color: Colors.black.withOpacity(isDark ? .30 : .14),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(.12),
                                    Colors.white.withOpacity(.04),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              isSmallPhone ? 16.0 : 18.0,
                              isSmallPhone ? 14.0 : 16.0,
                              isSmallPhone ? 16.0 : 18.0,
                              isSmallPhone ? 16.0 : 18.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ເມນູທັງຫມົດ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.95),
                                    fontWeight: FontWeight.w900,
                                    fontSize: titleSize,
                                  ),
                                ),
                                SizedBox(height: isSmallPhone ? 12.0 : 14.0),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: spacing,
                                        crossAxisSpacing: spacing,
                                        childAspectRatio: childAspectRatio,
                                      ),
                                  itemBuilder: (context, i) {
                                    final it = items[i];
                                    return _QuickMenuTile(
                                          item: it,
                                          isDark: isDark,
                                          isSmallPhone: isSmallPhone,
                                          isTablet: isTablet || isLargeTablet,
                                        )
                                        .animate()
                                        .fadeIn(
                                          delay: (60 + i * 45).ms,
                                          duration: 220.ms,
                                        )
                                        .slideY(begin: .12, end: 0);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });
}

class _QuickMenuTile extends StatelessWidget {
  final _QuickMenuItem item;
  final bool isDark;
  final bool isSmallPhone;
  final bool isTablet;

  const _QuickMenuTile({
    required this.item,
    required this.isDark,
    required this.isSmallPhone,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = item.enabled;

    final ring = Colors.white.withOpacity(enabled ? .85 : .35);
    final circleBg = Colors.white.withOpacity(enabled ? .08 : .04);

    final iconC = Colors.white.withOpacity(enabled ? .95 : .40);
    final textC = Colors.white.withOpacity(enabled ? .92 : .40);

    final double circle = isTablet ? 72.0 : (isSmallPhone ? 56.0 : 66.0);
    final double iconSize = isTablet ? 24.0 : (isSmallPhone ? 20.0 : 22.0);
    final double labelSize = isTablet ? 12.0 : (isSmallPhone ? 10.8 : 11.5);

    return InkResponse(
      onTap: enabled ? item.onTap : null,
      radius: circle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: circle,
            height: circle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
              border: Border.all(color: ring, width: 1.2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withOpacity(enabled ? .18 : .08),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(item.icon, color: iconC, size: iconSize),
            ),
          ),
          SizedBox(height: isSmallPhone ? 8.0 : 10.0),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.08,
              color: textC,
              fontWeight: FontWeight.w800,
              fontSize: labelSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowBlob({required this.size, required this.color});

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

class _FakeSlider extends StatelessWidget {
  final String valueText;
  const _FakeSlider({required this.valueText});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isSmallPhone = w < 360;

    return Container(
      height: isSmallPhone ? 30.0 : 34.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 8.0 : 10.0),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: isSmallPhone ? 9.0 : 10.0,
                width: isSmallPhone ? 90.0 : 120.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Text(
            valueText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isSmallPhone ? 11.5 : 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
