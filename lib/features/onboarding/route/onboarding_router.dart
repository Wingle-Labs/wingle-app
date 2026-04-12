import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/auth/presentation/phone_auth.dart';
import 'package:wingle/features/auth/presentation/phone_otp.dart';
import 'package:wingle/features/onboarding/presentation/page/age_pick.page.dart';
import 'package:wingle/features/onboarding/presentation/page/agreement_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_body_shape_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_company_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_height_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_nickname_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_residence_page.dart';
import 'package:wingle/features/onboarding/presentation/page/login_page.dart';
import 'package:wingle/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:wingle/features/onboarding/presentation/page/onboarding_password_page.dart';
import 'package:wingle/features/onboarding/presentation/page/pass_page.dart';
import 'package:wingle/features/onboarding/presentation/page/pass_webview_page.dart';
import 'package:wingle/features/onboarding/presentation/page/required_self_intro.dart';
import 'package:wingle/features/onboarding/presentation/page/selective_self_intro.dart';
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
  // 기본 프로필 정보 등록
  GoRoute(
    name: OnboardingRoutes.basicProfile.name,
    path: OnboardingRoutes.basicProfile.path,
    builder: (context, state) => const BasicProfileNicknamePage(),
  ),
  GoRoute(
    name: OnboardingRoutes.basicProfileResidence.name,
    path: OnboardingRoutes.basicProfileResidence.path,
    builder: (context, state) => const BasicProfileResidencePage(),
  ),
  GoRoute(
    name: OnboardingRoutes.basicProfileHeight.name,
    path: OnboardingRoutes.basicProfileHeight.path,
    builder: (context, state) => const BasicProfileHeightPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.basicProfileBodyShape.name,
    path: OnboardingRoutes.basicProfileBodyShape.path,
    builder: (context, state) => const BasicProfileBodyShapePage(),
  ),
  GoRoute(
    name: OnboardingRoutes.basicProfileCompany.name,
    path: OnboardingRoutes.basicProfileCompany.path,
    builder: (context, state) => const BasicProfileCompanyPage(),
  ),
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
    name: OnboardingRoutes.agreement.name,
    path: OnboardingRoutes.agreement.path,
    builder: (context, state) => AgreementPage(),
  ),
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
    name: OnboardingRoutes.pass.name,
    path: OnboardingRoutes.pass.path,
    builder: (context, state) => PassPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.passWebView.name,
    path: OnboardingRoutes.passWebView.path,
    builder: (context, state) => PassWebViewPage(),
  ),
  GoRoute(
    name: OnboardingRoutes.onboardingPassword.name,
    path: OnboardingRoutes.onboardingPassword.path,
    builder: (context, state) =>
        OnboardingPasswordPage(phoneNumber: state.extra as String),
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
