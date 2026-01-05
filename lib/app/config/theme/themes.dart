import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_colors.dart';
import 'package:wingle/app/config/theme/color/dark_color_scheme.dart';
import 'package:wingle/app/config/theme/color/light_color_scheme.dart';
import 'package:wingle/app/config/theme/constants/color.dart';

/// 어플리케이션 테마 정의
class Themes {
  /// 라이트 테마
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: const [AppColors(LightColorScheme())],
    fontFamily: "Pretendard",
  );

  /// 다크 테마
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: const [AppColors(DarkColorScheme())],
    fontFamily: "Pretendard",
  );
}

/// 다크모드 텍스트 테마 정의
TextTheme darkTextTheme = TextTheme(
  displayLarge: TextStyle(color: AppColor.darkButtonText),
  displayMedium: TextStyle(color: AppColor.darkButtonText),
  displaySmall: TextStyle(color: AppColor.darkButtonText),
  headlineLarge: TextStyle(color: AppColor.darkButtonText),
  headlineMedium: TextStyle(color: AppColor.darkButtonText),
  headlineSmall: TextStyle(color: AppColor.darkButtonText),
  titleLarge: TextStyle(color: AppColor.darkButtonText),
  titleMedium: TextStyle(color: AppColor.darkButtonText),
  titleSmall: TextStyle(color: AppColor.darkButtonText),
  bodyLarge: TextStyle(color: AppColor.darkButtonText),
  bodyMedium: TextStyle(color: AppColor.darkButtonText),
  // labelLarge: TextStyle(color: AppColor.darkButtonText),
  labelMedium: TextStyle(fontSize: 12, color: AppColor.darkButtonText),
  // labelSmall: TextStyle(color: AppColor.darkButtonText),
);

/// 라이트모드 텍스트 테마 정의
TextTheme lightTextTheme = TextTheme(
  displayLarge: TextStyle(color: AppColor.darkButtonText),
  displayMedium: TextStyle(color: AppColor.darkButtonText),
  displaySmall: TextStyle(color: AppColor.darkButtonText),
  headlineLarge: TextStyle(color: AppColor.darkButtonText),
  headlineMedium: TextStyle(color: AppColor.darkButtonText),
  headlineSmall: TextStyle(color: AppColor.darkButtonText),
  titleLarge: TextStyle(color: AppColor.darkButtonText),
  titleMedium: TextStyle(color: AppColor.darkButtonText),
  titleSmall: TextStyle(color: AppColor.darkButtonText),
  bodyLarge: TextStyle(color: AppColor.darkButtonText),
  bodyMedium: TextStyle(color: AppColor.darkButtonText),
  bodySmall: TextStyle(color: AppColor.darkButtonText),
  labelLarge: TextStyle(color: AppColor.darkButtonText),
  labelMedium: TextStyle(color: AppColor.darkButtonText),
  labelSmall: TextStyle(color: AppColor.darkButtonText),
);
