import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// 필수 객관식 질문 카테고리 표시 모델.
class ChoiceQuestionCategorySection {
  /// 카테고리 코드.
  final String code;

  /// 카테고리명.
  final String title;

  /// 카테고리에 속한 질문 목록.
  final List<ChoiceQuestionDetail> questions;

  /// 생성자.
  const ChoiceQuestionCategorySection({
    required this.code,
    required this.title,
    required this.questions,
  });
}

/// 필수 객관식 질문 화면 상태.
class ChoiceQuestionsModel {
  /// 카테고리별 질문 섹션.
  final List<ChoiceQuestionCategorySection> sections;

  /// questionId -> optionId 선택 상태.
  final Map<int, int> selectedOptionIds;

  /// 제출 중 여부.
  final bool isSubmitting;

  /// 제출 실패 메시지.
  final String? submitErrorMessage;

  /// 생성자.
  const ChoiceQuestionsModel({
    required this.sections,
    required this.selectedOptionIds,
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// 전체 질문 수.
  int get totalQuestionCount =>
      sections.fold<int>(0, (sum, section) => sum + section.questions.length);

  /// 선택 완료한 질문 수.
  int get selectedQuestionCount => questions
      .where((question) => selectedOptionIds.containsKey(question.id))
      .length;

  /// 모든 질문을 선택했는지 여부.
  bool get isComplete =>
      totalQuestionCount > 0 && selectedQuestionCount == totalQuestionCount;

  /// 제출 가능 여부.
  bool get canSubmit => isComplete && !isSubmitting;

  /// 모든 질문을 순서대로 펼친 목록.
  List<ChoiceQuestionDetail> get questions => [
    for (final section in sections) ...section.questions,
  ];

  /// 서버 저장 payload로 변환한다.
  List<ChoiceAnswerItem> toAnswerItems() {
    return [
      for (final question in questions)
        if (selectedOptionIds[question.id] case final optionId?)
          ChoiceAnswerItem(questionId: question.id, optionId: optionId),
    ];
  }

  /// 특정 질문의 선택지를 변경한 새 상태를 반환한다.
  ChoiceQuestionsModel selectOption({
    required int questionId,
    required int optionId,
  }) {
    return copyWith(
      selectedOptionIds: {...selectedOptionIds, questionId: optionId},
      submitErrorMessage: null,
    );
  }

  /// 변경된 상태 복사본을 생성한다.
  ChoiceQuestionsModel copyWith({
    List<ChoiceQuestionCategorySection>? sections,
    Map<int, int>? selectedOptionIds,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return ChoiceQuestionsModel(
      sections: sections ?? this.sections,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
    );
  }
}
