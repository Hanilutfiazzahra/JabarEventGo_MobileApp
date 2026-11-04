import 'package:flutter/material.dart';

/// Tema aplikasi: warna dasar biru navy dari logo, dan kotak garis di sekitar isian form.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF083A6D)),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
