import 'package:wingle/features/onboarding/domain/model/question/question_models.dart';

/// 가치관 질문/답변 Repository 인터페이스.
abstract class QuestionRepository {
  /// 질문 목록을 조회한다.
  Future<List<QuestionDto>> fetchQuestions({required QuestionType type});

  /// 객관식 질문 답변을 등록한다.
  Future<void> submitObjectiveAnswers({
    required ObjectiveQuestionAnswers answers,
  });

  /// 주관식 질문 답변을 등록한다.
  Future<void> submitSubjectiveAnswers({
    required List<SubjectiveQuestionAnswer> answers,
  });
}
