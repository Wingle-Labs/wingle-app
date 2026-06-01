import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/onboarding/presentation/page/basic_profile_photo_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('스타일 사진 등록 전에는 다음 버튼을 비활성화한다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(_testApp(home: const BasicProfileStylePhotoPage()));
    await tester.pump();

    expect(
      _textEither(
        'onboarding.basicProfile.profilePhoto.styleTitle',
        '본인의 스타일이 잘 보이는 사진을\n최소 1장 이상 등록해주세요',
      ),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.profilePhoto.styleLabel', '스타일'),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.basicProfile.profilePhoto.guide', '사진 등록 가이드'),
      findsOneWidget,
    );

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('스타일 사진을 드래그하면 첫 번째 사진을 대표 사진으로 저장한다', (tester) async {
    _setMobileViewport(tester);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(
        mainStylePhotoKey: 'users/1/style/main.jpg',
        subStylePhotoKeys: ['users/1/style/sub.jpg'],
      ),
    );

    await tester.pumpWidget(
      _testApp(
        home: const BasicProfileStylePhotoPage(),
        persistence: persistence,
      ),
    );
    await tester.pump();

    final checkIcons = find.byIcon(Icons.check_rounded);
    expect(checkIcons, findsNWidgets(2));

    final gesture = await tester.startGesture(
      tester.getCenter(checkIcons.at(1)),
    );
    await tester.pump(const Duration(milliseconds: 700));
    await gesture.moveTo(tester.getCenter(checkIcons.first));
    await tester.pump();
    await gesture.up();
    await _pumpAsyncWork(tester);

    expect(persistence.profile?.mainStylePhotoKey, 'users/1/style/sub.jpg');
    expect(persistence.profile?.subStylePhotoKeys, ['users/1/style/main.jpg']);
  });

  testWidgets('스타일 사진 화면의 앱바 뒤로가기는 MBTI 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _styleRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testRouterApp(router));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('mbti-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileDetails.fullPath,
    );
  });

  testWidgets('스타일 사진 저장 후 다음 체인으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _styleRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(mainStylePhotoKey: 'users/1/style/main.jpg'),
    );

    await tester.pumpWidget(_testRouterApp(router, persistence: persistence));
    await tester.pump();

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('face-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileFacePhotos.fullPath,
    );
  });

  testWidgets('얼굴 사진 화면의 뒤로가기와 다음 체인을 따른다', (tester) async {
    _setMobileViewport(tester);
    final router = _faceRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence(
      const LoginProfileDetails(mainFacePhotoKey: 'users/1/face/main.jpg'),
    );

    await tester.pumpWidget(_testRouterApp(router, persistence: persistence));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('style-photo-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileStylePhotos.fullPath,
    );

    router.goNamed(OnboardingRoutes.profileFacePhotos.name);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('approval-request-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.approvalRequest.fullPath,
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

Widget _testApp({
  required Widget home,
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
      child: MaterialApp(theme: Themes.light, home: home),
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

GoRouter _styleRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileStylePhotos.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileStylePhotos.name,
        path: OnboardingRoutes.profileStylePhotos.fullPath,
        builder: (context, state) => const BasicProfileStylePhotoPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileDetails.name,
        path: OnboardingRoutes.profileDetails.fullPath,
        builder: (context, state) => const Text('mbti-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileFacePhotos.name,
        path: OnboardingRoutes.profileFacePhotos.fullPath,
        builder: (context, state) => const Text('face-photo-target'),
      ),
    ],
  );
}

GoRouter _faceRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileFacePhotos.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileFacePhotos.name,
        path: OnboardingRoutes.profileFacePhotos.fullPath,
        builder: (context, state) => const BasicProfileFacePhotoPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileStylePhotos.name,
        path: OnboardingRoutes.profileStylePhotos.fullPath,
        builder: (context, state) => const Text('style-photo-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.approvalRequest.name,
        path: OnboardingRoutes.approvalRequest.fullPath,
        builder: (context, state) => const Text('approval-request-target'),
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

  _MemoryProfileDetailsPersistence([this.profile]);

  @override
  LoginProfileDetails? readProfileDetails() => profile;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {
    this.profile = profile;
  }
}
