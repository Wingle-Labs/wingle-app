import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/features/onboarding/presentation/page/onboarding_status_placeholder_page.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('학교 정보 placeholder 앱바 뒤로가기는 직종 선택으로 이동한다', (tester) async {
    final router = _schoolPlaceholderRouter();
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

  testWidgets('학교 정보 placeholder 시스템 뒤로가기는 직종 선택으로 이동한다', (tester) async {
    final router = _schoolPlaceholderRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testApp(router));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('occupation-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileCompany.fullPath,
    );
  });
}

GoRouter _schoolPlaceholderRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.basicProfileEducation.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.basicProfileEducation.name,
        path: OnboardingRoutes.basicProfileEducation.fullPath,
        builder: (context, state) => const OnboardingStatusPlaceholderPage(
          title: '학교 정보 입력',
          description: '학교 정보와 학교 이메일 인증 화면을 연결할 단계입니다.',
          status: 'JOB_INFO_COMPLETED',
          routeFlow: OnboardingRouteFlow.profileInput,
          currentRoute: OnboardingRoutes.basicProfileEducation,
        ),
      ),
      GoRoute(
        name: OnboardingRoutes.basicProfileCompany.name,
        path: OnboardingRoutes.basicProfileCompany.fullPath,
        builder: (context, state) => const Text('occupation-target'),
      ),
    ],
  );
}

Widget _testApp(GoRouter router) {
  return MaterialApp.router(theme: Themes.light, routerConfig: router);
}
