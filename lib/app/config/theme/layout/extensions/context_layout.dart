import 'package:flutter/widgets.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';
import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';

/// 레이아웃 관련 확장 메서드를 제공하는 BuildContext 확장 클래스
extension AppLayoutContext on BuildContext {
  /// 현재 컨텍스트의 브레이크포인트를 반환합니다.
  AppBreakpoint get breakpoint {
    return AppLayoutResolver.of(this);
  }

  /// 주어진 프리셋에 맞는 그리드 스펙을 반환합니다.
  AppGridSpec grid(AppLayoutPreset preset) {
    return AppLayoutResolver.resolvePreset(preset);
  }
}
