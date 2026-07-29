import 'package:flutter/material.dart';

abstract final class TesouTheme {
  static const _red = Color(0xFFD64045);
  static const _ink = Color(0xFF29252A);
  static const _background = Color(0xFFFFF9F2);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _red,
      brightness: Brightness.light,
      surface: _background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: _ink,
          fontWeight: FontWeight.w800,
          height: 1.08,
        ),
        titleMedium: TextStyle(color: _ink, height: 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(148, 52),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
