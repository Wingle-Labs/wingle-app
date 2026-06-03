import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_mbti_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MBTI 선택 전 다음 버튼을 비활성화한다', (tester) async {
    _setMobileViewport(tester);
    await tester.pumpWidget(_testApp());
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.profileDetails.mbtiTitle',
        'MBTI가 뭔가요?',
      ),
      findsOneWidget,
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('MBTI 네 축을 선택하면 로컬 저장 후 다음 체인으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence();
    final router = _mbtiRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router, persistence: persistence));
    await tester.pump();

    for (final letter in ['E', 'S', 'T', 'J']) {
      await tester.tap(find.text(letter));
      await tester.pump();
    }

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(persistence.profile?.mbti, 'ESTJ');
    expect(find.text('style-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileStylePhotos.fullPath,
    );
  });

  testWidgets('MBTI 화면의 앱바 뒤로가기는 학교 정보 입력으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _mbtiRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('education-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileEducation.fullPath,
    );
  });

  testWidgets('MBTI 화면의 시스템 뒤로가기도 학교 정보 입력으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _mbtiRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('education-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.basicProfileEducation.fullPath,
    );
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(375, 812)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp({_MemoryProfileDetailsPersistence? persistence}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
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
        home: const BasicProfileMbtiPage(),
      ),
    ),
  );
}

Widget _testRouterApp(
  GoRouter router, {
  _MemoryProfileDetailsPersistence? persistence,
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryProfileDetailsPersistence(),
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

GoRouter _mbtiRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileDetails.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileDetails.name,
        path: OnboardingRoutes.profileDetails.fullPath,
        builder: (context, state) => const BasicProfileMbtiPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.basicProfileEducation.name,
        path: OnboardingRoutes.basicProfileEducation.fullPath,
        builder: (context, state) => const Text('education-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileStylePhotos.name,
        path: OnboardingRoutes.profileStylePhotos.fullPath,
        builder: (context, state) => const Text('style-photo-target'),
      ),
    ],
  );
}

Future<void> _pumpAsyncWork(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });
  await tester.pump();
}

Finder _textEither(String key, String translated) {
  return find.byWidgetPredicate((widget) {
    return widget is Text && (widget.data == key || widget.data == translated);
  });
}

class _MemoryProfileDetailsPersistence implements ProfileDetailsPersistence {
  LoginProfileDetails? profile;
  LoginProfileStatus? profileStatus;

  @override
  LoginProfileDetails? readProfileDetails() => profile;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {
    this.profile = profile;
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}
