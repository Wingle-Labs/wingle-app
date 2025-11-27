import 'package:go_router/go_router.dart';
import 'package:value_date/common/constants/route_constants.dart';

/// 앱 라우터 정의 클래스
class AppRouter {
  /// 최상위 라우트 목록
  static List<GoRoute> get routes => <GoRoute>[
    GoRoute(path: AppRoutes.root),
    GoRoute(path: AppRoutes.onboarding, routes: onboardingRoutes),
  ];

  /// 온보딩 라우트 목록
  static List<GoRoute> get onboardingRoutes => [
    GoRoute(path: AppRoutes.login),
    GoRoute(path: AppRoutes.signup),
  ];
}
