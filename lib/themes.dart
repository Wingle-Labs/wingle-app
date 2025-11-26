import 'package:flutter/material.dart';

/// Light theme
class Themes {
  /// Light theme
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Color(0xFFBF00FF),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  );

  /// Dark theme
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Color(0xFFBF00FF),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
  );
}
