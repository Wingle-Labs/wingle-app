import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/color.dart';

/// 어플리케이션 테마 정의
class Themes {
  /// 라이트 테마
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(bodyLarge: TextStyle(color: AppColor.lightButtonText)),
  );

  /// 다크 테마
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColor.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(bodyLarge: TextStyle(color: AppColor.darkButtonText)),
  );
}
