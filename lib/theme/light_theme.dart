import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF00ADB5),
      secondary: Color(0xFF72D2D6),
      onPrimary: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF212121),
      onSecondary: Color(0xFF000000),
      onTertiary: Color(0xFF757575),
      error: Color(0xFFc1121f),
      onError: Color(0xFFFFFFFF),
    ),
  );
}
