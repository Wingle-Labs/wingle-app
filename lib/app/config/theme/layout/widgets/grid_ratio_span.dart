import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/layout/grid_metrics.dart';

/// 비율 기반 span 위젯
class GridRatioSpan extends StatelessWidget {
  /// GridMetrics
  final GridMetrics grid;

  /// 비율 리스트
  final List<int> ratios;

  /// 내부 컨텐츠
  final Widget child;

  /// 생성자
  const GridRatioSpan({
    super.key,
    required this.grid,
    required this.ratios,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: grid.ratioSpan(ratios), child: child);
  }
}
