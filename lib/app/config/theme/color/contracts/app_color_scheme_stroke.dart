import 'package:flutter/material.dart';

/// 선/경계 컬러 계약.
abstract interface class AppColorStrokeScheme {
  /// 콘텐츠 영역이나 컴포넌트의 경계를 명확히 구분해야 할 때 사용합니다.
  Color get strokeStructuralBorder;

  /// 동일한 콘텐츠를 구분해야 할 때 사용합니다.
  Color get strokeStructuralDivider;

  /// 콘텐츠를 확실히 구분해야 할 때 사용합니다.
  Color get strokeNormal;

  /// 정보 표시 효율화를 위해 가시성을 보다 낮게 표시해야 할 때 사용합니다.
  Color get strokeNeutral;

  /// 보다 옅은 색으로 표시하고자 할 때 사용합니다.
  Color get strokeAlternative;

  /// 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidNormal;

  /// Normal보다 낮은 가시성을 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidNeutral;

  /// 보다 옅은 색으로 표시해야 하는 상황에서 색 중첩을 피해야 할 때 사용합니다.
  Color get strokeSolidAlternative;
}
