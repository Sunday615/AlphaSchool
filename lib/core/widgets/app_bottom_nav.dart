import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_colors.dart';

class AppBottomNavItem {
  final IconData icon;
  final String label;

  const AppBottomNavItem({required this.icon, required this.label});
}

class AppBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<AppBottomNavItem> items;

  /// center plus button
  final VoidCallback? onPlusPressed;
  final IconData plusIcon;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
    this.onPlusPressed,
    this.plusIcon = FontAwesomeIcons.qrcode,
  }) : assert(items.length == 4, "Use exactly 4 menus.");

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _plusPulse = 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    // ===== tuned like the reference image =====
    const outerPad = 14.0; // ✅ ใช้กับตัว bar เท่านั้น (ไม่ใช้กับเส้นบน)
    const barH = 88.0;
    const radius = 30.0;

    const fabD = 66.0;
    const notchDepth = 22.0;
    final notchRadius = fabD * 0.52;

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final topSpace = (fabD / 2 - notchDepth).clamp(10.0, 18.0).toDouble();

    // ✅ เพิ่มช่องว่างกลางนิดหนึ่ง ให้เมนูไม่ชิด qrcode
    final centerGap = fabD * 1.06;

    // ✅ ปรับระยะเมนูที่ติดกลาง (index 1 & 2) ให้ถอยออกจาก qrcode นิดหนึ่ง
    const nearCenterPad = 8.0;

    // ===== colors =====
    final barBg = isDark ? AppColors.dark.withOpacity(.90) : Colors.white;

    // ✅ เส้นด้านบนเท่านั้น (ไม่มีซ้าย/ขวา/ล่าง)
    final topStroke = isDark
        ? Colors.white.withOpacity(.14)
        : Colors.black.withOpacity(.10);

    final shadowColor = Colors.black.withOpacity(isDark ? .28 : .12);

    final active = isDark ? Colors.white : AppColors.blue500;

    final inactiveIcon = isDark
        ? Colors.white.withOpacity(.70)
        : Colors.black.withOpacity(.42);

    final inactiveLabel = isDark
        ? Colors.white.withOpacity(.68)
        : Colors.black.withOpacity(.56);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(outerPad, 10, outerPad, 12 + bottomInset),
        child: SizedBox(
          height: topSpace + barH,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // ===== BAR + TOP STROKE (grouped + animated together) =====
              Positioned(
                    top: topSpace,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: barH,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // BAR
                          PhysicalShape(
                            color: barBg,
                            elevation: 18,
                            shadowColor: shadowColor,
                            clipper: _NotchedBarClipper(
                              notchRadius: notchRadius,
                              notchDepth: notchDepth,
                              cornerRadius: radius,
                            ),
                            child: Container(
                              height: barH,
                              color: barBg,
                              child: Stack(
                                children: [
                                  _ActiveIndicator(
                                    index: widget.currentIndex,
                                    color: active,
                                    centerGap: centerGap,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _NavItem(
                                          active: widget.currentIndex == 0,
                                          icon: widget.items[0].icon,
                                          label: widget.items[0].label,
                                          activeColor: active,
                                          inactiveIcon: inactiveIcon,
                                          inactiveLabel: inactiveLabel,
                                          onTap: () => _tap(0),
                                        ),
                                      ),

                                      // ✅ เมนูซ้ายที่ติดกลาง: เพิ่ม padding ขวา
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: nearCenterPad,
                                          ),
                                          child: _NavItem(
                                            active: widget.currentIndex == 1,
                                            icon: widget.items[1].icon,
                                            label: widget.items[1].label,
                                            activeColor: active,
                                            inactiveIcon: inactiveIcon,
                                            inactiveLabel: inactiveLabel,
                                            onTap: () => _tap(1),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: centerGap),

                                      // ✅ เมนูขวาที่ติดกลาง: เพิ่ม padding ซ้าย
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: nearCenterPad,
                                          ),
                                          child: _NavItem(
                                            active: widget.currentIndex == 2,
                                            icon: widget.items[2].icon,
                                            label: widget.items[2].label,
                                            activeColor: active,
                                            inactiveIcon: inactiveIcon,
                                            inactiveLabel: inactiveLabel,
                                            onTap: () => _tap(2),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: _NavItem(
                                          active: widget.currentIndex == 3,
                                          icon: widget.items[3].icon,
                                          label: widget.items[3].label,
                                          activeColor: active,
                                          inactiveIcon: inactiveIcon,
                                          inactiveLabel: inactiveLabel,
                                          onTap: () => _tap(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ✅ TOP STROKE FULL SCREEN (moves together with bar now)
                          Positioned(
                            top: 0,
                            left: -outerPad,
                            right: -outerPad,
                            child: IgnorePointer(
                              child: SizedBox(
                                height: barH,
                                child: CustomPaint(
                                  painter: _NotchedTopStrokePainter(
                                    notchRadius: notchRadius,
                                    notchDepth: notchDepth,
                                    cornerRadius: radius,
                                    color: topStroke,
                                    strokeWidth: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 220.ms)
                  .slideY(
                    begin: .25,
                    end: 0,
                    duration: 220.ms,
                    curve: Curves.easeOut,
                  ),

              // ===== PLUS BUTTON =====
              Align(
                    alignment: Alignment.topCenter,
                    child: _PlusButton(
                      key: ValueKey("plus-$_plusPulse"),
                      diameter: fabD,
                      icon: widget.plusIcon,
                      enabled: widget.onPlusPressed != null,
                      onTap: () {
                        if (widget.onPlusPressed == null) return;
                        HapticFeedback.lightImpact();
                        setState(() => _plusPulse++);
                        widget.onPlusPressed!.call();
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 240.ms)
                  .scale(
                    begin: const Offset(.90, .90),
                    end: const Offset(1, 1),
                    duration: 280.ms,
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _tap(int i) {
    if (i == widget.currentIndex) return;
    HapticFeedback.selectionClick();
    widget.onChanged(i);
  }
}

// =====================
// item (FontAwesome render)
// =====================
class _NavItem extends StatefulWidget {
  final bool active;
  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveIcon;
  final Color inactiveLabel;
  final VoidCallback onTap;

  const _NavItem({
    required this.active,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveIcon,
    required this.inactiveLabel,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final iconC = widget.active ? widget.activeColor : widget.inactiveIcon;
    final labelC = widget.active ? widget.activeColor : widget.inactiveLabel;

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: 120.ms,
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: Center(
            child: Padding(
              // ✅ จัดให้ดูโปร่งขึ้นนิด
              padding: const EdgeInsets.only(top: 15, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(widget.icon, size: 26, color: iconC)
                      .animate(target: widget.active ? 1 : 0)
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.10, 1.10),
                        duration: 180.ms,
                        curve: Curves.easeOutBack,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.10, 1.10),
                        end: const Offset(1, 1),
                        duration: 140.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 6),
                  Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: widget.active
                              ? FontWeight.w900
                              : FontWeight.w800,
                          fontSize: 12,
                          height: 1.0,
                          color: labelC,
                        ),
                      )
                      .animate(target: widget.active ? 1 : 0)
                      .fadeIn(duration: 140.ms)
                      .slideY(begin: .12, end: 0, duration: 180.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// ✅ FIX: indicator ไม่ “วิง” ตอนเข้า Home ครั้งแรก
// =====================
class _ActiveIndicator extends StatefulWidget {
  final int index;
  final Color color;
  final double centerGap;

  const _ActiveIndicator({
    required this.index,
    required this.color,
    required this.centerGap,
  });

  @override
  State<_ActiveIndicator> createState() => _ActiveIndicatorState();
}

class _ActiveIndicatorState extends State<_ActiveIndicator> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        // 4 slots + gap กลาง
        final slotW = (w - widget.centerGap) / 4.0;

        // center ของแต่ละเมนู
        final centers = <double>[
          slotW * 0.5,
          slotW * 1.5,
          widget.centerGap + slotW * 2.5,
          widget.centerGap + slotW * 3.5,
        ];

        const indW = 20.0;
        const indH = 4.0;

        final left = (centers[widget.index] - indW / 2).clamp(0.0, w - indW);

        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedPositioned(
                duration: _ready ? 320.ms : Duration.zero,
                curve: Curves.easeOutCubic,
                left: left,
                bottom: 12,
                child: Container(
                  width: indW,
                  height: indH,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                        color: widget.color.withOpacity(.22),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================
// ✅ Outlined FontAwesome icon (fake stroke)
// =====================
class _OutlinedFaIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const _OutlinedFaIcon({
    required this.icon,
    required this.size,
    required this.fillColor,
    required this.strokeColor,
    this.strokeWidth = 1.8,
  });

  @override
  Widget build(BuildContext context) {
    // วาดไอคอน 4 ทิศ + กลาง เพื่อให้ดูเป็น stroke/outline
    final o = strokeWidth;
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(-o, 0),
          child: FaIcon(icon, color: strokeColor, size: size),
        ),
        Transform.translate(
          offset: Offset(o, 0),
          child: FaIcon(icon, color: strokeColor, size: size),
        ),
        Transform.translate(
          offset: Offset(0, -o),
          child: FaIcon(icon, color: strokeColor, size: size),
        ),
        Transform.translate(
          offset: Offset(0, o),
          child: FaIcon(icon, color: strokeColor, size: size),
        ),
        FaIcon(icon, color: fillColor, size: size),
      ],
    );
  }
}

// =====================
// plus button (FontAwesome render)
// ✅ gradient darkblue premium + BIGGER QR icon
// =====================
class _PlusButton extends StatelessWidget {
  final double diameter;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PlusButton({
    super.key,
    required this.diameter,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const premiumGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0B2A66), Color(0xFF0A3E9A), Color(0xFF0A57D6)],
      stops: [0.0, 0.55, 1.0],
    );

    // ✅ BIGGER THAN BEFORE
    // เดิม ~34px → ตอนนี้ดันขึ้นไป ~40px (สำหรับ diameter=66)
    final qrSize = (diameter * 0.60).clamp(38.0, 44.0); // ≈ 39.6 -> 40

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: enabled ? onTap : null,
        radius: diameter / 2,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: enabled
                ? premiumGradient
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0B2A66).withOpacity(.45),
                      const Color(0xFF0A57D6).withOpacity(.35),
                    ],
                  ),
            border: Border.all(
              color: Colors.white.withOpacity(enabled ? .18 : .10),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 22,
                offset: const Offset(0, 14),
                color: Colors.black.withOpacity(.26),
              ),
            ],
          ),
          child: Center(
            child: _OutlinedFaIcon(
              icon: icon,
              size: qrSize, // ✅ bigger
              fillColor: Colors.white,
              strokeColor: Colors.white.withOpacity(.32),
              strokeWidth: 1.15, // ✅ ลดนิดเพื่อไม่ให้ “กินพื้นที่” ตอนขยาย
            ),
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(.92, .92),
      end: const Offset(1, 1),
      duration: 220.ms,
      curve: Curves.easeOutBack,
    );
  }
}

// =====================
// clipper: rounded bar + center notch
// =====================
class _NotchedBarClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchDepth;
  final double cornerRadius;

  const _NotchedBarClipper({
    required this.notchRadius,
    required this.notchDepth,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final c = w / 2;
    final r = notchRadius;
    final d = notchDepth;
    final cr = cornerRadius;

    final s = (r * 0.60).clamp(16.0, 28.0);

    final p = Path()
      ..moveTo(cr, 0)
      ..lineTo(c - r - s, 0)
      ..cubicTo(c - r + 6, 0, c - r + 2, d, c, d)
      ..cubicTo(c + r - 2, d, c + r - 6, 0, c + r + s, 0)
      ..lineTo(w - cr, 0)
      ..quadraticBezierTo(w, 0, w, cr)
      ..lineTo(w, h - cr)
      ..quadraticBezierTo(w, h, w - cr, h)
      ..lineTo(cr, h)
      ..quadraticBezierTo(0, h, 0, h - cr)
      ..lineTo(0, cr)
      ..quadraticBezierTo(0, 0, cr, 0)
      ..close();

    return p;
  }

  @override
  bool shouldReclip(covariant _NotchedBarClipper oldClipper) {
    return notchRadius != oldClipper.notchRadius ||
        notchDepth != oldClipper.notchDepth ||
        cornerRadius != oldClipper.cornerRadius;
  }
}

// =====================
// TOP stroke only (full top + notch)
// =====================
class _NotchedTopStrokePainter extends CustomPainter {
  final double notchRadius;
  final double notchDepth;
  final double cornerRadius; // keep
  final Color color;
  final double strokeWidth;

  _NotchedTopStrokePainter({
    required this.notchRadius,
    required this.notchDepth,
    required this.cornerRadius,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sw = strokeWidth;
    final y = sw / 2;

    final w = size.width;
    final c = w / 2;

    final r = notchRadius;
    final d = notchDepth;
    final s = (r * 0.60).clamp(16.0, 28.0);

    final path = Path()
      ..moveTo(0, y)
      ..lineTo(c - r - s, y)
      ..cubicTo(c - r + 6, y, c - r + 2, y + d, c, y + d)
      ..cubicTo(c + r - 2, y + d, c + r - 6, y, c + r + s, y)
      ..lineTo(w, y);

    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _NotchedTopStrokePainter oldDelegate) {
    return notchRadius != oldDelegate.notchRadius ||
        notchDepth != oldDelegate.notchDepth ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
