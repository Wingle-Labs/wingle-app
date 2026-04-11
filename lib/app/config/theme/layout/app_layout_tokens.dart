import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';

/// 레이아웃 토큰 모음
final class AppLayoutTokens {
  const AppLayoutTokens._();

  /// 모바일 세로 XS
  static const AppGridSpec xsMobile = AppGridSpec(
    horizontalPadding: 16,
    gutter: 12,
    columnCount: 4,
    columnRatios: [1, 1, 1, 1],
  );

  /// 태블릿 가로 MD - 3컬럼
  static const AppGridSpec mdTabletThreeCol = AppGridSpec(
    horizontalPadding: 20,
    gutter: 20,
    columnCount: 3,
    columnRatios: [1, 1, 1],
  );

  /// 태블릿 가로 MD - 2컬럼 비대칭
  static const AppGridSpec mdTabletTwoCol = AppGridSpec(
    horizontalPadding: 20,
    gutter: 20,
    columnCount: 2,
    columnRatios: [1, 2],
  );

  /// 데스크톱 XL - 12컬럼
  static const AppGridSpec xlDesktopTwelveCol = AppGridSpec(
    horizontalPadding: 20,
    gutter: 20,
    columnCount: 12,
    columnRatios: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  );

  /// 데스크톱 XL - 비대칭 4컬럼
  static const AppGridSpec xlDesktopAsymmetric = AppGridSpec(
    horizontalPadding: 20,
    gutter: 20,
    columnCount: 4,
    columnRatios: [4, 1, 6, 1],
  );
}
