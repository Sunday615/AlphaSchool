import 'package:alpha_school/features/home/presentation/pages/home_shell_page.dart';
import 'package:alpha_school/features/home/presentation/pages/tabs/explore_page.dart';
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
  ThemeMode _mode = ThemeMode.light;
  Locale _locale = const Locale('en');

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme(_locale),
      darkTheme: AppTheme.darkTheme(_locale),
      themeMode: _mode,

      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('lo'), Locale('th')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ ADD: routes
      routes: {'/homeShell': (_) => const HomeShellPage()},

      home: YearPickerPage(
        onToggleTheme: _toggleTheme,
        themeMode: _mode,
        // onSetLocale: _setLocale, // ถ้าคุณมีปุ่มเลือกภาษาใน YearPicker
      ),
    );
  }
}
