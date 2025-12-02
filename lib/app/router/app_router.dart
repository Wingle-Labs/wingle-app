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
    GoRoute(path: AppRoutes.root, builder: (context, state) => Container()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => Home()),
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
    GoRoute(
      path: AppRoutes.phone,
      builder: (context, state) => PhoneAuthPage(),
      routes: [
        GoRoute(
          path: AppRoutes.otp,
          builder: (context, state) => PhoneOtpPage(),
        ),
      ],
    ),
    GoRoute(path: AppRoutes.age, builder: (context, state) => AgePickPage()),
    GoRoute(
      path: AppRoutes.requiredSelfIntro,
      builder: (context, state) => RequiredSelfIntroPage(),
    ),
    GoRoute(
      path: AppRoutes.selectiveSelfIntro,
      builder: (context, state) => SelectiveSelfIntro(),
    ),
  ];
}
