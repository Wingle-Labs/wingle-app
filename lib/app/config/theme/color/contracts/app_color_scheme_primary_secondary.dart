import 'package:flutter/material.dart';

/// 브랜드 및 표면 컬러 계약.
///
/// 브랜드 강조, 배경, 오버레이, 상호작용 색상을 포함합니다.
abstract interface class AppColorPrimarySecondaryScheme {
  /// 요소를 강조할 때 사용합니다.
  Color get primaryNormal;

  /// 이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에서 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryStrong;

  /// 이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에서 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get primaryHeavy;

  /// Primary 색상 위에 배치되는 전경 색상
  Color get onPrimaryNormal;

  /// 요소를 강조할 때 사용합니다.
  Color get secondaryNormal;

  /// 이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에 Hover에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryStrong;

  /// 이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.
  @Deprecated('이전 시스템에 Active에 해당하는 색을 마이그레이션할 때 사용합니다. 지금은 사용하지 않습니다.')
  Color get secondaryHeavy;

  /// Secondary 색상 위에 배치되는 전경 색상
  Color get onSecondaryNormal;

  /// 기본적인 배경으로 사용합니다.
  Color get backgroundNormal;

  /// 기본 배경에서 구분을 줘야할 때나 배경 중요도를 낮게 둬야 할 때 사용합니다.
  Color get backgroundAlternative;

  /// Modal과 같이 층위가 생기는 View의 배경으로 사용합니다.
  Color get backgroundElevatedNormal;

  /// 층위가 생기는 View에서 기본 배경과 구분을 줘야할 때 사용합니다.
  Color get backgroundElevatedAlternative;

  /// 기본 상태의 오버레이에 사용합니다.
  Color get overlayInactive;

  /// 눌림 상태의 오버레이에 사용합니다.
  Color get overlayPressed;

  /// 비활성 오버레이에 사용합니다.
  Color get overlayDisabled;

  /// 로딩 오버레이에 사용합니다.
  Color get overlayLoading;

  /// 상호작용 요소에서 활성화 가능한 요소에 사용합니다.
  Color get interactionInactive;

  /// 상호작용이 불가능한 요소의 배경으로 사용합니다.
  Color get interactionDisable;

  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get scrimNormal;

  /// 강하게 배경을 구분해야 할 때 사용합니다.
  Color get scrimStrong;
}
