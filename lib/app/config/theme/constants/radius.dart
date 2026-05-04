import 'package:figma_squircle/figma_squircle.dart';

/// 어플리케이션의 공통 둥근 모서리 정의
class AppRadius {
  /// 아주 작은 둥근 모서리
  static const double xs = 4;

  /// 작은 둥근 모서리
  static const double sm = 8;

  /// 디자인 시스템 표준 둥근 모서리 16px
  static const double standard = 16;

  /// 중간 둥근 모서리
  static const double md = 12;

  /// 큰 둥근 모서리
  static const double lg = 20;

  /// 디자인 시스템 큰 둥근 모서리 24px
  static const double xl = 24;

  /// iOS Style
  static const double iosStyle = 18;

  /// 중간 버튼 둥근 모서리
  static const double buttonMedium = 14;

  /// 완전한 pill 형태의 둥근 모서리
  static const double pill = 100;

  /// iOS Smoothing
  static const double iosSmoothing = 0.6;

  /// iOS Style Radius
  static SmoothBorderRadius iosStyleRadius = SmoothBorderRadius(
    cornerRadius: iosStyle,
    cornerSmoothing: iosSmoothing,
  );

  /// Checkbox Radius
  static const double checkboxRadius = 6;

  /// BottomSheet Top Radius
  static const double bottomSheetTopRadius = 26;

  /// Tag Radius
  static const double tagRadius = 6;

  /// Badge small Radius
  static const double badgeSm = 6;

  /// Badge default Radius
  static const double badge = 8;

  /// Toggle Icon Radius
  static const double toggleIcon = 2;

  /// Button Icon Slot Radius
  static const double buttonIconSlot = 3;

  /// Chip Button Radius
  static const double chipButton = 18;
}
