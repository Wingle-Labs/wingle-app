import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/app/router/route_node.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/presentation/page/profile_rejected_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('거절 화면은 카테고리별 거절 사유와 수정 버튼을 표시한다', (tester) async {
    _setMobileViewport(tester);
    final repository = _RecordingProfileRepository(
      const RejectionReason(
        reviewedAt: '2026-06-01T12:00:00',
        reasons: [
          RejectionReasonItem(
            code: 'JOB_INFO_MISMATCH',
            categoryDisplayName: '직장',
            description: '직장 정보가 이메일 인증 내용과 일치하지 않습니다.',
          ),
          RejectionReasonItem(
            code: 'SELF_INTRO_ADVERTISEMENT',
            categoryDisplayName: '자기소개',
            description: '광고성 내용이 포함되어 있습니다.',
          ),
        ],
      ),
    );
    final router = _profileRejectedRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(_testApp(router: router, repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('직장'), findsOneWidget);
    expect(find.text('자기소개'), findsOneWidget);
    expect(find.text('직장 정보가 이메일 인증 내용과 일치하지 않습니다.'), findsOneWidget);
    expect(find.text('광고성 내용이 포함되어 있습니다.'), findsOneWidget);
    expect(_textEither('common.button.edit', '수정하기'), findsNWidgets(2));
  });

  for (final scenario in _editRouteScenarios) {
    testWidgets('거절 사유 ${scenario.code} 수정 버튼은 대상 화면으로 이동한다', (tester) async {
      _setMobileViewport(tester);
      final repository = _RecordingProfileRepository(
        RejectionReason(
          reviewedAt: '2026-06-01T12:00:00',
          reasons: [
            RejectionReasonItem(
              code: scenario.code,
              categoryDisplayName: scenario.category,
              description: scenario.description,
            ),
          ],
        ),
      );
      final router = _profileRejectedRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(_testApp(router: router, repository: repository));
      await tester.pumpAndSettle();

      await tester.tap(_textEither('common.button.edit', '수정하기'));
      await tester.pumpAndSettle();

      expect(find.text(scenario.targetText), findsOneWidget);
      expect(
        router.routeInformationProvider.value.uri.path,
        scenario.targetRoute.fullPath,
      );
    });
  }
}

void _setMobileViewport(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(375, 812)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp({
  required GoRouter router,
  required _RecordingProfileRepository repository,
}) {
  return ProviderScope(
    overrides: [profileRepositoryProvider.overrideWithValue(repository)],
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

GoRouter _profileRejectedRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.profileRejected.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.profileRejected.name,
        path: OnboardingRoutes.profileRejected.fullPath,
        builder: (context, state) => const ProfileRejectedPage(),
      ),
      _targetRoute(OnboardingRoutes.basicProfileCompany, 'company-target'),
      _targetRoute(OnboardingRoutes.basicProfileEducation, 'education-target'),
      _targetRoute(OnboardingRoutes.profileDetails, 'details-target'),
      _targetRoute(OnboardingRoutes.profileStylePhotos, 'style-target'),
      _targetRoute(OnboardingRoutes.profileFacePhotos, 'face-target'),
      _targetRoute(
        OnboardingRoutes.profileSelfIntroduction,
        'self-intro-target',
      ),
    ],
  );
}

GoRoute _targetRoute(RouteNode route, String text) {
  return GoRoute(
    name: route.name,
    path: route.fullPath,
    builder: (context, state) => Text(text),
  );
}

Finder _textEither(String key, String translated) {
  return find.byWidgetPredicate((widget) {
    return widget is Text && (widget.data == key || widget.data == translated);
  });
}

const _editRouteScenarios = [
  _EditRouteScenario(
    code: 'JOB_INFO_MISMATCH',
    category: '직장',
    description: '직장 정보가 일치하지 않습니다.',
    targetRoute: OnboardingRoutes.basicProfileCompany,
    targetText: 'company-target',
  ),
  _EditRouteScenario(
    code: 'EDUCATION_INFO_MISMATCH',
    category: '학력',
    description: '학력 정보가 일치하지 않습니다.',
    targetRoute: OnboardingRoutes.basicProfileEducation,
    targetText: 'education-target',
  ),
  _EditRouteScenario(
    code: 'CERTIFICATION_INVALID',
    category: '학력',
    description: '학적 증명서가 유효하지 않습니다.',
    targetRoute: OnboardingRoutes.basicProfileEducation,
    targetText: 'education-target',
  ),
  _EditRouteScenario(
    code: 'SELF_INTRO_ADVERTISEMENT',
    category: '자기소개',
    description: '광고성 내용이 포함되어 있습니다.',
    targetRoute: OnboardingRoutes.profileSelfIntroduction,
    targetText: 'self-intro-target',
  ),
  _EditRouteScenario(
    code: 'STYLE_PHOTO_INAPPROPRIATE',
    category: '스타일 사진',
    description: '부적절한 사진입니다.',
    targetRoute: OnboardingRoutes.profileStylePhotos,
    targetText: 'style-target',
  ),
  _EditRouteScenario(
    code: 'FACE_PHOTO_NOT_VISIBLE',
    category: '얼굴 사진',
    description: '얼굴이 잘 보이지 않습니다.',
    targetRoute: OnboardingRoutes.profileFacePhotos,
    targetText: 'face-target',
  ),
  _EditRouteScenario(
    code: 'OTHER',
    category: '기타',
    description: '기타 사유입니다.',
    targetRoute: OnboardingRoutes.profileDetails,
    targetText: 'details-target',
  ),
];

class _EditRouteScenario {
  final String code;
  final String category;
  final String description;
  final RouteNode targetRoute;
  final String targetText;

  const _EditRouteScenario({
    required this.code,
    required this.category,
    required this.description,
    required this.targetRoute,
    required this.targetText,
  });
}

class _RecordingProfileRepository extends MockProfileRepository {
  final RejectionReason rejectionReason;

  const _RecordingProfileRepository(this.rejectionReason);

  @override
  Future<RejectionReason> fetchRejectionReason() async {
    return rejectionReason;
  }
}
