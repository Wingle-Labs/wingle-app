part of 'default_button.dart';

/// Default Button 크기 variant
enum DefaultButtonVariant {
  /// 화면 폭을 채우는 CTA 버튼
  fullWidth,

  /// 32px 높이
  xs,

  /// 36px 높이
  sm,

  /// 40px 높이
  md,

  /// 48px 높이
  lg,

  /// 54px 높이
  xl,
}

/// Default Button 상태
enum DefaultButtonStatus {
  /// 클릭 가능한 상태
  enabled,

  /// 클릭 불가능한 비활성 상태
  disabled,

  /// 요청 진행 중인 상태
  loading,
}

/// Default Button 시각 제원
@immutable
class DefaultButtonVisualSpec {
  /// 배경색
  final Color backgroundColor;

  /// 전경색
  final Color foregroundColor;

  /// pressed overlay 색상
  final Color pressedOverlayColor;

  /// 테두리
  final BorderSide borderSide;

  /// radius override
  final BorderRadius? borderRadius;

  /// 생성자
  const DefaultButtonVisualSpec({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.pressedOverlayColor,
    this.borderSide = BorderSide.none,
    this.borderRadius,
  });
}
