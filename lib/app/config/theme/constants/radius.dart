import 'package:figma_squircle/figma_squircle.dart';

/// 어플리케이션의 공통 둥근 모서리 정의
class AppRadius {
  /// 아주 작은 둥근 모서리
  static const double xs = 4;

  /// 작은 둥근 모서리
  static const double sm = 8;

  /// 중간 둥근 모서리
  static const double md = 12;

  /// 큰 둥근 모서리
  static const double lg = 20;

  /// iOS Style
  static const double iosStyle = 18;

  /// iOS Smoothing
  static const double iosSmoothing = 0.6;

  /// iOS Style Radius
  static SmoothBorderRadius iosStyleRadius = SmoothBorderRadius(
    cornerRadius: iosStyle,
    cornerSmoothing: iosSmoothing,
  );

  /// Checkbox Radius
  static const double checkboxRadius = 6;
}
