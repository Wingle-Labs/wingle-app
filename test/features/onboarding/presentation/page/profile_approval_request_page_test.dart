import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/profile_approval_request_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_details_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('프로필 심사 요청 페이지는 자동 요청 성공 후 승인 대기로 이동한다', (tester) async {
    final router = _router();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileDetailsPersistence();
    final repository = _RecordingProfileRepository();

    await tester.pumpWidget(
      _testApp(router, persistence: persistence, repository: repository),
    );
    await tester.pump();
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(repository.didRequestProfileApproval, isTrue);
    expect(persistence.profileStatus, LoginProfileStatus.awaitingApproval);
    expect(find.text('approval-pending-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.approvalPending.fullPath,
    );
  });
}

GoRouter _router() {
  return GoRouter(
    initialLocation: OnboardingRoutes.approvalRequest.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.approvalRequest.name,
        path: OnboardingRoutes.approvalRequest.fullPath,
        builder: (context, state) => const ProfileApprovalRequestPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.approvalPending.name,
        path: OnboardingRoutes.approvalPending.fullPath,
        builder: (context, state) => const Text('approval-pending-target'),
      ),
    ],
  );
}

Widget _testApp(
  GoRouter router, {
  required _MemoryProfileDetailsPersistence persistence,
  required _RecordingProfileRepository repository,
}) {
  return ProviderScope(
    overrides: [
      profileDetailsPersistenceProvider.overrideWithValue(persistence),
      profileRepositoryProvider.overrideWithValue(repository),
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

Future<void> _pumpAsyncWork(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });
  await tester.pump();
}

class _MemoryProfileDetailsPersistence implements ProfileDetailsPersistence {
  LoginProfileStatus? profileStatus;

  @override
  LoginProfileDetails? readProfileDetails() => null;

  @override
  Future<void> saveProfileDetails(LoginProfileDetails? profile) async {}

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}

class _RecordingProfileRepository extends MockProfileRepository {
  bool didRequestProfileApproval = false;

  @override
  Future<void> requestProfileApproval() async {
    didRequestProfileApproval = true;
  }
}
