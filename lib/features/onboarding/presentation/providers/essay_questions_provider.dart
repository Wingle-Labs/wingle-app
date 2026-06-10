import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/models/essay_questions_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

part 'essay_questions_provider.g.dart';

/// 승인 이후 선택 주관식 질문 입력 상태를 관리한다.
@riverpod
class EssayQuestionsController extends _$EssayQuestionsController {
  @override
  Future<EssayQuestionsModel> build() async {
    final codebookRepository = ref.read(codebookRepositoryProvider);
    final answerRepository = ref.read(answerRepositoryProvider);

    final snapshot = await codebookRepository.fetchEssayQuestionSnapshot();
    final existingAnswers = await AsyncValue.guard(
      answerRepository.fetchEssayAnswers,
    );
    final answersByQuestionId = switch (existingAnswers) {
      AsyncData(value: final answers) => {
        for (final answer in answers) answer.questionId: answer.content,
      },
      _ => <int, String>{},
    };

    return EssayQuestionsModel(
      questions: _sortedQuestions(snapshot.questions),
      answersByQuestionId: answersByQuestionId,
    );
  }

  /// 질문 답변을 임시 저장한다.
  void updateAnswer({required int questionId, required String content}) {
    final current = _currentState();
    if (current == null || current.isSubmitting) {
      return;
    }

    state = AsyncData(
      current.updateAnswer(questionId: questionId, content: content),
    );
  }

  /// 작성된 답변을 저장하고 주관식 단계 완료 상태로 전환한다.
  Future<bool> completeWithAnswers() async {
    final current = _currentState();
    if (current == null || current.isSubmitting) {
      return false;
    }

    state = AsyncData(
      current.copyWith(isSubmitting: true, submitErrorMessage: null),
    );

    try {
      final answers = current.toAnswerItems();
      if (answers.isNotEmpty) {
        await ref
            .read(answerRepositoryProvider)
            .saveEssayAnswers(answers: answers);
      }

      await _saveEssayCompletedStatus();

      if (!ref.mounted) {
        return true;
      }

      state = AsyncData(
        current.copyWith(isSubmitting: false, submitErrorMessage: null),
      );
      return true;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = AsyncData(
        current.copyWith(
          isSubmitting: false,
          submitErrorMessage: 'onboarding.essayQuestions.saveFailed',
        ),
      );
      return false;
    }
  }

  /// 답변 저장 없이 주관식 단계를 건너뛴다.
  Future<bool> skip() async {
    final current = _currentState();
    if (current == null || current.isSubmitting) {
      return false;
    }

    state = AsyncData(
      current.copyWith(isSubmitting: true, submitErrorMessage: null),
    );

    try {
      await _saveEssayCompletedStatus();

      if (!ref.mounted) {
        return true;
      }

      state = AsyncData(
        current.copyWith(isSubmitting: false, submitErrorMessage: null),
      );
      return true;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = AsyncData(
        current.copyWith(
          isSubmitting: false,
          submitErrorMessage: 'onboarding.essayQuestions.saveFailed',
        ),
      );
      return false;
    }
  }

  EssayQuestionsModel? _currentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      _ => null,
    };
  }

  Future<void> _saveEssayCompletedStatus() {
    return ref
        .read(onboardingProfileStatusPersistenceProvider)
        .saveProfileStatus(LoginProfileStatus.essayQuestionCompleted);
  }

  List<EssayQuestionDetail> _sortedQuestions(
    List<EssayQuestionDetail> questions,
  ) {
    return [...questions]..sort((a, b) {
      final sortOrderComparison = a.sortOrder.compareTo(b.sortOrder);
      if (sortOrderComparison != 0) {
        return sortOrderComparison;
      }
      return a.id.compareTo(b.id);
    });
  }
}
