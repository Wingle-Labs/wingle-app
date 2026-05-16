import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// 공용 컴포넌트가 직접 참조하는 역할 기반 padding token.
///
/// Primitive token([AppPadding])의 의미를 컴포넌트 역할로 좁혀서, reusable
/// component 내부에서 raw primitive 의존을 점진적으로 줄이기 위한 compatibility
/// layer입니다.
final class AppComponentPadding {
  const AppComponentPadding._();

  /// AppBar 좌우 여백.
  static const double appBarHorizontal = AppPadding.horizontal;

  /// AppBar 상하 여백.
  static const double appBarVertical = AppPadding.vertical;

  /// 기본 input 좌우 여백.
  static const double inputHorizontal = AppPadding.textfield;

  /// 기본 input 상하 여백.
  static const double inputVertical = AppPadding.textfieldVertical;

  /// underline input 상하 여백.
  static const double inputUnderlineVertical = AppPadding.xxs;

  /// input prefix와 본문 사이 여백.
  static const double inputPrefixGap = AppPadding.textfieldSuffix;

  /// input suffix와 우측 edge 사이 여백.
  static const double inputSuffixGap = AppPadding.textfieldSuffix;

  /// 카드 내부 여백.
  static const double card = AppPadding.card;

  /// Bottom sheet 내부 여백.
  static const double sheet = AppPadding.bottomSheet;

  /// 기본 버튼 좌우 여백.
  static const double buttonHorizontal = AppPadding.buttonHorizontal;

  /// 기본 버튼 상하 여백.
  static const double buttonVertical = AppPadding.buttonVertical;
}

/// 공용 컴포넌트가 직접 참조하는 역할 기반 spacing token.
final class AppComponentSpacing {
  const AppComponentSpacing._();

  /// AppBar 액션 사이 간격.
  static const double appBarActionGap = AppSpacing.s4;

  /// AppBar leading/title/trailing 사이 간격.
  static const double appBarTitleGap = AppSpacing.s12;

  /// Display AppBar subtitle과 title 사이 간격.
  static const double appBarDisplayTextGap = AppSpacing.s6;

  /// Input label과 field 사이 간격.
  static const double inputLabelGap = AppSpacing.inputFieldLabelInternal;

  /// Input 하단 helper/error text와 field 사이 간격.
  static const double inputAssistiveGap = AppSpacing.s4;

  /// Input 하단 assistive action 사이 간격.
  static const double inputAssistiveActionGap = AppSpacing.s8;

  /// 화면 section 간격.
  static const double section = AppSpacing.s24;

  /// 화면 하단 CTA 보호 간격.
  static const double bottom = AppSpacing.bottom;
}

/// 공용 컴포넌트가 직접 참조하는 역할 기반 radius token.
final class AppComponentRadius {
  const AppComponentRadius._();

  /// 기본 input radius.
  static const double input = AppRadius.iosStyle;

  /// 기본 card radius.
  static const double card = AppRadius.standard;

  /// Bottom sheet 상단 radius.
  static const double sheet = AppRadius.bottomSheetTopRadius;

  /// 기본 button radius.
  static const double button = AppRadius.pill;

  /// 버튼 내부 icon slot radius.
  static const double buttonIconSlot = AppRadius.buttonIconSlot;
}

/// 공용 컴포넌트가 직접 참조하는 역할 기반 size token.
final class AppComponentSize {
  const AppComponentSize._();

  /// AppBar icon의 시각적 크기.
  static const double appBarAction = AppIconSize.xl;

  /// AppBar icon action hit grid.
  static const double appBarActionHit = AppIconPixelGrid.xl;

  /// AppBar 최소 toolbar 높이.
  static const double appBarMinHeight =
      AppComponentPadding.appBarVertical * 2 + appBarActionHit;

  /// 기본 input 최소 높이.
  static const double inputMinHeight = AppContainerSize.inputFieldMinimun;

  /// multiline input 최소 높이 배수.
  static const double inputMultilineMinHeightMultiplier = 2;
}
