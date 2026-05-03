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
}
