import 'dart:async';

import 'package:wingle/features/onboarding/domain/model/question/question_models.dart';
import 'package:wingle/features/onboarding/domain/repository/question_repository.dart';

/// 가치관 질문 Repository Mock 구현
class MockQuestionRepository implements QuestionRepository {
  @override
  Future<List<QuestionDto>> fetchQuestions({required QuestionType type}) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));

    switch (type) {
      case QuestionType.objective:
        return [
          QuestionDto(
            id: '1',
            type: QuestionType.objective,
            category: 'love',
            content: '여름 vs 겨울',
            options: [
              QuestionOptionDto(id: 1, order: 1, content: '여름'),
              QuestionOptionDto(id: 2, order: 2, content: '겨울'),
            ],
          ),
        ];
      case QuestionType.subjective:
        return [
          QuestionDto(
            id: '101',
            type: QuestionType.subjective,
            category: null,
            content: '가장 기억에 남는 여행지는 어디인가요?',
            options: null,
          ),
        ];
    }
  }

  @override
  Future<void> submitObjectiveAnswers({
    required ObjectiveQuestionAnswers answers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> submitSubjectiveAnswers({
    required List<SubjectiveQuestionAnswer> answers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
