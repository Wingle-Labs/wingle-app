// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/color_palette.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';

/// Light Mode에서 사용되는 컬러 스키마.
///
/// 디자이너가 제공한 라이트 모드 컬러 스키마를 1:1로 정의하는 인터페이스.
class LightColorScheme implements AppColorScheme {
  /// 싱글톤 인스턴스
  const LightColorScheme();

  // ! Static Light, Dark 테마에 상관없이 변하지 않는 고정색입니다.
  /// - [staticWhite]: Theme와 관계없이 고정으로 흰색을 표시해야 할 때 사용합니다.
  @override
  Color get staticWhite => AppColorPalette.common0.color;

  /// - [staticBlack]: Theme와 관계없이 고정으로 검은색을 표시해야 할 때 사용합니다.
  @override
  Color get staticBlack => AppColorPalette.common100.color;

  // ! Primary Color: 가장 중요한 요소를 강조할 때 사용합니다.
  /// - [primaryNormal]: 요소를 강조할 때 사용합니다.
  @override
  Color get primaryNormal => AppColorPalette.brown50.color;

  /// - [primaryStrong]: 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @override
  @Deprecated('이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryStrong => AppColorPalette.brown70.color;

  /// - [primaryHeavy]: 이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @override
  @Deprecated('이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryHeavy => AppColorPalette.brown80.color;

  // TODO: 정의되면 교체하기
  // ! OnPrimary: Primary 색상 위에 배치되는 전경 색상
  /// - [onPrimaryNormal]: Primary 색상 위에 배치되는 전경 색상
  @override
  Color get onPrimaryNormal => AppColorPalette.neutral4.color;

  // ! Secondary: 강조가 덜 필요한 인터페이스 요소에 사용합니다.
  /// - [secondaryNormal]: 요소를 강조할 때 사용합니다.
  @override
  Color get secondaryNormal => AppColorPalette.asheBrown30.color;

  /// - [secondaryStrong]: 이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @override
  @Deprecated('이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryStrong => AppColorPalette.asheBrown50.color;

  /// - [secondaryHeavy]: 이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @override
  @Deprecated('이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryHeavy => AppColorPalette.asheBrown60.color;

  // ! OnSecondary: Secondary 색상 위에 배치되는 전경 색상
  /// - [onSecondaryNormal]: Secondary 색상 위에 배치되는 전경 색상
  @override
  Color get onSecondaryNormal => AppColorPalette.asheBrown90.color;

  // ! Background-Normal: 배경색으로 사용합니다.
  /// - [backgroundNormal]: 기본적인 배경으로 사용합니다.
  @override
  Color get backgroundNormal => AppColorPalette.neutral2.color;

  /// - [backgroundAlternative]: 기본 배경에서 구분을 줘야할 때나 배경 중요도를 낮게 둬야 할 때 사용합니다.
  @override
  Color get backgroundAlternative => AppColorPalette.neutral4.color;

  // ! Background-Elevated
  /// - [backgroundElevatedNormal]: Modal과 같이 층위가 생기는 View의 배경으로 사용합니다.
  @override
  Color get backgroundElevatedNormal => AppColorPalette.common0.color;

  /// - [backgroundElevatedAlternative]: 층위가 생기는 View에서 기본 배경과 구분을 줘야할 때 사용합니다.
  @override
  Color get backgroundElevatedAlternative => AppColorPalette.neutral4.color;

  // TODO: 주석
  // ! Overlay: TODO
  /// - [overlayInactive]: TODO
  @override
  Color get overlayInactive => AppColorPalette.neutral2.color.withValues(
    alpha: AppColorPalette.opacity74,
  );

  /// - [overlayPressed]: TODO
  @override
  Color get overlayPressed => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity12,
  );

  /// - [overlayDisabled]: TODO
  @override
  Color get overlayDisabled => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity12,
  );

  /// - [overlayLoading]: TODO
  @override
  Color get overlayLoading => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity22,
  );

  // ! Interaction: Blue 톤이 필요한 상호작용 요소에서 사용합니다.
  /// - [interactionInactive]: 상호작용 요소에서 활성화 가능한 요소에 사용합니다.
  @override
  Color get interactionInactive => AppColorPalette.asheBrown40.color.withValues(
    alpha: AppColorPalette.opacity74,
  );

  /// - [interactionDisable]: 상호작용이 불가능한 요소의 배경으로 사용합니다.
  @override
  Color get interactionDisable => AppColorPalette.neutral10.color;

  // ! Scrim: 뒷 View를 어둡게 표시해야 할 때 사용합니다.
  /// - [scrimNormal]: 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  @override
  Color get scrimNormal => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity28,
  );

  /// - [scrimStrong]: 강하게 배경을 구분해야 할 때 사용합니다.
  @override
  Color get scrimStrong => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity43,
  );

  // ! Text: 일반적인 경우에서 사용합니다.
  /// - [textNormal]: 일반적인 경우에 사용합니다.
  @override
  Color get textNormal => AppColorPalette.neutral90.color;

  /// - [textStrong]: 제목 등에서 강조를 해야 할 대 사용합니다.
  @override
  Color get textStrong => AppColorPalette.common100.color;

  /// - [textNeutral]: Alternative보다 가시성을 높게 잡아야 할 때 사용합니다.
  @override
  Color get textNeutral => AppColorPalette.neutral60.color;

  /// - [textAlternative]: 부가적인 정보를 표시해야 할 때 사용합니다.
  @override
  Color get textAlternative => AppColorPalette.neutral40.color;

  /// - [textAssistive]: 흐리지만 사용자가 알아야 하는 내용을 표시할 때 사용합니다.
  @override
  Color get textAssistive => AppColorPalette.neutral20.color;

  /// - [textDisable]: 비활성화된 요소를 표시할 때 사용합니다.
  @override
  Color get textDisable => AppColorPalette.neutral10.color;

  // ! Stroke-Structural: 구조적으로 경계를 지어주는 용도의 stroke
  /// - [strokeStructuralBorder]: 콘텐츠 영역이나 컴포넌트의 경계를 명확히 구분해야 할 때 사용합니다.
  @override
  Color get strokeStructuralBorder => AppColorPalette.gray30.color;

  /// - [strokeStructuralDivider]: 동일한 콘텐츠를 구분해야 할 때 사용합니다.
  @override
  Color get strokeStructuralDivider => AppColorPalette.gray70.color;

  // ! Stroke-Normal: 선을 써야 할 때 사용합니다.
  /// - [strokeNormal]: 콘텐츠를 확실히 구분해야 할 때 사용합니다.
  @override
  Color get strokeNormal => AppColorPalette.neutral8.color;

  /// - [strokeNeutral]: 정보 표시 효율화를 위해 가시성을 보다 낮게 표시해야 할 때 사용합니다.
  @override
  Color get strokeNeutral => AppColorPalette.neutral8.color.withValues(
    alpha: AppColorPalette.opacity74,
  );

  /// - [strokeAlternative]: 보다 옅은 색으로 표시하고자 할 때 사용합니다.
  @override
  Color get strokeAlternative => AppColorPalette.neutral8.color.withValues(
    alpha: AppColorPalette.opacity28,
  );

  // TODO: 보류된 항목
  // ! Stroke-Solid: 선을 써야 할 때 사용합니다.
  /// - [strokeSolidNormal]: 색 중첩을 피해야 할 때 사용합니다.
  @override
  Color get strokeSolidNormal => throw UnimplementedError();

  /// - [strokeSolidNeutral]: Normal보다 낮은 가시성을 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  @override
  Color get strokeSolidNeutral => throw UnimplementedError();

  /// - [strokeSolidAlternative]: 보다 옅은 색으로 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  @override
  Color get strokeSolidAlternative => throw UnimplementedError();

  // ! Status: 상태를 나타낼 때 사용합니다.
  /// - [statusPositive]: 긍정적인 상태를 안내할 때 사용합니다.
  @override
  Color get statusPositive => AppColorPalette.green50.color;

  /// - [statusCautionary]: 주의를 나타낼 때 사용합니다.
  @override
  Color get statusCautionary => AppColorPalette.yellow50.color;

  /// - [statusNegative]: 경고를 강조해야 할 때 사용합니다.
  @override
  Color get statusNegative => AppColorPalette.red50.color;

  // ! Elevation-Shadow: 그림자로 요소를 확실히 구분해 표시해야 할 때 사용합니다.
  /// - [elevationShadowNormal]: 적용한 UI가 조금 더 도드라져 보이게 할 목적으로 사용합니다.
  @override
  Color get elevationShadowNormal => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity8,
  );

  /// - [elevationShadowEmphasize]: 적용한 UI가 도드라져 보이게 할 목적으로 사용합니다.
  @override
  Color get elevationShadowEmphasize => AppColorPalette.common100.color
      .withValues(alpha: AppColorPalette.opacity8);

  /// - [elevationShadowStrong]: 적용한 UI가 확실하게 도드라져 보이게 할 목적으로 사용합니다.
  @override
  Color get elevationShadowStrong => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity8,
  );

  /// - [elevationShadowHeavy]: 적용 시 다른 어떤 것들보다 도드라져 보이게 하고 싶을 때 사용합니다.
  @override
  Color get elevationShadowHeavy => AppColorPalette.common100.color.withValues(
    alpha: AppColorPalette.opacity8,
  );

  // TODO: 색 결정되면 구현
  // ! Component-Fill: 요소에서 배경이 필요할 때 사용합니다.
  /// - [componentFillNormal]: 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  @override
  Color get componentFillNormal => throw UnimplementedError();

  /// - [componentFillStrong]: 작은 요소에서 배경을 확실히 구분해야 할 때 사용합니다.
  @override
  Color get componentFillStrong => throw UnimplementedError();

  /// - [componentFillAlternative]: 보다 옅게 배경을 구분해야 할 때 사용합니다.
  @override
  Color get componentFillAlternative => throw UnimplementedError();

  // TODO: 주석 채우기
  // ! Component-Primary-FilledButton: TODO
  /// - [componentPrimaryFilledButtonEnabled]: TODO
  @override
  Color get componentPrimaryFilledButtonEnabled =>
      AppColorPalette.brown50.color;

  /// - [componentPrimaryFilledButtonInactive]: TODO
  @override
  Color get componentPrimaryFilledButtonInactive => AppColorPalette
      .asheBrown40
      .color
      .withValues(alpha: AppColorPalette.opacity52);

  /// - [componentPrimaryFilledButtonDisabled]: TODO
  @override
  Color get componentPrimaryFilledButtonDisabled =>
      AppColorPalette.neutral10.color;

  // ! Component-Secondary-FilledButton: TODO
  /// - [componentSecondaryFilledButtonEnabled]: TODO
  @override
  Color get componentSecondaryFilledButtonEnabled =>
      AppColorPalette.asheBrown50.color;

  /// - [componentSecondaryFilledButtonInactive]: TODO
  @override
  Color get componentSecondaryFilledButtonInactive =>
      AppColorPalette.gray20.color;

  /// - [componentSecondaryFilledButtonDisabled]: TODO
  @override
  Color get componentSecondaryFilledButtonDisabled =>
      AppColorPalette.neutral8.color;

  // ! Component-Primary-OutlinedButton: TODO
  /// - [componentPrimaryOutlinedButtonEnabled]: TODO
  @override
  Color get componentPrimaryOutlinedButtonEnabled =>
      AppColorPalette.brown50.color;

  /// - [componentPrimaryOutlinedButtonInactive]: TODO
  @override
  Color get componentPrimaryOutlinedButtonInactive => AppColorPalette
      .asheBrown40
      .color
      .withValues(alpha: AppColorPalette.opacity52);

  /// - [componentPrimaryOutlinedButtonDisabled]: TODO
  @override
  Color get componentPrimaryOutlinedButtonDisabled =>
      AppColorPalette.neutral10.color;

  // ! Component-Secondary-OutlinedButton: TODO
  /// - [componentSecondaryOutlinedButtonEnabled]: TODO
  @override
  Color get componentSecondaryOutlinedButtonEnabled =>
      AppColorPalette.asheBrown50.color;

  /// - [componentSecondaryOutlinedButtonInactive]: TODO
  @override
  Color get componentSecondaryOutlinedButtonInactive =>
      AppColorPalette.gray20.color;

  /// - [componentSecondaryOutlinedButtonDisabled]: TODO
  @override
  Color get componentSecondaryOutlinedButtonDisabled =>
      AppColorPalette.neutral8.color;

  // ! Component-Assistive-OutlinedButton: TODO
  /// - [componentAssistiveOutlinedButtonEnabled]: TODO
  @override
  Color get componentAssistiveOutlinedButtonEnabled =>
      AppColorPalette.warmNeutral20.color;

  /// - [componentAssistiveOutlinedButtonDisabled]: TODO
  @override
  Color get componentAssistiveOutlinedButtonDisabled =>
      AppColorPalette.warmNeutral5.color;

  // ! Component-Primary-TextButton: TODO
  /// - [componentPrimaryTextButtonEnabled]: TODO
  @override
  Color get componentPrimaryTextButtonEnabled => AppColorPalette.brown50.color;

  /// - [componentPrimaryTextButtonDisabled]: TODO
  @override
  Color get componentPrimaryTextButtonDisabled =>
      AppColorPalette.neutral10.color;

  // ! Component-Secondary-TextButton: TODO
  /// - [componentSecondaryTextButtonEnabled]: TODO
  @override
  Color get componentSecondaryTextButtonEnabled =>
      AppColorPalette.asheBrown30.color;

  /// - [componentSecondaryTextButtonDisabled]: TODO
  @override
  Color get componentSecondaryTextButtonDisabled =>
      AppColorPalette.neutral10.color;

  // ! Component-Assistive-TextButton: TODO
  /// - [componentAssistiveTextButtonEnabled]: TODO
  @override
  Color get componentAssistiveTextButtonEnabled =>
      AppColorPalette.neutral40.color;

  /// - [componentAssistiveTextButtonDisabled]: TODO
  @override
  Color get componentAssistiveTextButtonDisabled =>
      AppColorPalette.neutral10.color;

  // TODO: 보류된 항목
  // ! Component-FloatingActionButton: TODO
  /// - [componentFloatingActionButtonNormal]: TODO
  @override
  Color get componentFloatingActionButtonNormal => throw UnimplementedError();

  /// - [componentFloatingActionButtonStrong]: TODO
  @override
  Color get componentFloatingActionButtonStrong => throw UnimplementedError();

  // ! Component-Checkbox: TODO

  /// - [componentCheckboxIconEnabled]: TODO
  @override
  Color get componentCheckboxIconEnabled => AppColorPalette.neutral4.color;

  /// - [componentCheckboxIconDisabled]: TODO
  @override
  Color get componentCheckboxIconDisabled => AppColorPalette.neutral2.color;

  // ! Component-BottomSheet: TODO
  /// - [componentBottomSheetHandle]: TODO
  @override
  Color get componentBottomSheetHandle => AppColorPalette.gray40.color;

  // ! Compoent-InfoCard: TODO
  /// - [componentInfoCardBackground]: TODO
  @override
  Color get componentInfoCardBackground => AppColorPalette.gray10.color;
}
