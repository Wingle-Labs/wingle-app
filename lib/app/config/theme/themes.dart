import 'package:flutter/material.dart';

/// 어플리케이션 테마 정의
class Themes {
  /// 라이트 테마
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Color(0xFFBF00FF),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  );

  /// 다크 테마
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Color(0xFFBF00FF),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
  );
}
