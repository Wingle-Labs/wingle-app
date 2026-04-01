import 'package:flutter/material.dart';

/// 상태 및 그림자 컬러 계약.
abstract interface class AppColorStatusScheme {
  /// 긍정적인 상태를 안내할 때 사용합니다.
  Color get statusPositive;

  /// 주의를 나타낼 때 사용합니다.
  Color get statusCautionary;

  /// 경고를 강조해야 할 때 사용합니다.
  Color get statusNegative;

  /// 적용한 UI가 조금 더 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowNormal;

  /// 적용한 UI가 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowEmphasize;

  /// 적용한 UI가 확실하게 도드라져 보이게 할 목적으로 사용합니다.
  Color get elevationShadowStrong;

  /// 적용 시 다른 어떤 것들보다 도드라져 보이게 하고 싶을 때 사용합니다.
  Color get elevationShadowHeavy;
}
