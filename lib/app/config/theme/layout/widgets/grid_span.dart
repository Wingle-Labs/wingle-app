import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/layout/grid_metrics.dart';

/// Grid 상 특정 span을 차지하는 위젯
class GridSpan extends StatelessWidget {
  /// GridMetrics
  final GridMetrics grid;

  /// span 개수
  final int span;

  /// 내부 컨텐츠
  final Widget child;

  /// 생성자
  const GridSpan({
    super.key,
    required this.grid,
    required this.span,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: grid.span(span), child: child);
  }
}
