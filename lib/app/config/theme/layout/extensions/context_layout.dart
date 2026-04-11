import 'package:flutter/widgets.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';
import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';
import 'package:wingle/app/config/theme/layout/grid_metrics.dart';

/// 레이아웃 관련 확장 메서드를 제공하는 BuildContext 확장 클래스
extension AppLayoutContext on BuildContext {
  /// 현재 컨텍스트의 브레이크포인트를 반환합니다.
  AppBreakpoint get breakpoint {
    return AppLayoutResolver.of(this);
  }

  /// 주어진 프리셋에 맞는 그리드 스펙을 반환합니다.
  AppGridSpec gridSpec(AppLayoutPreset preset) {
    return AppLayoutResolver.resolvePreset(preset);
  }

  /// 주어진 프리셋에 맞는 그리드 메트릭스를 반환합니다.
  GridMetrics grid(AppLayoutPreset preset) {
    final width = MediaQuery.sizeOf(this).width;
    final spec = gridSpec(preset);

    final ratioSum = spec.columnRatios.fold<int>(
      0,
      (sum, value) => sum + value,
    );
    final totalGutterWidth = spec.gutter * (spec.columnRatios.length - 1);
    final contentWidth = width - (spec.horizontalPadding * 2);
    final unitWidth = (contentWidth - totalGutterWidth) / ratioSum;

    return GridMetrics(
      spec: spec,
      screenWidth: width,
      contentWidth: contentWidth,
      unitWidth: unitWidth,
    );
  }
}
