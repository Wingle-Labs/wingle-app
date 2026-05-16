import 'package:flutter/material.dart';

/// Grid row용 래퍼
class GridRow extends StatelessWidget {
  /// 간격
  final double gutter;

  /// 자식들
  final List<Widget> children;

  /// 생성자
  const GridRow({super.key, required this.gutter, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: gutter, children: children);
  }
}
