// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

/// 애플리케이션 컬러 스키마.
///
/// 디자이너가 제공한 컬러 스키마를 1:1로 정의하는 인터페이스.
abstract interface class AppColorScheme {
  // ! Static Light, Dark 테마에 상관없이 변하지 않는 고정색입니다.
  /// - [staticWhite]: Theme와 관계없이 고정으로 흰색을 표시해야 할 때 사용합니다.
  Color get staticWhite;

  /// - [staticBlack]: Theme와 관계없이 고정으로 검은색을 표시해야 할 때 사용합니다.
  Color get staticBlack;

  // ! Primary Color: 가장 중요한 요소를 강조할 때 사용합니다.
  /// - [primaryNormal]: 요소를 강조할 때 사용합니다.
  Color get primaryNormal;

  /// - [primaryStrong]: 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryStrong;

  /// - [primaryHeavy]: 이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryHeavy;

  // ! OnPrimary: Primary 색상 위에 배치되는 전경 색상
  /// - [onPrimaryNormal]: Primary 색상 위에 배치되는 전경 색상
  Color get onPrimaryNormal;

  // ! Secondary: 강조가 덜 필요한 인터페이스 요소에 사용합니다.
  /// - [secondaryNormal]: 요소를 강조할 때 사용합니다.
  Color get secondaryNormal;

  /// - [secondaryStrong]: 이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryStrong;

  /// - [secondaryHeavy]: 이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryHeavy;

  // ! OnSecondary: Secondary 색상 위에 배치되는 전경 색상
  /// - [onSecondaryNormal]: Secondary 색상 위에 배치되는 전경 색상
  Color get onSecondaryNormal;

  // ! Background-Normal: 배경색으로 사용합니다.
  /// - [backgroundNormal]: 기본적인 배경으로 사용합니다.
  Color get backgroundNormal;

  /// - [backgroundAlternative]: 기본 배경에서 구분을 줘야할 때나 배경 중요도를 낮게 둬야 할 때 사용합니다.
  Color get backgroundAlternative;

  // ! Background-Elevated
  /// - [backgroundElevatedNormal]: Modal과 같이 층위가 생기는 View의 배경으로 사용합니다.
  Color get backgroundElevatedNormal;

  /// - [backgroundElevatedAlternative]: 층위가 생기는 View에서 기본 배경과 구분을 줘야할 때 사용합니다.
  Color get backgroundElevatedAlternative;

  // TODO: 주석
  // ! Overlay: TODO
  /// - [overlayInactive]: TODO
  Color get overlayInactive;

  /// - [overlayPressed]: TODO
  Color get overlayPressed;

  /// - [overlayDisabled]: TODO
  Color get overlayDisabled;

  /// - [overlayLoading]: TODO
  Color get overlayLoading;

  // ! Interaction: Blue 톤이 필요한 상호작용 요소에서 사용합니다.
  /// - [interactionInactive]: 상호작용 요소에서 활성화 가능한 요소에 사용합니다.
  Color get interactionInactive;

  /// - [interactionDisable]: 상호작용이 불가능한 요소의 배경으로 사용합니다.
  Color get interactionDisable;

  // ! Scrim: 뒷 View를 어둡게 표시해야 할 때 사용합니다.
  /// - [scrimNormal]: 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get scrimNormal;

  /// - [scrimStrong]: 강하게 배경을 구분해야 할 때 사용합니다.
  Color get scrimStrong;

  // ! Text: 일반적인 경우에서 사용합니다.
  /// - [textStrong]: 제목 등에서 강조를 해야 할 대 사용합니다.
  Color get textStrong;

  /// - [textNormal]: 일반적인 경우에 사용합니다.
  Color get textNormal;

  /// - [textNeutral]: Alternative보다 가시성을 높게 잡아야 할 때 사용합니다.
  Color get textNeutral;

  /// - [textAlternative]: 부가적인 정보를 표시해야 할 때 사용합니다.
  Color get textAlternative;

  /// - [textAssistive]: 흐리지만 사용자가 알아야 하는 내용을 표시할 때 사용합니다.
  Color get textAssistive;

  /// - [textDisable]: 비활성화된 요소를 표시할 때 사용합니다.
  Color get textDisable;

  // ! Stroke-Structural: 구조적으로 경계를 지어주는 용도의 stroke
  /// - [strokeStructuralBorder]: 콘텐츠 영역이나 컴포넌트의 경계를 명확히 구분해야 할 때 사용합니다.
  Color get strokeStructuralBorder;

  /// - [strokeStructuralDivider]: 동일한 콘텐츠를 구분해야 할 때 사용합니다.
  Color get strokeStructuralDivider;

  // ! Stroke-Normal: 선을 써야 할 때 사용합니다.
  /// - [strokeNormal]: 콘텐츠를 확실히 구분해야 할 때 사용합니다.
  Color get strokeNormal;

  /// - [strokeNeutral]: 정보 표시 효율화를 위해 가시성을 보다 낮게 표시해야 할 때 사용합니다.
  Color get strokeNeutral;

  /// - [strokeAlternative]: 보다 옅은 색으로 표시하고자 할 때 사용합니다.
  Color get strokeAlternative;

  // ! Stroke-Solid: 선을 써야 할 때 사용합니다.
  /// - [strokeSolidNormal]: 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidNormal;

  /// - [strokeSolidNeutral]: Normal보다 낮은 가시성을 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidNeutral;

  /// - [strokeSolidAlternative]: 보다 옅은 색으로 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidAlternative;

  // ! Status: 상태를 나타낼 때 사용합니다.
  /// - [statusPositive]: 긍정적인 상태를 안내할 때 사용합니다.
  Color get statusPositive;

  /// - [statusCautionary]: 주의를 나타낼 때 사용합니다.
  Color get statusCautionary;

  /// - [statusNegative]: 경고를 강조해야 할 때 사용합니다.
  Color get statusNegative;

  // ! Elevation-Shadow: 그림자로 요소를 확실히 구분해 표시해야 할 때 사용합니다.
  /// - [elevationShadowNormal]: 적용한 UI가 조금 더 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowNormal;

  /// - [elevationShadowEmphasize]: 적용한 UI가 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowEmphasize;

  /// - [elevationShadowStrong]: 적용한 UI가 확실하게 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowStrong;

  /// - [elevationShadowHeavy]: 적용 시 다른 어떤 것들보다 도드라져 보이게 하고 싶을 때 사용합니다.
  Color get elevationShadowHeavy;

  // ! Component-Fill: 요소에서 배경이 필요할 때 사용합니다.
  /// - [componentFillNormal]: 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentFillNormal;

  /// - [componentFillStrong]: 작은 요소에서 배경을 확실히 구분해야 할 때 사용합니다.
  Color get componentFillStrong;

  /// - [componentFillAlternative]: 보다 옅게 배경을 구분해야 할 때 사용합니다.
  Color get componentFillAlternative;

  // TODO: 주석 채우기
  // ! Component-Primary-FilledButton: TODO
  /// - [componentPrimaryFilledButtonEnabled]: TODO
  Color get componentPrimaryFilledButtonEnabled;

  /// - [componentPrimaryFilledButtonInactive]: TODO
  Color get componentPrimaryFilledButtonInactive;

  /// - [componentPrimaryFilledButtonDisabled]: TODO
  Color get componentPrimaryFilledButtonDisabled;

  // ! Component-Secondary-FilledButton: TODO
  /// - [componentSecondaryFilledButtonEnabled]: TODO
  Color get componentSecondaryFilledButtonEnabled;

  /// - [componentSecondaryFilledButtonInactive]: TODO
  Color get componentSecondaryFilledButtonInactive;

  /// - [componentSecondaryFilledButtonDisabled]: TODO
  Color get componentSecondaryFilledButtonDisabled;

  // ! Component-Primary-OutlinedButton: TODO
  /// - [componentPrimaryOutlinedButtonEnabled]: TODO
  Color get componentPrimaryOutlinedButtonEnabled;

  /// - [componentPrimaryOutlinedButtonInactive]: TODO
  Color get componentPrimaryOutlinedButtonInactive;

  /// - [componentPrimaryOutlinedButtonDisabled]: TODO
  Color get componentPrimaryOutlinedButtonDisabled;

  // ! Component-Secondary-OutlinedButton: TODO
  /// - [componentSecondaryOutlinedButtonEnabled]: TODO
  Color get componentSecondaryOutlinedButtonEnabled;

  /// - [componentSecondaryOutlinedButtonInactive]: TODO
  Color get componentSecondaryOutlinedButtonInactive;

  /// - [componentSecondaryOutlinedButtonDisabled]: TODO
  Color get componentSecondaryOutlinedButtonDisabled;

  // ! Component-Assistive-OutlinedButton: TODO
  /// - [componentAssistiveOutlinedButtonEnabled]: TODO
  Color get componentAssistiveOutlinedButtonEnabled;

  /// - [componentAssistiveOutlinedButtonDisabled]: TODO
  Color get componentAssistiveOutlinedButtonDisabled;

  // ! Component-Primary-TextButton: TODO
  /// - [componentPrimaryTextButtonEnabled]: TODO
  Color get componentPrimaryTextButtonEnabled;

  /// - [componentPrimaryTextButtonDisabled]: TODO
  Color get componentPrimaryTextButtonDisabled;

  // ! Component-Secondary-TextButton: TODO
  /// - [componentSecondaryTextButtonEnabled]: TODO
  Color get componentSecondaryTextButtonEnabled;

  /// - [componentSecondaryTextButtonDisabled]: TODO
  Color get componentSecondaryTextButtonDisabled;

  // ! Component-Assistive-TextButton: TODO
  /// - [componentAssistiveTextButtonEnabled]: TODO
  Color get componentAssistiveTextButtonEnabled;

  /// - [componentAssistiveTextButtonDisabled]: TODO
  Color get componentAssistiveTextButtonDisabled;

  // ! Component-FloatingActionButton: TODO
  /// - [componentFloatingActionButtonNormal]: TODO
  Color get componentFloatingActionButtonNormal;

  /// - [componentFloatingActionButtonStrong]: TODO
  Color get componentFloatingActionButtonStrong;
}
