import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';
import 'package:wingle/app/config/theme/layout/extensions/context_layout.dart';

/// Grid padding을 적용하는 컨테이너
class GridContainer extends StatelessWidget {
  /// 사용할 레이아웃 프리셋
  final AppLayoutPreset preset;

  /// 내부 컨텐츠
  final Widget child;

  /// 생성자
  const GridContainer({super.key, required this.preset, required this.child});

  @override
  Widget build(BuildContext context) {
    final grid = context.grid(preset);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: grid.spec.horizontalPadding),
      child: child,
    );
  }
}
