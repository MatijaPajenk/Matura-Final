import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade700,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white70,
      secondary: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xfffec47f),
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.black54,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepOrange,
    ),
  );
}
