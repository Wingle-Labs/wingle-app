import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/choice_questions_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

void main() {
  test('객관식 질문을 카테고리 순서와 questionId 오름차순으로 구성하고 기존 답변을 복원한다', () async {
    final container = ProviderContainer(
      overrides: [
        codebookRepositoryProvider.overrideWithValue(
          _FakeCodebookRepository.withDefaultQuestions(),
        ),
        answerRepositoryProvider.overrideWithValue(
          _FakeAnswerRepository(
            choiceAnswers: const [
              ChoiceAnswerResult(
                questionId: 2,
                questionContent: '연애 질문 2',
                optionId: 20,
                optionContent: '선택지 2-2',
              ),
            ],
          ),
        ),
        onboardingProfileStatusPersistenceProvider.overrideWithValue(
          _MemoryOnboardingProfileStatusPersistence(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(
      choiceQuestionsControllerProvider.future,
    );

    expect(state.totalQuestionCount, 3);
    expect(state.questions.map((question) => question.id), [1, 2, 16]);
    expect(state.selectedOptionIds, {2: 20});
    expect(state.selectedQuestionCount, 1);
    expect(state.isComplete, isFalse);
  });

  test('모든 객관식 답변을 저장하면 선택 완료 상태를 로컬에 반영한다', () async {
    final answerRepository = _FakeAnswerRepository();
    final persistence = _MemoryOnboardingProfileStatusPersistence();
    final container = ProviderContainer(
      overrides: [
        codebookRepositoryProvider.overrideWithValue(
          _FakeCodebookRepository.withDefaultQuestions(),
        ),
        answerRepositoryProvider.overrideWithValue(answerRepository),
        onboardingProfileStatusPersistenceProvider.overrideWithValue(
          persistence,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(choiceQuestionsControllerProvider.future);
    final notifier = container.read(choiceQuestionsControllerProvider.notifier);
    notifier.selectOption(questionId: 1, optionId: 10);
    notifier.selectOption(questionId: 2, optionId: 20);
    notifier.selectOption(questionId: 16, optionId: 160);

    final submitted = await notifier.submit();

    expect(submitted, isTrue);
    expect(answerRepository.savedChoiceAnswers.single.map((e) => e.toJson()), [
      {'questionId': 1, 'optionId': 10},
      {'questionId': 2, 'optionId': 20},
      {'questionId': 16, 'optionId': 160},
    ]);
    expect(
      persistence.profileStatus,
      LoginProfileStatus.choiceQuestionCompleted,
    );
  });
}

class _FakeCodebookRepository implements CodebookRepository {
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshots;

  const _FakeCodebookRepository({required this.choiceSnapshots});

  factory _FakeCodebookRepository.withDefaultQuestions() {
    return const _FakeCodebookRepository(
      choiceSnapshots: {
        'QC_LOVE': ChoiceQuestionSetSnapshot(
          version: 1,
          questions: [
            ChoiceQuestionDetail(
              id: 2,
              content: '연애 질문 2',
              options: [
                ChoiceQuestionOption(id: 20, content: '선택지 2-2'),
                ChoiceQuestionOption(id: 21, content: '선택지 2-3'),
              ],
            ),
            ChoiceQuestionDetail(
              id: 1,
              content: '연애 질문 1',
              options: [
                ChoiceQuestionOption(id: 10, content: '선택지 1-1'),
                ChoiceQuestionOption(id: 11, content: '선택지 1-2'),
              ],
            ),
          ],
        ),
        'QC_LIFE': ChoiceQuestionSetSnapshot(
          version: 1,
          questions: [
            ChoiceQuestionDetail(
              id: 16,
              content: '생활 질문 1',
              options: [
                ChoiceQuestionOption(id: 160, content: '선택지 16-1'),
                ChoiceQuestionOption(id: 161, content: '선택지 16-2'),
              ],
            ),
          ],
        ),
      },
    );
  }

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    return {
      if (groups.contains(CodebookGroup.questionCategory.code))
        CodebookGroup.questionCategory.code: const CodeSnapshot(
          version: 1,
          codes: [
            CommonCodeDetail(code: 'QC_LOVE', codeName: '연애', displayOrder: 1),
            CommonCodeDetail(code: 'QC_LIFE', codeName: '생활', displayOrder: 2),
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
        category:
            choiceSnapshots[category] ??
            const ChoiceQuestionSetSnapshot(version: 1, questions: []),
    };
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return const {'QC_LOVE': 1, 'QC_LIFE': 1};
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

class _FakeAnswerRepository implements AnswerRepository {
  final List<ChoiceAnswerResult> choiceAnswers;
  final List<List<ChoiceAnswerItem>> savedChoiceAnswers =
      <List<ChoiceAnswerItem>>[];

  _FakeAnswerRepository({this.choiceAnswers = const []});

  @override
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers() async {
    return choiceAnswers;
  }

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
