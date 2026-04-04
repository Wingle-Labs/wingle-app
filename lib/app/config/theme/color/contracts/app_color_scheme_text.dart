import 'package:flutter/material.dart';

/// 텍스트 컬러 계약.
abstract interface class AppColorTextScheme {
  /// 제목 등에서 강조를 해야 할 때 사용합니다.
  Color get textStrong;

  /// 일반적인 경우에 사용합니다.
  Color get textNormal;

  /// Alternative보다 가시성을 높게 잡아야 할 때 사용합니다.
  Color get textNeutral;

  /// 부가적인 정보를 표시해야 할 때 사용합니다.
  Color get textAlternative;

  /// 흐리지만 사용자가 알아야 하는 내용을 표시할 때 사용합니다.
  Color get textAssistive;

  /// 비활성화된 요소를 표시할 때 사용합니다.
  Color get textDisable;
}
