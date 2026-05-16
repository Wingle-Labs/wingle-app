import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/answer_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('AnswerRepositoryImpl', () {
    test('객관식 답변을 저장한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/choice-questions/answers');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = AnswerRepositoryImpl(client: client, baseUrl: baseUrl);

      await repository.saveChoiceAnswers(
        answers: const [ChoiceAnswerItem(questionId: 1, optionId: 2)],
      );

      expect(body, {
        'answers': [
          {'questionId': 1, 'optionId': 2},
        ],
      });
    });

    test('빈 객관식 답변은 저장하지 않는다', () async {
      final client = MockClient((request) async {
        fail('empty answer request should not hit network');
      });
      final repository = AnswerRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(
        () => repository.saveChoiceAnswers(answers: const <ChoiceAnswerItem>[]),
        throwsException,
      );
    });

    test('빈 주관식 답변은 저장하지 않는다', () async {
      final client = MockClient((request) async {
        fail('empty answer request should not hit network');
      });
      final repository = AnswerRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(
        () => repository.saveEssayAnswers(answers: const <EssayAnswerItem>[]),
        throwsException,
      );
    });

    test('주관식 답변을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/essay-questions/answers');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'answers': [
                {
                  'questionId': 1,
                  'questionContent': '자신을 소개해주세요.',
                  'isRequire': true,
                  'content': '안녕하세요.',
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = AnswerRepositoryImpl(client: client, baseUrl: baseUrl);

      final answers = await repository.fetchEssayAnswers();

      expect(answers.single.content, '안녕하세요.');
    });
  });
}
