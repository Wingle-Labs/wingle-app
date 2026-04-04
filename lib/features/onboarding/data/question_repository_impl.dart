import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/model/question/question_models.dart';
import 'package:wingle/features/onboarding/domain/repository/question_repository.dart';

/// 가치관 질문 Repository HTTP 구현
class QuestionRepositoryImpl implements QuestionRepository {
  /// HTTP 클라이언트
  final http.Client _client;

  /// API Base URL
  final String _baseUrl;

  /// 생성자
  QuestionRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<List<QuestionDto>> fetchQuestions({required QuestionType type}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.questions(type.apiValue)}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.fetchQuestionsFailed);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final rawQuestions = decoded['questions'] as List<dynamic>? ?? <dynamic>[];

    return rawQuestions
        .map((e) => QuestionDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> submitObjectiveAnswers({
    required ObjectiveQuestionAnswers answers,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.objectiveQuestionAnswers}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(answers.toJson()),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.submitObjectiveQuestionAnswersFailed);
    }
  }

  @override
  Future<void> submitSubjectiveAnswers({
    required List<SubjectiveQuestionAnswer> answers,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.subjectiveQuestionAnswers}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({'answers': answers.map((e) => e.toJson()).toList()}),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.submitSubjectiveQuestionAnswersFailed);
    }
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
