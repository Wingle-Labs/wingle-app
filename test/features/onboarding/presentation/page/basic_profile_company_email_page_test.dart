import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_company_email_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('회사 이메일 인증 페이지는 이메일 입력 전 다음 버튼을 비활성화한다', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();

    expect(
      find.text('onboarding.basicProfile.companyEmail.emailLabel'),
      findsOneWidget,
    );
    expect(
      find.text('onboarding.basicProfile.companyEmail.emailHint'),
      findsOneWidget,
    );
    expect(
      find.text('onboarding.basicProfile.companyEmail.codeLabel'),
      findsNothing,
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('회사 이메일을 입력하면 다음 버튼을 활성화한다', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pump();

    await tester.enterText(find.byType(TextFormField), 'name@samsung.com');
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('회사 이메일 인증 페이지의 뒤로가기는 회사 입력으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: OnboardingRoutes.basicProfileCompanyEmail.fullPath,
      routes: [
        GoRoute(
          name: OnboardingRoutes.basicProfileCompanyEmail.name,
          path: OnboardingRoutes.basicProfileCompanyEmail.fullPath,
          builder: (context, state) => const BasicProfileCompanyEmailPage(),
        ),
        GoRoute(
          name: OnboardingRoutes.basicProfileCompanyName.name,
          path: OnboardingRoutes.basicProfileCompanyName.fullPath,
          builder: (context, state) => const Text('company-name-target'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('company-name-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileCompanyName.fullPath,
    );
  });
}

Widget _testApp() {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        const MockProfileRepository(),
      ),
    ],
    child: EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      saveLocale: false,
      child: MaterialApp(
        theme: Themes.light,
        home: const BasicProfileCompanyEmailPage(),
      ),
    ),
  );
}

Widget _testRouterApp(GoRouter router) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        const MockProfileRepository(),
      ),
    ],
    child: EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.path,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      saveLocale: false,
      child: MaterialApp.router(theme: Themes.light, routerConfig: router),
    ),
  );
}
