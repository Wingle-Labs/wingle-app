import 'package:flutter/material.dart';

/// 정적 컬러 계약.
///
/// 테마와 관계없이 항상 같은 값을 가져야 하는 색상입니다.
abstract interface class AppColorStaticScheme {
  /// Theme와 관계없이 고정으로 흰색을 표시해야 할 때 사용합니다.
  Color get staticWhite;

  /// Theme와 관계없이 고정으로 검은색을 표시해야 할 때 사용합니다.
  Color get staticBlack;
}
