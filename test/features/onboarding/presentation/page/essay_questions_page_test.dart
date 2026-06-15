import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/themes.dart';
import 'package:wingle/common/constants/localization_constants.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';
import 'package:wingle/features/onboarding/presentation/page/essay_question_input_page.dart';
import 'package:wingle/features/onboarding/presentation/page/essay_questions_page.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('질문 목록에서 입력 화면으로 이동하고 작성 완료 상태를 표시한 뒤 저장한다', (tester) async {
    _setMobileViewport(tester);
    final router = _essayQuestionsRouter();
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
      _textEither('onboarding.essayQuestions.title', '선택 질문을 작성해보세요'),
      findsOneWidget,
    );
    expect(find.text('나의 성격은 어떤가요?'), findsOneWidget);
    expect(
      _textEither('onboarding.essayQuestions.progress', '작성 완료 0/2'),
      findsOneWidget,
    );

    await tester.tap(find.text('나의 성격은 어떤가요?'));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(find.text('나의 성격은 어떤가요?'), findsOneWidget);
    expect(
      _textEither('onboarding.essayQuestions.inputLabel', '답변'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField), '저는 약속을 중요하게 생각합니다.');
    await tester.pump();
    expect(find.text('18/1000자'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(
      _textEither('onboarding.essayQuestions.progress', '작성 완료 1/2'),
      findsOneWidget,
    );
    expect(
      _textEither('onboarding.essayQuestions.completedBadge', '작성 완료'),
      findsWidgets,
    );
    expect(find.text('저는 약속을 중요하게 생각합니다.'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(answerRepository.savedEssayAnswers.single.map((e) => e.toJson()), [
      {'questionId': 1, 'content': '저는 약속을 중요하게 생각합니다.'},
    ]);
    expect(
      persistence.profileStatus,
      LoginProfileStatus.essayQuestionCompleted,
    );
    expect(find.text('contact-block-target'), findsOneWidget);
  });

  testWidgets('건너뛰기는 빈 답변 저장 API 호출 후 연락처 차단 화면으로 이동한다', (tester) async {
    _setMobileViewport(tester);
    final router = _essayQuestionsRouter();
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

    await tester.tap(_textEither('onboarding.essayQuestions.skip', '건너뛰기'));
    await _pumpAsyncWork(tester);
    await tester.pumpAndSettle();

    expect(answerRepository.savedEssayAnswers.single, isEmpty);
    expect(
      persistence.profileStatus,
      LoginProfileStatus.essayQuestionCompleted,
    );
    expect(find.text('contact-block-target'), findsOneWidget);
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
        const _EssayQuestionsCodebookRepository(),
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

GoRouter _essayQuestionsRouter() {
  return GoRouter(
    initialLocation: OnboardingRoutes.requiredSelfIntro.fullPath,
    routes: [
      GoRoute(
        name: OnboardingRoutes.requiredSelfIntro.name,
        path: OnboardingRoutes.requiredSelfIntro.fullPath,
        builder: (context, state) => const EssayQuestionsPage(),
      ),
      GoRoute(
        name: OnboardingRoutes.essayQuestionInput.name,
        path: '${OnboardingRoutes.essayQuestionInput.fullPath}/:questionId',
        builder: (context, state) => EssayQuestionInputPage(
          questionId:
              int.tryParse(state.pathParameters['questionId'] ?? '') ?? -1,
        ),
      ),
      GoRoute(
        name: OnboardingRoutes.choiceQuestions.name,
        path: OnboardingRoutes.choiceQuestions.fullPath,
        builder: (context, state) => const Text('choice-questions-target'),
      ),
      GoRoute(
        name: OnboardingRoutes.contactBlock.name,
        path: OnboardingRoutes.contactBlock.fullPath,
        builder: (context, state) => const Text('contact-block-target'),
      ),
      GoRoute(
        name: HomeRoutes.root.name,
        path: HomeRoutes.root.path,
        builder: (context, state) => const Text('home-target'),
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

class _EssayQuestionsCodebookRepository implements CodebookRepository {
  const _EssayQuestionsCodebookRepository();

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() async {
    return const EssayQuestionSnapshot(
      version: 1,
      questions: [
        EssayQuestionDetail(
          id: 2,
          content: '주말에는 무엇을 하나요?',
          isRequired: false,
          sortOrder: 2,
        ),
        EssayQuestionDetail(
          id: 1,
          content: '나의 성격은 어떤가요?',
          isRequired: false,
          sortOrder: 1,
        ),
      ],
    );
  }

  @override
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion() async {
    return const CurrentVersionResponse(version: 1);
  }

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    return const {};
  }

  @override
  Future<Map<String, int>> fetchCodebookCurrentVersions() async {
    return const {};
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    return const {};
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return const {};
  }

  @override
  Future<TermSnapshot> fetchTermsSnapshot() async {
    return const TermSnapshot(version: 1, terms: []);
  }

  @override
  Future<Map<String, int>> fetchTermsCurrentVersions() async {
    return const {};
  }
}

class _RecordingAnswerRepository implements AnswerRepository {
  final List<List<EssayAnswerItem>> savedEssayAnswers = [];

  @override
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers() async {
    return const [];
  }

  @override
  Future<void> saveChoiceAnswers({
    required List<ChoiceAnswerItem> answers,
  }) async {}

  @override
  Future<List<EssayAnswerResult>> fetchEssayAnswers() async {
    return const [];
  }

  @override
  Future<void> saveEssayAnswers({
    required List<EssayAnswerItem> answers,
  }) async {
    savedEssayAnswers.add([...answers]);
  }
}

class _MemoryOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  LoginProfileStatus? profileStatus;

  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {
    profileStatus = snapshot.onboardingStatus;
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}
