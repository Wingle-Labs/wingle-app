import 'package:flutter/material.dart';

/// 표면/채움 컬러 계약.
abstract interface class AppColorElevationScheme {
  /// 일반적인 요소에서 배경을 구분해야 할 때 사용합니다.
  Color get componentFillNormal;

  /// 작은 요소에서 배경을 확실히 구분해야 할 때 사용합니다.
  Color get componentFillStrong;

  /// 보다 옅게 배경을 구분해야 할 때 사용합니다.
  Color get componentFillAlternative;
}
