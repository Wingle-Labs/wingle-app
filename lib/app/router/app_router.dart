import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/onboarding/presentation/onboarding_page.dart';

/// 앱 라우터 정의 클래스
class AppRouter {
  /// 최상위 라우트 목록
  static List<GoRoute> get routes => <GoRoute>[
    GoRoute(path: AppRoutes.root, builder: (context, state) => Container()),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) {
        return OnboardingPage();
      },
      routes: onboardingRoutes,
    ),
  ];

  /// 온보딩 라우트 목록
  static List<GoRoute> get onboardingRoutes => [
    GoRoute(path: AppRoutes.login, builder: (context, state) => Container()),
    GoRoute(path: AppRoutes.signup, builder: (context, state) => Container()),
  ];
}
