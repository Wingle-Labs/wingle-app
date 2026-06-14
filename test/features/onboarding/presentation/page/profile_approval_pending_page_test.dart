import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/profile_approval_pending_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('프로필 승인 대기 화면은 안내 문구와 비활성 시작 버튼을 표시한다', (tester) async {
    _setMobileViewport(tester);

    await tester.pumpWidget(_testApp(const ProfileApprovalPendingPage()));
    await tester.pump();

    expect(
      _textEither('onboarding.approvalPending.title', '프로필 신청 완료'),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.approvalPending.subtitle',
        '관리자가 승인 후 가입이 완료됩니다.',
      ),
      findsOneWidget,
    );
    expect(find.byType(Placeholder), findsOneWidget);

    final button = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('승인 대기 상태 refresh 결과가 승인 완료면 승인 완료 안내로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _approvalPendingRouter(
      profileStatus: LoginProfileStatus.profileApproved,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      _testRouterApp(router, profileStatus: LoginProfileStatus.profileApproved),
    );
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('profile-approved-welcome-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileApprovedWelcome.fullPath,
    );
  });

  testWidgets('승인 대기 상태 refresh 결과가 거절이면 거절 사유 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _approvalPendingRouter(
      profileStatus: LoginProfileStatus.profileRejected,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      _testRouterApp(router, profileStatus: LoginProfileStatus.profileRejected),
    );
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('profile-rejected-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.profileRejected.fullPath,
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

Widget _testApp(Widget home) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        const _ImmediateProfileRepository(),
      ),
      onboardingProfileStatusPersistenceProvider.overrideWithValue(
        _MemoryOnboardingProfileStatusPersistence(),
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
  required LoginProfileStatus profileStatus,
}) {
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(
        _ImmediateProfileRepository(
          profileSnapshot: MyProfileSnapshot(onboardingStatus: profileStatus),
        ),
      ),
      onboardingProfileStatusPersistenceProvider.overrideWithValue(
        _MemoryOnboardingProfileStatusPersistence(),
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

GoRouter _approvalPendingRouter({required LoginProfileStatus profileStatus}) {
  return GoRouter(
    initialLocation: OnboardingRoutes.approvalPending.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.approvalPending.name,
        path: OnboardingRoutes.approvalPending.fullPath,
        builder: (context, state) => const ProfileApprovalPendingPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.profileApprovedWelcome.name,
        path: OnboardingRoutes.profileApprovedWelcome.fullPath,
        builder: (context, state) =>
            const Text('profile-approved-welcome-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.profileRejected.name,
        path: OnboardingRoutes.profileRejected.fullPath,
        builder: (context, state) => const Text('profile-rejected-target'),
      ),
    ],
  );
}

Finder _textEither(String key, String translated) {
  return find.byWidgetPredicate((widget) {
    return widget is Text && (widget.data == key || widget.data == translated);
  });
}

Future<void> _pumpAsyncWork(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });
  await tester.pump();
}

class _MemoryOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {}

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {}
}

class _ImmediateProfileRepository extends MockProfileRepository {
  const _ImmediateProfileRepository({super.profileSnapshot});

  @override
  Future<MyProfileSnapshot?> fetchMyProfile() async {
    return profileSnapshot;
  }
}
