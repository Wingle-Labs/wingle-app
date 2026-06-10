import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/choice_questions_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('필수 객관식 질문 선택 수를 표시하고 저장 성공 시 다음 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _choiceQuestionsRouter();
    addTearDown(router.dispose);
    final answerRepository = _RecordingAnswerRepository();
    final persistence = _MemoryOnboardingProfileStatusPersistence();

    await tester.pumpWidget(
      _testApp(
        router,
        answerRepository: answerRepository,
        persistence: persistence,
      ),
    );
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(
      _textEither(
        'onboarding.choiceQuestions.title',
        '아래는 필수 입력 문항입니다.',
      ),
      findsOneWidget,
    );
    expect(find.text('술을 자주 드시나요?'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);

    await tester.tap(find.text('안 마신다'));
    await tester.pump();
    expect(find.text('1/2'), findsOneWidget);

    await tester.tap(find.text('비흡연'));
    await tester.pump();
    expect(find.text('2/2'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(answerRepository.savedChoiceAnswers.single.map((e) => e.toJson()), [
      {'questionId': 16, 'optionId': 41},
      {'questionId': 17, 'optionId': 45},
    ]);
    expect(
      persistence.profileStatus,
      LoginProfileStatus.choiceQuestionCompleted,
    );
    expect(find.text('required-self-intro-target'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      OnboardingRoutes.requiredSelfIntro.fullPath,
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
  required _RecordingAnswerRepository answerRepository,
  required _MemoryOnboardingProfileStatusPersistence persistence,
}) {
  return ProviderScope(
    overrides: [
      codebookRepositoryProvider.overrideWithValue(
        const _ChoiceQuestionsCodebookRepository(),
      ),
      answerRepositoryProvider.overrideWithValue(answerRepository),
      onboardingProfileStatusPersistenceProvider.overrideWithValue(persistence),
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

GoRouter _choiceQuestionsRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.choiceQuestions.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.choiceQuestions.name,
        path: OnboardingRoutes.choiceQuestions.fullPath,
        builder: (context, state) => const ChoiceQuestionsPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.approvalPending.name,
        path: OnboardingRoutes.approvalPending.fullPath,
        builder: (context, state) => const Text('approval-pending-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.requiredSelfIntro.name,
        path: OnboardingRoutes.requiredSelfIntro.fullPath,
        builder: (context, state) => const Text('required-self-intro-target'),
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

class _ChoiceQuestionsCodebookRepository implements CodebookRepository {
  const _ChoiceQuestionsCodebookRepository();

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    return {
      if (groups.contains(CodebookGroup.questionCategory.code))
        CodebookGroup.questionCategory.code: const CodeSnapshot(
          version: 1,
          codes: [
            CommonCodeDetail(code: 'QC_LIFE', codeName: '생활', displayOrder: 1),
          ],
        ),
    };
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    return {
      for (final category in categories)
        category: category == 'QC_LIFE'
            ? const ChoiceQuestionSetSnapshot(
                version: 1,
                questions: [
                  ChoiceQuestionDetail(
                    id: 16,
                    content: '술을 자주 드시나요?',
                    options: [
                      ChoiceQuestionOption(id: 39, content: '자주 마신다'),
                      ChoiceQuestionOption(id: 41, content: '안 마신다'),
                    ],
                  ),
                  ChoiceQuestionDetail(
                    id: 17,
                    content: '흡연을 하시나요?',
                    options: [
                      ChoiceQuestionOption(id: 42, content: '흡연'),
                      ChoiceQuestionOption(id: 45, content: '비흡연'),
                    ],
                  ),
                ],
              )
            : const ChoiceQuestionSetSnapshot(version: 1, questions: []),
    };
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return const {'QC_LIFE': 1};
  }

  @override
  Future<Map<String, int>> fetchCodebookCurrentVersions() async => const {};

  @override
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion() async {
    return const CurrentVersionResponse(version: 1);
  }

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() async {
    return const EssayQuestionSnapshot(version: 1, questions: []);
  }

  @override
  Future<Map<String, int>> fetchTermsCurrentVersions() async => const {};

  @override
  Future<TermSnapshot> fetchTermsSnapshot() async {
    return const TermSnapshot(version: 1, terms: []);
  }
}

class _RecordingAnswerRepository implements AnswerRepository {
  final List<List<ChoiceAnswerItem>> savedChoiceAnswers =
      <List<ChoiceAnswerItem>>[];

  @override
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers() async => const [];

  @override
  Future<void> saveChoiceAnswers({
    required List<ChoiceAnswerItem> answers,
  }) async {
    savedChoiceAnswers.add(List.unmodifiable(answers));
  }

  @override
  Future<List<EssayAnswerResult>> fetchEssayAnswers() async => const [];

  @override
  Future<void> saveEssayAnswers({
    required List<EssayAnswerItem> answers,
  }) async {}
}

class _MemoryOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  LoginProfileStatus? profileStatus;

  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {}

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}
