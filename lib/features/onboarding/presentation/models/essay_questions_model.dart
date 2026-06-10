import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';

/// 승인 이후 선택 주관식 질문 화면 상태.
class EssayQuestionsModel {
  /// 주관식 질문 목록.
  final List<EssayQuestionDetail> questions;

  /// questionId -> answer content 입력 상태.
  final Map<int, String> answersByQuestionId;

  /// 제출 중 여부.
  final bool isSubmitting;

  /// 제출 실패 메시지.
  final String? submitErrorMessage;

  /// 생성자.
  const EssayQuestionsModel({
    required this.questions,
    required this.answersByQuestionId,
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// 답변 최대 글자 수.
  static const int answerMaxLength = 1000;

  /// 전체 질문 수.
  int get totalQuestionCount => questions.length;

  /// 작성 완료한 질문 수.
  int get completedQuestionCount =>
      questions.where((question) => hasAnswer(question.id)).length;

  /// 하나 이상의 답변을 작성했는지 여부.
  bool get hasAnyAnswer => completedQuestionCount > 0;

  /// 특정 질문에 답변이 있는지 확인한다.
  bool hasAnswer(int questionId) =>
      (answersByQuestionId[questionId] ?? '').trim().isNotEmpty;

  /// 특정 질문의 답변을 반환한다.
  String answerOf(int questionId) => answersByQuestionId[questionId] ?? '';

  /// 질문 ID로 질문을 찾는다.
  EssayQuestionDetail? questionById(int questionId) {
    for (final question in questions) {
      if (question.id == questionId) {
        return question;
      }
    }
    return null;
  }

  /// 서버 저장 payload로 변환한다.
  List<EssayAnswerItem> toAnswerItems() {
    return [
      for (final question in questions)
        if (answersByQuestionId[question.id]?.trim() case final content?
            when content.isNotEmpty)
          EssayAnswerItem(questionId: question.id, content: content),
    ];
  }

  /// 특정 질문의 답변을 변경한 새 상태를 반환한다.
  EssayQuestionsModel updateAnswer({
    required int questionId,
    required String content,
  }) {
    final normalizedContent = content.length > answerMaxLength
        ? content.substring(0, answerMaxLength)
        : content;

    return copyWith(
      answersByQuestionId: {
        ...answersByQuestionId,
        questionId: normalizedContent,
      },
      submitErrorMessage: null,
    );
  }

  /// 변경된 상태 복사본을 생성한다.
  EssayQuestionsModel copyWith({
    List<EssayQuestionDetail>? questions,
    Map<int, String>? answersByQuestionId,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return EssayQuestionsModel(
      questions: questions ?? this.questions,
      answersByQuestionId: answersByQuestionId ?? this.answersByQuestionId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
    );
  }
}
