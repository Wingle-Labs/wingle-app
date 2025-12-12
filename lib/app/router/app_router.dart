import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/phone_auth.dart';
import 'package:wingle/features/auth/presentation/phone_otp.dart';
import 'package:wingle/features/home/presentation/home.dart';
import 'package:wingle/features/onboarding/presentation/age_pick.page.dart';
import 'package:wingle/features/onboarding/presentation/onboarding_page.dart';
import 'package:wingle/features/onboarding/presentation/required_self_intro.dart';
import 'package:wingle/features/onboarding/presentation/selective_self_intro.dart';

/// 앱 라우터 정의 클래스
class AppRouter {
  /// 최상위 라우트 목록
  static List<GoRoute> get routes => <GoRoute>[
    GoRoute(path: AppRoute.root.path, builder: (context, state) => Container()),
    GoRoute(path: AppRoute.home.path, builder: (context, state) => Home()),
    GoRoute(
      path: AppRoute.onboarding.path,
      builder: (context, state) => OnboardingPage(),
      routes: onboardingRoutes,
    ),
  ];

  /// 온보딩 라우트 목록
  static List<GoRoute> get onboardingRoutes => [
    GoRoute(
      path: AppRoute.phone.path,
      builder: (context, state) => PhoneAuthPage(),
      routes: [
        GoRoute(
          path: AppRoute.otp.path,
          builder: (context, state) => PhoneOtpPage(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.age.path,
      builder: (context, state) => AgePickPage(),
    ),
    GoRoute(
      path: AppRoute.requiredSelfIntro.path,
      builder: (context, state) => RequiredSelfIntroPage(),
    ),
    GoRoute(
      path: AppRoute.selectiveSelfIntro.path,
      builder: (context, state) => SelectiveSelfIntro(),
    ),
  ];
}
