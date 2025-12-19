import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/auth/presentation/phone_auth.dart';
import 'package:wingle/features/auth/presentation/phone_otp.dart';
import 'package:wingle/features/onboarding/presentation/age_pick.page.dart';
import 'package:wingle/features/onboarding/presentation/login_page.dart';
import 'package:wingle/features/onboarding/presentation/onboarding_page.dart';
import 'package:wingle/features/onboarding/presentation/required_self_intro.dart';
import 'package:wingle/features/onboarding/presentation/selective_self_intro.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// ! 온보딩 라우트
final GoRoute onboardingRoute = GoRoute(
  path: OnboardingRoutes.root.path,
  name: OnboardingRoutes.root.name,
  builder: (context, state) => OnboardingPage(),
  routes: onboardingRoutes,
);

/// ! 온보딩 하위 라우트 목록
final List<GoRoute> onboardingRoutes = [
  // 로그인
  GoRoute(
    name: OnboardingRoutes.login.name,
    path: OnboardingRoutes.login.path,
    builder: (context, state) => LoginPage(),
    routes: loginRoutes,
  ),

  // 회원가입
  GoRoute(
    name: OnboardingRoutes.signup.name,
    path: OnboardingRoutes.signup.path,
    builder: (context, state) => Placeholder(),
    routes: signUpRoutes,
  ),
];

/// ! 로그인 하위 라우트 목록
final List<GoRoute> loginRoutes = [
  GoRoute(
    name: OnboardingRoutes.resetPassword.name,
    path: OnboardingRoutes.resetPassword.path,
    builder: (context, state) => Placeholder(),
  ),
  GoRoute(
    name: OnboardingRoutes.changePhoneNumber.name,
    path: OnboardingRoutes.changePhoneNumber.path,
    builder: (context, state) => Placeholder(),
  ),
];

/// ! 회원가입 하위 라우트 목록
final List<GoRoute> signUpRoutes = [
  GoRoute(
    name: OnboardingRoutes.phone.name,
    path: OnboardingRoutes.phone.path,
    builder: (context, state) => PhoneAuthPage(),
  ),
  GoRoute(
    path: OnboardingRoutes.otp.path,
    name: OnboardingRoutes.otp.name,
    builder: (context, state) => PhoneOtpPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.age.name,
    path: OnboardingRoutes.age.path,
    builder: (context, state) => AgePickPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.requiredSelfIntro.name,
    path: OnboardingRoutes.requiredSelfIntro.path,
    builder: (context, state) => RequiredSelfIntroPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.selectiveSelfIntro.name,
    path: OnboardingRoutes.selectiveSelfIntro.path,
    builder: (context, state) => SelectiveSelfIntro(),
  ),
];
