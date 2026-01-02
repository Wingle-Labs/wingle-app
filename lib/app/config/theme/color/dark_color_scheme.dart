import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';

/// Dark Mode에서 사용되는 컬러 스키마.
///
/// 디자이너가 제공한 다크 모드 컬러 스키마를 1:1로 정의하는 인터페이스.
class DarkColorScheme implements AppColorScheme {
  /// 싱글톤 인스턴스
  const DarkColorScheme();

  @override
  Color get background => Color(0xFF070707);

  @override
  Color get primary => Color(0xFF765642);

  @override
  Color get onPrimary => Color(0xFFF5F1EE);

  @override
  Color get textPrimary => Color(0xFFEDEDED);

  @override
  Color get textSecondary => Color(0xFFCFCFCF);

  @override
  Color get textTertiary => Color(0xFFB5B5B5);

  @override
  Color get textDisabled => Color(0xFF8F8F8F);

  @override
  Color get textInactive => Color(0xFF8F8F8F);

  @override
  Color get textDisabledStrong => Color(0xFF6A6A6A);

  @override
  Color get textBackground30 => Color(0xFF1A1A1A);

  @override
  Color get textBackground10 => Color(0xFF121212);

  @override
  Color get surface => Color(0xFF121212);

  @override
  Color get surfaceVariant => Color(0xFF1A1A1A);

  @override
  Color get surfaceElevated => Color(0xFF1E1E1E);

  @override
  Color get scrimBorder =>
      Color.from(alpha: 0.10, red: 255, green: 255, blue: 255);

  @override
  Color get overlayPressed =>
      Color.from(alpha: 0.08, red: 255, green: 255, blue: 255);

  @override
  Color get overlayDisabled =>
      Color.from(alpha: 0.08, red: 255, green: 255, blue: 255);

  @override
  Color get overlayLoading =>
      Color.from(alpha: 0.12, red: 255, green: 255, blue: 255);

  @override
  Color get border => Color(0xFF242424);

  @override
  Color get divider => Color(0xFF1F1F1F);

  @override
  Color get error => Color(0xFFE06B6B);

  @override
  Color get onError => Color(0xFF1A1A1A);

  @override
  Color get success => Color(0xFF4FAF88);

  @override
  Color get onSuccess => Color(0xFF0F1F18);

  @override
  Color get warning => Color(0xFFF0B75A);

  @override
  Color get onWarning => Color(0xFFECECEC);

  @override
  Color get info => Color(0xFF6FA3E8);

  @override
  Color get onInfo => Color(0xFF0B1624);

  @override
  Color get stateDefault => Color(0xFF765642);

  @override
  Color get statePressed => Color(0xFF654937);

  @override
  Color get stateDisabled => Color(0xFF3F342D);

  @override
  Color get scalePrimary90 => Color(0xFF8A6A55);

  @override
  Color get scalePrimary70 => Color(0xFF765642);

  @override
  Color get scalePrimary50 => Color(0xFF654937);

  @override
  Color get scalePrimary30 => Color(0xFF53412B);

  @override
  Color get scalePrimary10 => Color(0xFF3F3021);
}
