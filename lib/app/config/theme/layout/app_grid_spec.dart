import 'package:flutter/foundation.dart';

/// 화면 레이아웃 그리드 스펙
@immutable
class AppGridSpec {
  /// 좌우 패딩
  final double horizontalPadding;

  /// 컬럼 사이 간격
  final double gutter;

  /// 컬럼 개수
  final int columnCount;

  /// 컬럼 비율
  ///
  /// 예:
  /// - [1, 1, 1, 1]
  /// - [1, 2]
  /// - [4, 1, 6, 1]
  final List<int> columnRatios;

  /// 생성자
  const AppGridSpec({
    required this.horizontalPadding,
    required this.gutter,
    required this.columnCount,
    required this.columnRatios,
  });
}
