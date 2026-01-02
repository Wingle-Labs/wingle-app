import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';

/// Light Mode에서 사용되는 컬러 스키마.
///
/// 디자이너가 제공한 라이트 모드 컬러 스키마를 1:1로 정의하는 인터페이스.
class LightColorScheme implements AppColorScheme {
  /// 싱글톤 인스턴스
  const LightColorScheme();

  @override
  Color get background => Color(0xFFFAFAFA);

  @override
  Color get primary => Color(0xFF5E402D);

  @override
  Color get onPrimary => Color(0xFFFFFFFF);

  @override
  Color get textPrimary => Color(0xFF1C1C1C);

  @override
  Color get textSecondary => Color(0xFF3A3A3A);

  @override
  Color get textTertiary => Color(0xFF4A4A4A);

  @override
  Color get textDisabled => Color(0xFF7A7A7A);

  @override
  Color get textInactive => Color(0xFF7A7A7A);

  @override
  Color get textDisabledStrong => Color(0xFF9E9E9E);

  @override
  Color get textBackground30 => Color(0xFFF2F2F2);

  @override
  Color get textBackground10 => Color(0xFFE2E2E2);

  @override
  Color get surface => Color(0xFFFFFFFF);

  @override
  Color get surfaceVariant => Color(0xFFF2F2F2);

  // TODO: FFFFFF Shadow가 무엇을 의미하는 지 디자이너의 확인 필요
  @override
  Color get surfaceElevated => Color(0xFFFFFFFF);

  @override
  Color get scrimBorder => Color.from(alpha: 0.45, red: 0, green: 0, blue: 0);

  @override
  Color get overlayPressed =>
      Color.from(alpha: 0.12, red: 0, green: 0, blue: 0);

  @override
  Color get overlayDisabled =>
      Color.from(alpha: 0.12, red: 0, green: 0, blue: 0);

  @override
  Color get overlayLoading => Color.from(alpha: 0.2, red: 0, green: 0, blue: 0);

  @override
  Color get border => Color(0xFFE2E2E2);

  @override
  Color get divider => Color(0xFFECECEC);

  @override
  Color get error => Color(0xFFD64545);

  @override
  Color get onError => Color(0xFFFFFFFF);

  @override
  Color get success => Color(0xFF2E7D5A);

  @override
  Color get onSuccess => Color(0xFFFFFFFF);

  @override
  Color get warning => Color(0xFFE6A23C);

  @override
  Color get onWarning => Color(0xFF1C1C1C);

  @override
  Color get info => Color(0xFF3A7BD5);

  @override
  Color get onInfo => Color(0xFFFFFFFF);

  @override
  Color get stateDefault => Color(0xFF5E402D);

  @override
  Color get statePressed => Color(0xFFC8BDB6);

  // TODO: 정확한 색상인지 확인 필요
  @override
  Color get stateDisabled => Color(0xFFC8BDB6);

  @override
  Color get scalePrimary90 => Color(0xFFF1EAE4);

  @override
  Color get scalePrimary70 => Color(0xFFC8B6AB);

  @override
  Color get scalePrimary50 => Color(0xFF5E402D);

  @override
  Color get scalePrimary30 => Color(0xFF4F3525);

  @override
  Color get scalePrimary10 => Color(0xFF37291E);
}
