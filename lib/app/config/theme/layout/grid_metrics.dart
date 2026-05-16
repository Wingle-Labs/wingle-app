import 'package:flutter/foundation.dart';
import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';

/// 실제 화면 너비를 기준으로 계산된 Grid 정보
@immutable
class GridMetrics {
  /// 원본 스펙
  final AppGridSpec spec;

  /// 전체 화면 너비
  final double screenWidth;

  /// 좌우 패딩 제외 후 사용 가능한 너비
  final double contentWidth;

  /// 비율 1의 단위 폭
  final double unitWidth;

  /// GridMetrics 생성자
  const GridMetrics({
    required this.spec,
    required this.screenWidth,
    required this.contentWidth,
    required this.unitWidth,
  });

  /// 특정 span의 실제 너비 계산
  ///
  /// 예:
  /// - 4col 1:1:1:1 에서 span(2) = 2개 컬럼 + gutter 1개
  /// - 2col 1:2 에서 spanByRatio([1, 2]) = 전체 폭
  double span(int columns) {
    if (columns <= 0) {
      return 0;
    }

    final clampedColumns = columns.clamp(1, spec.columnCount);
    return (unitWidth * clampedColumns) + (spec.gutter * (clampedColumns - 1));
  }

  /// 비율 배열 기준 실제 너비 계산
  ///
  /// 예:
  /// - ratioSpan([1])
  /// - ratioSpan([1, 2])
  double ratioSpan(List<int> ratios) {
    if (ratios.isEmpty) {
      return 0;
    }

    final ratioSum = ratios.fold<int>(0, (sum, value) => sum + value);
    final gutterCount = ratios.length - 1;

    return (unitWidth * ratioSum) + (spec.gutter * gutterCount);
  }
}
