import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/text/app_typography_token.dart';

/// 앱 전역에서 사용하는 텍스트 스타일 Extension
/// - 토큰 기반으로 구현
/// - ThemeExtension을 상속받아 Theme에 적용
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  // ! Display / Title
  /// Display
  final TextStyle display;

  /// Title
  final TextStyle title;

  /// Subtitle
  final TextStyle subtitle;

  // ! Body
  /// Main
  final TextStyle main;

  /// Main Sub
  final TextStyle mainSub;

  /// Body
  final TextStyle body;

  // ! Caption
  /// Caption
  final TextStyle caption;

  // ! Action
  /// Button
  final TextStyle button;

  /// Button Small
  final TextStyle buttonSmall;

  /// Chip
  final TextStyle chip;

  /// Chip Button
  final TextStyle chipButton;

  /// Constructor
  const AppTypography({
    required this.display,
    required this.title,
    required this.subtitle,
    required this.main,
    required this.mainSub,
    required this.body,
    required this.caption,
    required this.button,
    required this.buttonSmall,
    required this.chip,
    required this.chipButton,
  });

  /// 기본 텍스트 스타일
  static const AppTypography base = AppTypography(
    display: AppTypographyToken.display,
    title: AppTypographyToken.title24,
    subtitle: AppTypographyToken.subTitle20,
    main: AppTypographyToken.main18,
    mainSub: AppTypographyToken.main16,
    body: AppTypographyToken.nBody14,
    caption: AppTypographyToken.caption12,
    button: AppTypographyToken.btn16,
    buttonSmall: AppTypographyToken.btn12,
    chip: AppTypographyToken.chip,
    chipButton: AppTypographyToken.chipBtn,
  );

  /// 텍스트 스타일 복사
  @override
  AppTypography copyWith({
    TextStyle? display,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? main,
    TextStyle? mainSub,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? button,
    TextStyle? buttonSmall,
    TextStyle? chip,
    TextStyle? chipButton,
  }) {
    return AppTypography(
      display: display ?? this.display,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      main: main ?? this.main,
      mainSub: mainSub ?? this.mainSub,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      button: button ?? this.button,
      buttonSmall: buttonSmall ?? this.buttonSmall,
      chip: chip ?? this.chip,
      chipButton: chipButton ?? this.chipButton,
    );
  }

  /// 텍스트 스타일 보간
  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;

    return AppTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      main: TextStyle.lerp(main, other.main, t)!,
      mainSub: TextStyle.lerp(mainSub, other.mainSub, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      buttonSmall: TextStyle.lerp(buttonSmall, other.buttonSmall, t)!,
      chip: TextStyle.lerp(chip, other.chip, t)!,
      chipButton: TextStyle.lerp(chipButton, other.chipButton, t)!,
    );
  }
}
