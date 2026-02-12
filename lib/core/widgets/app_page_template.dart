import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppPageTemplate extends StatelessWidget {
  final String title;

  /// content ข้างใน "กล่องใหญ่"
  final Widget child;

  /// background asset (รูปดิบ 100% ไม่มี overlay)
  final String backgroundAsset;

  /// กด back (ถ้าไม่ส่งมา จะใช้ Navigator.maybePop)
  final VoidCallback? onBack;

  /// ปรับให้ scroll ได้/ไม่ได้
  final bool scrollable;

  /// padding ภายในกล่องใหญ่
  final EdgeInsets contentPadding;

  /// animate เปิด/ปิด
  final bool animate;

  /// ใช้ปุ่ม back หรือไม่
  final bool showBack;

  /// ✅ NEW: ใช้ premium dark gradient ในโหมด dark
  final bool premiumDark;

  /// ✅ NEW: override gradient ได้ (ถ้าไม่ส่งมา จะใช้ค่า default)
  final Gradient? premiumDarkGradient;

  const AppPageTemplate({
    super.key,
    required this.title,
    required this.child,
    required this.backgroundAsset,
    this.onBack,
    this.scrollable = true,
    this.contentPadding = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.animate = true,
    this.showBack = true,
    this.premiumDark = true,
    this.premiumDarkGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ===== Background (image only) =====
    Widget bg = Positioned.fill(
      child: Image.asset(
        backgroundAsset,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high,
      ),
    );

    if (animate) {
      bg = bg
          .animate()
          .fadeIn(duration: 420.ms)
          .scale(
            begin: const Offset(1.02, 1.02),
            end: const Offset(1, 1),
            duration: 650.ms,
            curve: Curves.easeOutCubic,
          );
    }

    // ===== TopBar =====
    Widget topBar = AppTemplateTopBar(
      title: title,
      showBack: showBack,
      onBack: onBack ?? () => Navigator.maybePop(context),
    );

    if (animate) {
      topBar = topBar
          .animate()
          .fadeIn(duration: 260.ms)
          .slideY(
            begin: -0.25,
            end: 0,
            duration: 520.ms,
            curve: Curves.easeOutCubic,
          );
    }

    // ===== Big Container Decoration (Light = White, Dark = Premium Gradient) =====
    final Gradient darkGrad =
        premiumDarkGradient ??
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B2B5B), Color(0xFF071A33), Color(0xFF060B16)],
        );

    final BoxDecoration bigDeco = (isDark && premiumDark)
        ? BoxDecoration(
            gradient: darkGrad,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(.10)),
            boxShadow: [
              BoxShadow(
                blurRadius: 34,
                offset: const Offset(0, 18),
                color: Colors.black.withOpacity(.45),
              ),
            ],
          )
        : BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                offset: const Offset(0, 18),
                color: Colors.black.withOpacity(.10),
              ),
            ],
          );

    // ===== White/Dark Big Container =====
    Widget bigContainer = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        decoration: bigDeco,
        child: scrollable
            ? SingleChildScrollView(padding: contentPadding, child: child)
            : Padding(padding: contentPadding, child: child),
      ),
    );

    if (animate) {
      bigContainer = bigContainer
          .animate()
          .fadeIn(duration: 320.ms, delay: 120.ms)
          .slideY(
            begin: 0.10,
            end: 0,
            duration: 650.ms,
            curve: Curves.easeOutCubic,
          );
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF070B12)
          : const Color(0xFFF4F6FF),
      body: Stack(
        children: [
          bg,
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 6),

                // Top bar spacing + padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: topBar,
                ),

                const SizedBox(height: 14),

                // Big container
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: bigContainer,
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppTemplateTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final bool showBack;

  const AppTemplateTopBar({
    super.key,
    required this.title,
    required this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          if (showBack)
            InkResponse(
              onTap: onBack,
              radius: 26,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(.12)),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
