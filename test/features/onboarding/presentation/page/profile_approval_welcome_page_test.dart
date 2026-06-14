import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/presentation/page/profile_approval_welcome_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_approval_welcome_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('승인 완료 안내 화면은 닉네임과 시작하기 버튼을 표시한다', (tester) async {
    _setMobileViewport(tester);
    final router = _approvalWelcomeRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileApprovalWelcomePersistence(
      nickname: '고요한 새벽 공기',
    );

    await tester.pumpWidget(_testApp(router, persistence: persistence));
    await tester.pumpAndSettle();

    expect(
      _textEither(
        'onboarding.profileApprovedWelcome.title',
        '고요한 새벽 공기님!\n회원가입 승인이 완료되었어요.',
      ),
      findsOneWidget,
    );
    expect(
      _textEither(
        'onboarding.profileApprovedWelcome.subtitle',
        '윙글에서 새로운 인연을 만나길 바라요',
      ),
      findsOneWidget,
    );
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('시작하기는 승인 완료 안내 확인 상태를 저장하고 객관식 질문으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _approvalWelcomeRouter();
    addTearDown(router.dispose);
    final persistence = _MemoryProfileApprovalWelcomePersistence(
      nickname: '고요한 새벽 공기',
    );

    await tester.pumpWidget(_testApp(router, persistence: persistence));
    await tester.pumpAndSettle();

    await tester.tap(
      _textEither('onboarding.profileApprovedWelcome.start', '시작하기'),
    );
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(persistence.markSeenCount, 1);
    expect(find.text('choice-questions-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.choiceQuestions.fullPath,
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

Widget _testApp(
  GoRouter router, {
  required _MemoryProfileApprovalWelcomePersistence persistence,
}) {
  return ProviderScope(
    overrides: [
      profileApprovalWelcomePersistenceProvider.overrideWithValue(persistence),
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

GoRouter _approvalWelcomeRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileApprovedWelcome.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileApprovedWelcome.name,
        path: OnboardingRoutes.profileApprovedWelcome.fullPath,
        builder: (context, state) => const ProfileApprovalWelcomePage(),
      ),
      GoRoute(
        name: OnboardingRoutes.choiceQuestions.name,
        path: OnboardingRoutes.choiceQuestions.fullPath,
        builder: (context, state) => const Text('choice-questions-target'),
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

class _MemoryProfileApprovalWelcomePersistence
    implements ProfileApprovalWelcomePersistence {
  final String nickname;
  int markSeenCount = 0;

  _MemoryProfileApprovalWelcomePersistence({required this.nickname});

  @override
  String readNickname() {
    return nickname;
  }

  @override
  Future<void> markSeen() async {
    markSeenCount += 1;
  }
}
