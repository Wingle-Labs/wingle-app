import 'package:flutter/material.dart';

/// 컴포넌트 컬러 계약.
abstract interface class AppColorComponentScheme {
  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentPrimaryFilledButtonEnabled;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  Color get componentPrimaryFilledButtonInactive;

  /// 비활성 상태의 배경으로 사용합니다.
  Color get componentPrimaryFilledButtonDisabled;

  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentSecondaryFilledButtonEnabled;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  Color get componentSecondaryFilledButtonInactive;

  /// 비활성 상태의 배경으로 사용합니다.
  Color get componentSecondaryFilledButtonDisabled;

  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentTertiaryFilledButtonEnabled;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  Color get componentTertiaryFilledButtonInactive;

  /// 비활성 상태의 배경으로 사용합니다.
  Color get componentTertiaryFilledButtonDisabled;

  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentPrimaryOutlinedButtonEnabled;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  Color get componentPrimaryOutlinedButtonInactive;

  /// 비활성 상태의 배경으로 사용합니다.
  Color get componentPrimaryOutlinedButtonDisabled;

  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentSecondaryOutlinedButtonEnabled;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  Color get componentSecondaryOutlinedButtonInactive;

  /// 비활성 상태의 배경으로 사용합니다.
  Color get componentSecondaryOutlinedButtonDisabled;

  /// 보조 outlined 버튼에 사용합니다.
  Color get componentAssistiveOutlinedButtonEnabled;

  /// 보조 outlined 버튼의 비활성 상태에 사용합니다.
  Color get componentAssistiveOutlinedButtonDisabled;

  /// primary text button에 사용합니다.
  Color get componentPrimaryTextButtonEnabled;

  /// primary text button의 비활성 상태에 사용합니다.
  Color get componentPrimaryTextButtonDisabled;

  /// secondary text button에 사용합니다.
  Color get componentSecondaryTextButtonEnabled;

  /// secondary text button의 비활성 상태에 사용합니다.
  Color get componentSecondaryTextButtonDisabled;

  /// assistive text button에 사용합니다.
  Color get componentAssistiveTextButtonEnabled;

  /// assistive text button의 비활성 상태에 사용합니다.
  Color get componentAssistiveTextButtonDisabled;

  /// floating action button 기본 상태에 사용합니다.
  Color get componentFloatingActionButtonNormal;

  /// floating action button 강조 상태에 사용합니다.
  Color get componentFloatingActionButtonStrong;

  /// checkbox 아이콘의 활성 상태에 사용합니다.
  Color get componentCheckboxIconEnabled;

  /// checkbox 아이콘의 비활성 상태에 사용합니다.
  Color get componentCheckboxIconDisabled;

  /// bottom sheet 핸들에 사용합니다.
  Color get componentBottomSheetHandle;

  /// info card 배경에 사용합니다.
  Color get componentInfoCardBackground;

  /// 선택 버튼 배경에 사용합니다.
  Color get componentSelectionButtonBackground;

  /// 선택 버튼 전경에 사용합니다.
  Color get componentSelectionButtonForeground;

  /// badge primary 배경에 사용합니다.
  Color get componentBadgePrimaryBackground;

  /// badge primary 텍스트에 사용합니다.
  Color get componentBadgePrimaryForeground;

  /// badge secondary 배경에 사용합니다.
  Color get componentBadgeSecondaryBackground;

  /// badge secondary 텍스트에 사용합니다.
  Color get componentBadgeSecondaryForeground;

  /// badge tertiary 배경에 사용합니다.
  Color get componentBadgeTertiaryBackground;

  /// badge tertiary 텍스트에 사용합니다.
  Color get componentBadgeTertiaryForeground;

  /// badge gray 배경에 사용합니다.
  Color get componentBadgeGrayBackground;

  /// badge gray 텍스트에 사용합니다.
  Color get componentBadgeGrayForeground;

  /// chip button primary selected 배경에 사용합니다.
  Color get componentChipButtonPrimarySelectedBackground;

  /// chip button primary selected 텍스트에 사용합니다.
  Color get componentChipButtonPrimarySelectedForeground;

  /// chip button primary unselected 배경에 사용합니다.
  Color get componentChipButtonPrimaryUnselectedBackground;

  /// chip button primary unselected 텍스트에 사용합니다.
  Color get componentChipButtonPrimaryUnselectedForeground;

  /// chip button primary unselected 테두리에 사용합니다.
  Color get componentChipButtonPrimaryUnselectedBorder;

  /// chip button primary disabled 배경에 사용합니다.
  Color get componentChipButtonPrimaryDisabledBackground;

  /// chip button primary disabled 텍스트에 사용합니다.
  Color get componentChipButtonPrimaryDisabledForeground;

  /// chip button secondary default 배경에 사용합니다.
  Color get componentChipButtonSecondaryDefaultBackground;

  /// chip button secondary default 텍스트에 사용합니다.
  Color get componentChipButtonSecondaryDefaultForeground;

  /// chip button secondary selected 배경에 사용합니다.
  Color get componentChipButtonSecondarySelectedBackground;

  /// chip button secondary selected 텍스트에 사용합니다.
  Color get componentChipButtonSecondarySelectedForeground;

  /// chip button secondary unselected 배경에 사용합니다.
  Color get componentChipButtonSecondaryUnselectedBackground;

  /// chip button secondary unselected 텍스트에 사용합니다.
  Color get componentChipButtonSecondaryUnselectedForeground;

  /// chip button secondary unselected 테두리에 사용합니다.
  Color get componentChipButtonSecondaryUnselectedBorder;

  /// chip button secondary disabled 배경에 사용합니다.
  Color get componentChipButtonSecondaryDisabledBackground;

  /// chip button secondary disabled 텍스트에 사용합니다.
  Color get componentChipButtonSecondaryDisabledForeground;
}
