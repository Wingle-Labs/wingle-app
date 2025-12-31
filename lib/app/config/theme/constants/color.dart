import 'package:flutter/material.dart';

/// 디자인 시스템의 색상 스킴을 정의하는 인터페이스
abstract interface class AppColorScheme {
  /// 주요 색상 (Primary color)
  Color get primary;

  /// 주요 색상에 대한 텍스트 색상 (On-primary color)
  Color get onPrimary;

  /// 주요 텍스트 색상 (Primary text color)
  Color get primaryText;

  /// 보조 텍스트 색상 (Secondary text color)
  Color get secondaryText;

  /// 제3 텍스트 색상 (Tertiary text color)
  Color get tertiaryText;

  /// 비활성화 및 입력 불가 텍스트 색상
  Color get disabledText;

  /// 비활성화 배경 색상
  Color get disabledBackground;

  /// 강한 비활성화 텍스트 색상
  Color get strongDisabledText;

  /// 강한 비활성화 배경 색상
  Color get strongDisabledBackground;

  /// 배경 색상
  Color get background;

  /// 표면 색상 (Surface color)
  Color get surface;

  /// 표면 변형 색상 (Surface variant color)
  Color get surfaceVariant;

  /// Surface Elevated 색상
  Color get surfaceElevated;

  /// 테두리 색상 (Border or Outline color)
  Color get border;

  /// 구분선 색상 (Divider color)
  Color get divider;

  /// State Default 색상
  Color get stateDefault;

  /// State Pressed 색상
  Color get statePressed;

  /// State Disabled 색상
  Color get stateDisabled;

  /// Pimary Scale 90
  Color get primaryScale90;

  /// Pimary Scale 70
  Color get primaryScale70;

  /// Pimary Scale 50
  Color get primaryScale50;

  /// Pimary Scale 30
  Color get primaryScale30;

  /// Pimary Scale 10
  Color get primaryScale10;
}

/// 어플리케이션의 공통 색상 정의
class AppColor {
  /// Light Mode 주요 색상
  static const Color lightPrimary = Color(0xFF744C33);

  /// Dark Mode 주요 색상
  static const Color darkPrimary = Color.fromRGBO(115, 100, 90, 1.0);

  /// 어두운 버튼 텍스트 색상
  static const Color darkButtonText = Colors.white;

  /// 밝은 버튼 텍스트 색상
  static Color lightButtonText = Colors.black;

  /// 어두운 배경
  static Color darkBackground = Colors.black;

  /// 밝은 배경
  static Color lightBackground = Colors.white;

  /// 밝은 비활성화 색상
  static Color disabledLight = Colors.grey.withValues(alpha: 0.6);

  /// 어두운 비활성화 색상
  static Color disabledDark = Colors.grey.withValues(alpha: 0.2);

  /// 밝은 캡션 색상
  static Color lightCaption = Colors.grey.withValues(alpha: 0.8);

  /// 어두운 캡션 색상
  static Color darkCaption = Colors.grey.withValues(alpha: 0.6);

  /// 밝은 카드 색상
  static Color lightCard = Colors.grey.withValues(alpha: 0.05);

  /// 밝은 카드 테두리 색상
  static Color lightCardBorder = Colors.grey.withValues(alpha: 0.1);

  /// 어두운 카드 색상
  static Color darkCard = Colors.grey.withValues(alpha: 0.06);

  /// 어두운 카드 테두리 색상
  static Color darkCardBorder = Colors.grey.withValues(alpha: 0.1);

  /// 밝은 그림자 색상
  static Color lightShadow = Colors.grey.withValues(alpha: 1);

  /// 어두운 그림자 색상
  static Color darkShadow = Colors.white.withValues(alpha: 1);
}
