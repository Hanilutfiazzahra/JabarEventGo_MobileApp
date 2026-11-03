import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/splash_page.dart';

void main() {
  // Catatan tim: kalau fitur state management (Provider) dipegang anggota lain,
  // bungkus MaterialApp dengan MultiProvider di sini.
  runApp(
    MaterialApp(
      title: 'Jabar EventGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashPage(), // halaman pertama
    ),
  );
}
