import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/models/choice_questions_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/answer_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';

part 'choice_questions_provider.g.dart';

const List<String> _choiceQuestionCategoryCodes = [
  'QC_LOVE',
  'QC_LIFE',
  'QC_CAREER',
  'QC_PERSONALITY',
  'QC_FAMILY',
];

const Map<String, String> _fallbackCategoryTitles = {
  'QC_LOVE': '연애',
  'QC_LIFE': '생활',
  'QC_CAREER': '커리어/경제',
  'QC_PERSONALITY': '성격/MBTI',
  'QC_FAMILY': '가족/결혼관',
};

/// 승인 이후 필수 객관식 질문 입력 상태를 관리한다.
@riverpod
class ChoiceQuestionsController extends _$ChoiceQuestionsController {
  @override
  Future<ChoiceQuestionsModel> build() async {
    final codebookRepository = ref.read(codebookRepositoryProvider);
    final answerRepository = ref.read(answerRepositoryProvider);

    final categoryTitles = await _fetchCategoryTitles();
    final snapshots = await codebookRepository.fetchChoiceQuestionSnapshot(
      categories: _choiceQuestionCategoryCodes,
    );
    final existingAnswers = await AsyncValue.guard(
      answerRepository.fetchChoiceAnswers,
    );
    final selectedOptionIds = switch (existingAnswers) {
      AsyncData(value: final answers) => {
        for (final answer in answers) answer.questionId: answer.optionId,
      },
      _ => <int, int>{},
    };

    return ChoiceQuestionsModel(
      sections: [
        for (final categoryCode in _choiceQuestionCategoryCodes)
          if (snapshots[categoryCode] case final snapshot?)
            ChoiceQuestionCategorySection(
              code: categoryCode,
              title:
                  categoryTitles[categoryCode] ??
                  _fallbackCategoryTitles[categoryCode] ??
                  categoryCode,
              questions: _sortedQuestions(snapshot.questions),
            ),
      ],
      selectedOptionIds: selectedOptionIds,
    );
  }

  /// 질문 선택지를 선택한다.
  void selectOption({required int questionId, required int optionId}) {
    final current = _currentState();
    if (current == null || current.isSubmitting) {
      return;
    }

    state = AsyncData(
      current.selectOption(questionId: questionId, optionId: optionId),
    );
  }

  /// 선택한 객관식 답변을 저장한다.
  Future<bool> submit() async {
    final current = _currentState();
    if (current == null || !current.canSubmit) {
      return false;
    }

    state = AsyncData(
      current.copyWith(isSubmitting: true, submitErrorMessage: null),
    );

    try {
      await ref
          .read(answerRepositoryProvider)
          .saveChoiceAnswers(answers: current.toAnswerItems());
      await ref
          .read(onboardingProfileStatusPersistenceProvider)
          .saveProfileStatus(LoginProfileStatus.choiceQuestionCompleted);

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
          submitErrorMessage: ApiErrorMessages.submitAnswersFailed,
        ),
      );
      return false;
    }
  }

  ChoiceQuestionsModel? _currentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      _ => null,
    };
  }

  Future<Map<String, String>> _fetchCategoryTitles() async {
    final result = await AsyncValue.guard(() {
      return ref
          .read(codebookRepositoryProvider)
          .fetchCodebookSnapshot(groups: [CodebookGroup.questionCategory.code]);
    });

    return switch (result) {
      AsyncData(value: final snapshots) => {
        for (final code
            in snapshots[CodebookGroup.questionCategory.code]?.codes ??
                const <CommonCodeDetail>[])
          code.code: code.codeName,
      },
      _ => const <String, String>{},
    };
  }

  List<ChoiceQuestionDetail> _sortedQuestions(
    List<ChoiceQuestionDetail> questions,
  ) {
    return [...questions]..sort((a, b) => a.id.compareTo(b.id));
  }
}
