import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';
import 'package:wingle/app/config/theme/layout/app_layout_tokens.dart';

/// 어플리케이션의 공통 브레이크포인트 정의
enum AppBreakpoint {
  /// 초소형 (예: 모바일 세로)
  xs,

  /// 중형 (예: 태블릿 가로)
  md,

  /// 초대형 (예: 데스크톱 가로)
  xl,
}

/// 레이아웃 프리셋 종류
enum AppLayoutPreset {
  /// 모바일 세로 XS
  xsMobile,

  /// 태블릿 가로 MD - 3컬럼
  mdTabletThreeCol,

  /// 태블릿 가로 MD - 2컬럼 비대칭
  mdTabletTwoCol,

  /// 데스크톱 XL - 12컬럼
  xlDesktopTwelveCol,

  /// 데스크톱 XL - 비대칭 4컬럼
  xlDesktopAsymmetric,
}

/// 레이아웃 해상도 관련 유틸리티 클래스
final class AppLayoutResolver {
  const AppLayoutResolver._();

  /// 주어진 너비에 맞는 브레이크포인트를 반환합니다.
  static AppBreakpoint resolveBreakpoint(double width) {
    if (width < 391) {
      return AppBreakpoint.xs;
    }
    if (width < 744) {
      return AppBreakpoint.md;
    }
    return AppBreakpoint.xl;
  }

  /// 주어진 프리셋에 맞는 그리드 스펙을 반환합니다.
  static AppGridSpec resolvePreset(AppLayoutPreset preset) {
    switch (preset) {
      case AppLayoutPreset.xsMobile:
        return AppLayoutTokens.xsMobile;
      case AppLayoutPreset.mdTabletThreeCol:
        return AppLayoutTokens.mdTabletThreeCol;
      case AppLayoutPreset.mdTabletTwoCol:
        return AppLayoutTokens.mdTabletTwoCol;
      case AppLayoutPreset.xlDesktopTwelveCol:
        return AppLayoutTokens.xlDesktopTwelveCol;
      case AppLayoutPreset.xlDesktopAsymmetric:
        return AppLayoutTokens.xlDesktopAsymmetric;
    }
  }

  /// 주어진 컨텍스트의 너비에 맞는 브레이크포인트를 반환합니다.
  static AppBreakpoint of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return resolveBreakpoint(width);
  }
}
