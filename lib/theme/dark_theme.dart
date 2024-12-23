import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.light,
    fontFamily: 'OpenSans',
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3EB489),
      secondary: Color(0xFF76C7C0),
      onPrimary: Color(0xFFFFFFFF),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onTertiary: Color(0xFFBDBDBD),
      error: Color(0xFFc1121f),
      onError: Color(0xFFFFFFFF),
    ),
  );
}
