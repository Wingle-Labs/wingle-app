import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';

/// 레이아웃 토큰 모음
final class AppLayoutTokens {
  const AppLayoutTokens._();

  /// Galaxy 기본 모바일
  static const AppGridSpec mobileSm = AppGridSpec(
    horizontalPadding: 16,
    gutter: 0,
    columnCount: 1,
    columnRatios: [1],
  );

  /// iPhone 표준 모바일
  static const AppGridSpec mobileMd = AppGridSpec(
    horizontalPadding: 20,
    gutter: 0,
    columnCount: 1,
    columnRatios: [1],
  );

  /// Pro Max, Ultra 모바일
  static const AppGridSpec mobileLg = AppGridSpec(
    horizontalPadding: 24,
    gutter: 0,
    columnCount: 1,
    columnRatios: [1],
  );

  /// iPad Mini, Tab S9
  static const AppGridSpec tabletSm = AppGridSpec(
    horizontalPadding: 32,
    gutter: 20,
    columnCount: 2,
    columnRatios: [1, 1],
  );

  /// Fold 펼침, iPad Air
  static const AppGridSpec tabletMd = AppGridSpec(
    horizontalPadding: 40,
    gutter: 20,
    columnCount: 2,
    columnRatios: [1, 2],
  );

  /// iPad Pro 13"
  static const AppGridSpec tabletLg = AppGridSpec(
    horizontalPadding: 48,
    gutter: 24,
    columnCount: 4,
    columnRatios: [1, 1, 1, 1],
  );

  /// Tab Ultra, 웹
  static const AppGridSpec desktop = AppGridSpec(
    horizontalPadding: 64,
    gutter: 24,
    columnCount: 12,
    columnRatios: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  );

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
