import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: Color(0XFF5DB075),
      secondary: Color(0XFF4B9460),

      // Black
      onSurface: Color(0XFF000000),

      // White
      onPrimary: Color(0XFFFFFFFF),

      // Grey 1
      onSurfaceVariant: Color(0XFFF6F6F6),

      // Grey 2
      onSecondary: Color(0XFFE8E8E8),

      // Grey 3
      tertiary: Color(0XFFBDBDBD),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  );
}
