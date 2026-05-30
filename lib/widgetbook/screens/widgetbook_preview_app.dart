import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/design_system.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/app/providers/current_user_gender_provider.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/presentation/phone_auth.dart';
import 'package:wingle/features/auth/presentation/phone_otp.dart';
import 'package:wingle/features/home/route/home_router.dart';
import 'package:wingle/features/onboarding/presentation/page/age_pick.page.dart';
import 'package:wingle/features/onboarding/presentation/page/agreement_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_body_shape_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_company_email_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_company_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_height_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_nickname_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_occupation_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_residence_page.dart';
import 'package:wingle/features/onboarding/presentation/page/login_page.dart';
import 'package:wingle/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:wingle/features/onboarding/presentation/page/onboarding_password_page.dart';
import 'package:wingle/features/onboarding/presentation/page/pass_page.dart';
import 'package:wingle/features/onboarding/presentation/page/pass_webview_page.dart';
import 'package:wingle/features/onboarding/presentation/page/required_self_intro.dart';
import 'package:wingle/features/onboarding/presentation/page/selective_self_intro.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';
import 'package:wingle/widgetbook/screens/widgetbook_placeholder_page.dart';

/// Widgetbook에서 실제 페이지 전환을 확인하기 위한 프리뷰 앱
class WidgetbookPreviewApp extends StatefulWidget {
  /// 시작 라우트
  final String initialLocation;

  /// 프리뷰 테마 모드
  final ThemeMode themeMode;

  /// 프리뷰 텍스트 배율
  final double textScaleFactor;

  /// 프리뷰에서 사용할 성별
  final String? userGender;

  /// 생성자
  const WidgetbookPreviewApp({
    super.key,
    required this.initialLocation,
    this.themeMode = ThemeMode.light,
    this.textScaleFactor = 1,
    this.userGender,
  });

  @override
  State<WidgetbookPreviewApp> createState() => _WidgetbookPreviewAppState();
}

class _WidgetbookPreviewAppState extends State<WidgetbookPreviewApp> {
  late final GoRouter _router = _createRouter(widget.initialLocation);

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: widget.themeMode,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(widget.textScaleFactor),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: _router,
    );

    if (widget.userGender == null) {
      return app;
    }

    return ProviderScope(
      overrides: [
        currentUserGenderProvider.overrideWithValue(widget.userGender),
      ],
      child: app,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  GoRouter _createRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        homeRoute,
        designSystemRoute,
        GoRoute(
          path: OnboardingRoutes.root.fullPath,
          name: OnboardingRoutes.root.name,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfile.fullPath,
          name: OnboardingRoutes.basicProfile.name,
          builder: (context, state) => const BasicProfileNicknamePage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileResidence.fullPath,
          name: OnboardingRoutes.basicProfileResidence.name,
          builder: (context, state) => const BasicProfileResidencePage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileHeight.fullPath,
          name: OnboardingRoutes.basicProfileHeight.name,
          builder: (context, state) => const BasicProfileHeightPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileBodyShape.fullPath,
          name: OnboardingRoutes.basicProfileBodyShape.name,
          builder: (context, state) => const BasicProfileBodyShapePage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileCompany.fullPath,
          name: OnboardingRoutes.basicProfileCompany.name,
          builder: (context, state) => const BasicProfileOccupationPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileCompanyName.fullPath,
          name: OnboardingRoutes.basicProfileCompanyName.name,
          builder: (context, state) => const BasicProfileCompanyPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.basicProfileCompanyEmail.fullPath,
          name: OnboardingRoutes.basicProfileCompanyEmail.name,
          builder: (context, state) => const BasicProfileCompanyEmailPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.login.fullPath,
          name: OnboardingRoutes.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.resetPassword.fullPath,
          name: OnboardingRoutes.resetPassword.name,
          builder: (context, state) =>
              const WidgetbookPlaceholderPage(title: '비밀번호 재설정'),
        ),
        GoRoute(
          path: OnboardingRoutes.changePhoneNumber.fullPath,
          name: OnboardingRoutes.changePhoneNumber.name,
          builder: (context, state) =>
              const WidgetbookPlaceholderPage(title: '전화번호 변경'),
        ),
        GoRoute(
          path: OnboardingRoutes.signup.fullPath,
          name: OnboardingRoutes.signup.name,
          builder: (context, state) =>
              const WidgetbookPlaceholderPage(title: '회원가입 루트'),
          routes: [
            GoRoute(
              path: OnboardingRoutes.agreement.path,
              name: OnboardingRoutes.agreement.name,
              builder: (context, state) => const AgreementPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.phone.path,
              name: OnboardingRoutes.phone.name,
              builder: (context, state) => const PhoneAuthPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.otp.path,
              name: OnboardingRoutes.otp.name,
              builder: (context, state) => const PhoneOtpPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.pass.path,
              name: OnboardingRoutes.pass.name,
              builder: (context, state) => const PassPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.passWebView.path,
              name: OnboardingRoutes.passWebView.name,
              builder: (context, state) => const PassWebViewPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.onboardingPassword.path,
              name: OnboardingRoutes.onboardingPassword.name,
              builder: (context, state) => OnboardingPasswordPage(
                phoneNumber:
                    (state.extra as String?) ??
                    PhoneNumber('01012345678').apiValue,
              ),
            ),
            GoRoute(
              path: OnboardingRoutes.age.path,
              name: OnboardingRoutes.age.name,
              builder: (context, state) => const AgePickPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.requiredSelfIntro.path,
              name: OnboardingRoutes.requiredSelfIntro.name,
              builder: (context, state) => const RequiredSelfIntroPage(),
            ),
            GoRoute(
              path: OnboardingRoutes.selectiveSelfIntro.path,
              name: OnboardingRoutes.selectiveSelfIntro.name,
              builder: (context, state) => const SelectiveSelfIntro(),
            ),
          ],
        ),
      ],
    );
  }
}
