import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_company_page.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_occupation_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_codebook_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('직종 선택 페이지의 뒤로가기는 체형 입력으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: OnboardingRoutes.basicProfileCompany.fullPath,
      routes: [
        GoRoute(
          name: OnboardingRoutes.basicProfileCompany.name,
          path: OnboardingRoutes.basicProfileCompany.fullPath,
          builder: (context, state) => const BasicProfileOccupationPage(),
        ),
        GoRoute(
          name: OnboardingRoutes.basicProfileBodyShape.name,
          path: OnboardingRoutes.basicProfileBodyShape.fullPath,
          builder: (context, state) => const Text('body-shape-target'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_testApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('body-shape-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileBodyShape.fullPath,
    );
  });

  testWidgets('직종 선택 페이지는 무직을 최상위 항목으로 표시한다', (tester) async {
    final router = GoRouter(
      initialLocation: OnboardingRoutes.basicProfileCompany.fullPath,
      routes: [
        GoRoute(
          name: OnboardingRoutes.basicProfileCompany.name,
          path: OnboardingRoutes.basicProfileCompany.fullPath,
          builder: (context, state) => const BasicProfileOccupationPage(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_testApp(router));
    await tester.pump();

    expect(find.text('무직'), findsOneWidget);
    expect(find.text('일반'), findsOneWidget);
  });

  testWidgets('회사 입력 페이지의 뒤로가기는 직종 선택으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: OnboardingRoutes.basicProfileCompanyName.fullPath,
      routes: [
        GoRoute(
          name: OnboardingRoutes.basicProfileCompanyName.name,
          path: OnboardingRoutes.basicProfileCompanyName.fullPath,
          builder: (context, state) => const BasicProfileCompanyPage(),
        ),
        GoRoute(
          name: OnboardingRoutes.basicProfileCompany.name,
          path: OnboardingRoutes.basicProfileCompany.fullPath,
          builder: (context, state) => const Text('occupation-target'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(_testApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('occupation-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileCompany.fullPath,
    );
  });
}

Widget _testApp(GoRouter router) {
  return EasyLocalization(
    supportedLocales: AppLocalization.supportedLocales,
    path: AppLocalization.path,
    fallbackLocale: AppLocalization.fallbackLocale,
    startLocale: AppLocalization.fallbackLocale,
    saveLocale: false,
    child: ProviderScope(
      overrides: [
        jobCodebookTreeProvider.overrideWithValue(_jobTree()),
        profileRepositoryProvider.overrideWithValue(
          const MockProfileRepository(),
        ),
      ],
      child: MaterialApp.router(theme: Themes.light, routerConfig: router),
    ),
  );
}

JobCodebookTree _jobTree() {
  return buildJobCodebookTree(
    const CodebookSnapshot(
      version: 1,
      codes: [
        CodebookEntry(
          code: 'J1',
          codeName: '일반',
          parentCode: null,
          displayOrder: 0,
        ),
        CodebookEntry(
          code: 'J101',
          codeName: '무직',
          parentCode: 'J1',
          displayOrder: 0,
        ),
        CodebookEntry(
          code: 'J103',
          codeName: '사무직',
          parentCode: 'J1',
          displayOrder: 0,
        ),
      ],
    ),
  );
}
