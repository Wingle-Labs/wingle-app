import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/mock/mock_question_repository.dart';
import 'package:wingle/features/onboarding/data/question_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/question/question_models.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('MockQuestionRepository', () {
    test('객관식과 주관식 질문을 각각 반환한다', () async {
      final repository = MockQuestionRepository();

      final objectiveQuestions = await repository.fetchQuestions(
        type: QuestionType.objective,
      );
      final subjectiveQuestions = await repository.fetchQuestions(
        type: QuestionType.subjective,
      );

      expect(objectiveQuestions.first.type, QuestionType.objective);
      expect(objectiveQuestions.first.options, isNotNull);
      expect(subjectiveQuestions.first.type, QuestionType.subjective);
      expect(subjectiveQuestions.first.options, isNull);
    });

    test('답변 등록은 완료된다', () async {
      final repository = MockQuestionRepository();

      await repository.submitObjectiveAnswers(
        answers: const ObjectiveQuestionAnswers(
          datingAnswers: [
            ObjectiveQuestionAnswer(questionId: 1, selectedOptionId: 2),
          ],
          lifeStyleAnswers: [
            ObjectiveQuestionAnswer(questionId: 5, selectedOptionId: 3),
          ],
          careerFinanceAnswers: [
            ObjectiveQuestionAnswer(questionId: 11, selectedOptionId: 4),
          ],
          personalityAnswers: [
            ObjectiveQuestionAnswer(questionId: 17, selectedOptionId: 2),
          ],
          familyAnswers: [
            ObjectiveQuestionAnswer(questionId: 23, selectedOptionId: 5),
          ],
        ),
      );

      await repository.submitSubjectiveAnswers(
        answers: const [
          SubjectiveQuestionAnswer(questionId: 1, content: '안녕하세요.'),
        ],
      );
    });
  });

  group('QuestionRepositoryImpl', () {
    test('객관식 질문 목록을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/choice-questions/snapshot');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'QC_LOVE': {
                'version': 1,
                'questions': [
                  {
                    'id': 1,
                    'content': '여름 vs 겨울',
                    'options': [
                      {'id': 1, 'content': '여름'},
                      {'id': 2, 'content': '겨울'},
                    ],
                  },
                ],
              },
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = QuestionRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final questions = await repository.fetchQuestions(
        type: QuestionType.objective,
      );

      expect(questions, hasLength(1));
      expect(questions.first.id, '1');
      expect(questions.first.type, QuestionType.objective);
      expect(questions.first.options, hasLength(2));
      expect(questions.first.options!.first.content, '여름');
    });

    test('주관식 질문 목록을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/essay-questions/snapshot');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'version': 1,
              'questions': [
                {
                  'id': 1,
                  'content': '자신을 소개해주세요.',
                  'isRequire': true,
                  'sortOrder': 1,
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = QuestionRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final questions = await repository.fetchQuestions(
        type: QuestionType.subjective,
      );

      expect(questions, hasLength(1));
      expect(questions.first.id, '1');
      expect(questions.first.type, QuestionType.subjective);
      expect(questions.first.options, isNull);
    });

    test('객관식 질문 답변을 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/choice-questions/answers');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = QuestionRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitObjectiveAnswers(
        answers: const ObjectiveQuestionAnswers(
          datingAnswers: [
            ObjectiveQuestionAnswer(questionId: 1, selectedOptionId: 2),
          ],
          lifeStyleAnswers: [
            ObjectiveQuestionAnswer(questionId: 5, selectedOptionId: 3),
          ],
          careerFinanceAnswers: [
            ObjectiveQuestionAnswer(questionId: 11, selectedOptionId: 4),
          ],
          personalityAnswers: [
            ObjectiveQuestionAnswer(questionId: 17, selectedOptionId: 2),
          ],
          familyAnswers: [
            ObjectiveQuestionAnswer(questionId: 23, selectedOptionId: 5),
          ],
        ),
      );

      expect(body, {
        'answers': [
          {'questionId': 1, 'optionId': 2},
          {'questionId': 5, 'optionId': 3},
          {'questionId': 11, 'optionId': 4},
          {'questionId': 17, 'optionId': 2},
          {'questionId': 23, 'optionId': 5},
        ],
      });
    });

    test('주관식 질문 답변을 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/essay-questions/answers');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = QuestionRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitSubjectiveAnswers(
        answers: const [
          SubjectiveQuestionAnswer(questionId: 1, content: '안녕하세요.'),
        ],
      );

      expect(body, {
        'answers': [
          {'questionId': 1, 'content': '안녕하세요.'},
        ],
      });
    });
  });
}
