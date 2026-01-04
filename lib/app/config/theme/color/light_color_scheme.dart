import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/app_color_scheme.dart';

/// Light Mode에서 사용되는 컬러 스키마.
///
/// 디자이너가 제공한 라이트 모드 컬러 스키마를 1:1로 정의하는 인터페이스.
class LightColorScheme implements AppColorScheme {
  /// 싱글톤 인스턴스
  const LightColorScheme();

  // ! Primary Color: 주요 컬러
  @override
  Color get primary => Color(0xFF5E402D);

  @override
  Color get onPrimary => Color(0xFFFFFFFF);

  /// -[secondary]: Light Mode에서 사용되는 보조 Primary
  /// Light Mode에서만 우선순위가 낮은 인터랙션 요소를 표현하기 위해 사용
  @override
  Color get secondary => Color(0xFF5E402D).withValues(alpha: 0.3);

  /// -[onSecondary]: [secondary] 위에 배치되는 전경 색상
  /// 보조 인터랙션 요소 내부의 텍스트 및 아이콘에 사용
  @override
  Color get onSecondary => Color(0xFF5E402D);

  // ! 텍스트 관련 컬러: 계층과 용도에 따른 구분
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

  // ! Surface 관련 컬러: 컨테이너 및 레이어별 배경 색상
  @override
  Color get background => Color(0xFFFAFAFA);

  @override
  Color get surface => Color(0xFFFFFFFF);

  @override
  Color get surfaceVariant => Color(0xFFF2F2F2);

  @override
  Color get surfaceElevated => Color(0xFFFFFFFF);

  @override
  Color get surfaceDisabled => Color(0xFFE2E2E2);

  @override
  Color get surfaceDisabledSubtle => Color(0xFFF2F2F2);

  // ! Feedback 컬러
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
  Color get cancel => Color(0xFF6B6B6B);

  @override
  Color get onCancel => Color(0xFFFFFFFF);

  // ! 인터랙션 피드백 및 상태 표현용 오버레이 및 경계 색상
  @override
  Color get border => Color(0xFFE2E2E2);

  @override
  Color get divider => Color(0xFFECECEC);

  @override
  Color get scrim => Color.from(alpha: 0.45, red: 0, green: 0, blue: 0);

  @override
  Color get overlayPressed =>
      Color.from(alpha: 0.12, red: 0, green: 0, blue: 0);

  @override
  Color get overlayDisabled =>
      Color.from(alpha: 0.12, red: 0, green: 0, blue: 0);

  @override
  Color get overlayLoading => Color.from(alpha: 0.2, red: 0, green: 0, blue: 0);

  // ! 상태 존재 버튼의 상태 표현 컬러
  // ! Chip, Radio, Checkbox, ListButton 등
  @override
  Color get stateBtnSelected => Color(0xFF5E402D);

  @override
  Color get stateBtnUnselected => Color(0xFFC8BDB6);

  @override
  Color get stateBtnDisabled => Color(0xFFC8BDB6);

  // ! 단순 버튼의 상태 표현 컬러
  // ! Filled, Outlined, Text 버튼
  @override
  Color get btnDefault => Color(0xFF5E402D);

  @override
  Color get btnDisabled => Color(0xFFC8BDB6);

  // ! 프로필 카드 속 입력사항 Badge 표현 컬러
  @override
  Color get profileStatusBadgeDefault => Color(0xFF5E402D);

  @override
  Color get profileStatusBadgeDisabled => Color(0xFFC8BDB6);

  // ! 디자인에서 제공하는 톤 스케일: Primary 색상 계열의 다양한 명도 단계
  @override
  Color get primaryScale90 => Color(0xFFF1EAE4);

  @override
  Color get primaryScale70 => Color(0xFFC8B6AB);

  @override
  Color get primaryScale50 => Color(0xFF5E402D);

  @override
  Color get primaryScale30 => Color(0xFF4F3525);

  @override
  Color get primaryScale10 => Color(0xFF37291E);
}
