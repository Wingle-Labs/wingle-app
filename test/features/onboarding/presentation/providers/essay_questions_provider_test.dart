import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/essay_questions_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

void main() {
  group('EssayQuestionsController', () {
    test('snapshot 질문을 sortOrder 기준으로 정렬하고 기존 답변을 복원한다', () async {
      final container = _container(
        answerRepository: _RecordingAnswerRepository(
          essayAnswers: const [
            EssayAnswerResult(
              questionId: 2,
              questionContent: '주말에는 무엇을 하나요?',
              isRequired: false,
              content: '전시를 봅니다.',
            ),
          ],
        ),
      );
      addTearDown(container.dispose);

      final state = await container.read(
        essayQuestionsControllerProvider.future,
      );

      expect(state.questions.map((question) => question.id), [1, 2, 3]);
      expect(state.completedQuestionCount, 1);
      expect(state.answerOf(2), '전시를 봅니다.');
    });

    test('답변이 있으면 저장 API를 호출하고 주관식 완료 상태를 저장한다', () async {
      final answerRepository = _RecordingAnswerRepository();
      final persistence = _MemoryOnboardingProfileStatusPersistence();
      final container = _container(
        answerRepository: answerRepository,
        persistence: persistence,
      );
      addTearDown(container.dispose);

      await container.read(essayQuestionsControllerProvider.future);
      final notifier = container.read(
        essayQuestionsControllerProvider.notifier,
      );

      final validAnswer = List.filled(15, '저는 약속을 중요하게 생각합니다. ').join();
      notifier.updateAnswer(questionId: 1, content: validAnswer);
      notifier.updateAnswer(questionId: 2, content: '   ');

      final success = await notifier.completeWithAnswers();

      expect(success, isTrue);
      expect(answerRepository.savedEssayAnswers.single.map((e) => e.toJson()), [
        {'questionId': 1, 'content': validAnswer.trim()},
      ]);
      expect(
        persistence.profileStatus,
        LoginProfileStatus.essayQuestionCompleted,
      );
    });

    test('작성한 답변 없이 건너뛰면 저장 API 호출 없이 주관식 단계를 완료한다', () async {
      final answerRepository = _RecordingAnswerRepository();
      final persistence = _MemoryOnboardingProfileStatusPersistence();
      final container = _container(
        answerRepository: answerRepository,
        persistence: persistence,
      );
      addTearDown(container.dispose);

      await container.read(essayQuestionsControllerProvider.future);
      final success = await container
          .read(essayQuestionsControllerProvider.notifier)
          .skip();

      expect(success, isTrue);
      expect(answerRepository.savedEssayAnswers, isEmpty);
      expect(
        persistence.profileStatus,
        LoginProfileStatus.essayQuestionCompleted,
      );
    });

    test('200자 미만 주관식 답변은 저장하지 않는다', () async {
      final answerRepository = _RecordingAnswerRepository();
      final persistence = _MemoryOnboardingProfileStatusPersistence();
      final container = _container(
        answerRepository: answerRepository,
        persistence: persistence,
      );
      addTearDown(container.dispose);

      await container.read(essayQuestionsControllerProvider.future);
      final notifier = container.read(
        essayQuestionsControllerProvider.notifier,
      );

      notifier.updateAnswer(questionId: 1, content: '짧은 답변입니다.');

      final success = await notifier.completeWithAnswers();

      expect(success, isFalse);
      expect(answerRepository.savedEssayAnswers, isEmpty);
      expect(persistence.profileStatus, isNull);
    });
  });
}

ProviderContainer _container({
  _RecordingAnswerRepository? answerRepository,
  _MemoryOnboardingProfileStatusPersistence? persistence,
}) {
  return ProviderContainer(
    overrides: [
      codebookRepositoryProvider.overrideWithValue(
        const _EssayQuestionsCodebookRepository(),
      ),
      answerRepositoryProvider.overrideWithValue(
        answerRepository ?? _RecordingAnswerRepository(),
      ),
      onboardingProfileStatusPersistenceProvider.overrideWithValue(
        persistence ?? _MemoryOnboardingProfileStatusPersistence(),
      ),
    ],
  );
}

class _EssayQuestionsCodebookRepository implements CodebookRepository {
  const _EssayQuestionsCodebookRepository();

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() async {
    return const EssayQuestionSnapshot(
      version: 1,
      questions: [
        EssayQuestionDetail(
          id: 3,
          content: '최근 인상 깊었던 콘텐츠는?',
          isRequired: false,
          sortOrder: 3,
        ),
        EssayQuestionDetail(
          id: 1,
          content: '나의 성격은 어떤가요?',
          isRequired: false,
          sortOrder: 1,
        ),
        EssayQuestionDetail(
          id: 2,
          content: '주말에는 무엇을 하나요?',
          isRequired: false,
          sortOrder: 2,
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
  final List<EssayAnswerResult> essayAnswers;
  final List<List<EssayAnswerItem>> savedEssayAnswers = [];

  _RecordingAnswerRepository({this.essayAnswers = const []});

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
    return essayAnswers;
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
