import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';

/// Dark Mode에서 사용되는 컬러 스키마.
///
/// 디자이너가 제공한 다크 모드 컬러 스키마를 1:1로 정의하는 인터페이스.
class DarkColorScheme implements AppColorScheme {
  /// 싱글톤 인스턴스
  const DarkColorScheme();

  // ! Primary Color: 주요 컬러
  @override
  Color get primary => Color(0xFF765642);

  @override
  Color get onPrimary => Color(0xFFF5F1EE);

  // ! 텍스트 관련 컬러: 계층과 용도에 따른 구분
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

  // ! Surface 관련 컬러: 컨테이너 및 레이어별 배경 색상
  @override
  Color get background => Color(0xFF070707);

  @override
  Color get surface => Color(0xFF121212);

  @override
  Color get surfaceVariant => Color(0xFF1A1A1A);

  @override
  Color get surfaceElevated => Color(0xFF1E1E1E);

  @override
  Color get surfaceDisabled => Color(0xFF1A1A1A);

  @override
  Color get surfaceDisableSubtle => Color(0xFF121212);

  // ! Feedback 컬러
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
  Color get onWarning => Color(0xFF2A1B00);

  @override
  Color get info => Color(0xFF6FA3E8);

  @override
  Color get onInfo => Color(0xFF6FA3E8);

  @override
  Color get cancel => Color(0xFF9E9E9E);

  @override
  Color get onCancel => Color(0xFF070707);

  // ! 인터랙션 피드백 및 상태 표현용 오버레이 및 경계 색상
  @override
  Color get border => Color(0xFF242424);

  @override
  Color get divider => Color(0xFF1F1F1F);
  @override
  Color get scrim => Color.from(alpha: 0.10, red: 255, green: 255, blue: 255);

  @override
  Color get overlayPressed =>
      Color.from(alpha: 0.08, red: 255, green: 255, blue: 255);

  @override
  Color get overlayDisabled =>
      Color.from(alpha: 0.08, red: 255, green: 255, blue: 255);

  @override
  Color get overlayLoading =>
      Color.from(alpha: 0.12, red: 255, green: 255, blue: 255);

  // ! 상태 존재 버튼의 상태 표현 컬러
  // ! Chip, Radio, Checkbox, ListButton 등
  @override
  Color get stateBtnSelected => Color(0xFF765642);

  @override
  Color get stateBtnUnselected => Color(0xFF242424);

  @override
  Color get stateBtnDisabled => Color(0xFF3F342D);

  // ! 단순 버튼의 상태 표현 컬러
  // ! Filled, Outlined, Text 버튼
  @override
  Color get btnDefault => Color(0xFF765642);

  @override
  Color get btnDisabled => Color(0xFF3F342D);

  // ! 프로필 카드 속 입력사항 Badge 표현 컬러
  @override
  Color get profileStatusBadgeDefault => Color(0xFF765642);

  @override
  Color get profileStatusBadgeDisabled => Color(0xFF3F342D);

  // ! 디자인에서 제공하는 톤 스케일: Primary 색상 계열의 다양한 명도 단계
  @override
  Color get primaryScale90 => Color(0xFF8A6A55);

  @override
  Color get primaryScale70 => Color(0xFF765642);

  @override
  Color get primaryScale50 => Color(0xFF654937);

  @override
  Color get primaryScale30 => Color(0xFF53412B);

  @override
  Color get primaryScale10 => Color(0xFF3F3021);
}
