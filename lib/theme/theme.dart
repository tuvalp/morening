import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.white60,
      tertiary: Color.fromARGB(70, 130, 169, 193),
      inversePrimary: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF87CEFA),
  );
}
