// core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  /// ✅ Premium Dark Blue (shared)
  /// ใช้เป็นสีพื้นหลัง/การ์ด/gradient ในโหมด Dark ให้ดู “premium”
  static const Color darkBluePremium = Color(0xFF0B1220);

  /// ✅ Premium Dark Gradient (shared)
  static const Color _premiumA = Color(0xFF071A3A);
  static const Color _premiumB = Color(0xFF0B2A6F);
  static const Color _premiumC = Color(0xFF1246A8);

  static const LinearGradient premiumDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_premiumA, _premiumB, _premiumC],
  );

  /// ✅ Global ThemeMode (shared across pages)
  /// - เปลี่ยนได้จากหน้า YearPickerPage เท่านั้น (ตามที่คุณต้องการ)
  /// - หน้าอื่น ๆ แค่อ่านค่าเดียวกัน => theme จะ “เชื่อมกัน” ทั้งแอป
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static ThemeMode get themeMode => mode.value;
  static bool get isDarkMode => mode.value == ThemeMode.dark;

  static void setThemeMode(ThemeMode newMode) => mode.value = newMode;

  static void toggleThemeMode() {
    mode.value = (mode.value == ThemeMode.dark)
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static const double _radiusLg = 20;
  static const double _radiusMd = 16;

  static RoundedRectangleBorder _r(double r) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));

  /// ✅ เลือกฟอนต์ตามภาษา (lo = Noto Sans Lao, อื่นๆ = Inter)
  static TextTheme _fontTextTheme(Locale locale) {
    if (locale.languageCode == 'lo') {
      return GoogleFonts.notoSansLaoTextTheme();
    }
    return GoogleFonts.interTextTheme();
  }

  /// ✅ เพิ่มความ “หนา” + premium spacing ให้ TextTheme
  static TextTheme _makeBold(TextTheme t) {
    return t.copyWith(
      headlineLarge: t.headlineLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.6,
      ),
      headlineMedium: t.headlineMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.4,
      ),
      headlineSmall: t.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
      ),
      titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      titleSmall: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
      bodyLarge: t.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodyMedium: t.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodySmall: t.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      labelLarge: t.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
      labelMedium: t.labelMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
      labelSmall: t.labelSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  /// ✅ ฟอนต์หลัก (กัน widget บางตัวไปใช้ fontFamily)
  static String? _fontFamily(Locale locale) {
    if (locale.languageCode == 'lo') {
      return GoogleFonts.notoSansLao().fontFamily;
    }
    return GoogleFonts.inter().fontFamily;
  }

  // =========================
  // ✅ Light Theme (by locale)
  // =========================
  static ThemeData lightTheme(Locale locale) {
    final textTheme = _makeBold(_fontTextTheme(locale));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily(locale),

      // ✅ คุม “พื้นหลังแอป” ด้วย scaffoldBackgroundColor (แทน ColorScheme)
      scaffoldBackgroundColor: AppColors.grayUltraLight,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue500,
        brightness: Brightness.light,
        primary: AppColors.blue500,
        secondary: AppColors.blue200,
        surface: Colors.white,
      ),

      textTheme: textTheme,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: _r(_radiusLg),
        clipBehavior: Clip.antiAlias,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: AppColors.slate.withOpacity(.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: AppColors.slate.withOpacity(.14)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: AppColors.blue400.withOpacity(.65)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: _r(_radiusMd),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  // =========================
  // ✅ Dark Theme (by locale)
  // =========================
  static ThemeData darkTheme(Locale locale) {
    final textTheme = _makeBold(_fontTextTheme(locale));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily(locale),

      scaffoldBackgroundColor: darkBluePremium,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue500,
        brightness: Brightness.dark,
        primary: AppColors.blue200,
        secondary: AppColors.blue300,
        surface: darkBluePremium,
      ),

      textTheme: textTheme,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: _r(_radiusLg),
        clipBehavior: Clip.antiAlias,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: Colors.white.withOpacity(.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusMd),
          borderSide: BorderSide(color: Colors.white.withOpacity(.36)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: _r(_radiusMd),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
