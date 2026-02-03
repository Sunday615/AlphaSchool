import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/year_picker_page.dart';

void main() {
  runApp(const CConnectApp());
}

class CConnectApp extends StatefulWidget {
  const CConnectApp({super.key});

  @override
  State<CConnectApp> createState() => _CConnectAppState();
}

class _CConnectAppState extends State<CConnectApp> {
  // ✅ default เป็น Light mode
  ThemeMode _mode = ThemeMode.light;

  // ✅ default locale
  Locale _locale = const Locale('en');

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  // (ถ้ายังไม่ได้ทำปุ่มสลับภาษาไว้ ใช้อันนี้ได้)
  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ theme ตามภาษา (en=Inter, lo=NotoSansLao)
      theme: AppTheme.lightTheme(_locale),
      darkTheme: AppTheme.darkTheme(_locale),
      themeMode: _mode,

      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('lo'),
        Locale('th'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: YearPickerPage(
        onToggleTheme: _toggleTheme,
        themeMode: _mode,

        // ✅ optional: ถ้าหน้า YearPicker มีปุ่มเลือกภาษา ให้เรียกอันนี้
        // ถ้า YearPicker ของคุณยังไม่มี ก็ลบบรรทัดนี้ได้
      ),
    );
  }
}
