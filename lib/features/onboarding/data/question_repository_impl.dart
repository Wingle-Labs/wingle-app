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
    final uri = switch (type) {
      QuestionType.objective =>
        Uri.parse('$_baseUrl${ApiEndpoints.choiceQuestionsSnapshot}').replace(
          queryParameters: {
            'categories': [
              'QC_LOVE',
              'QC_LIFE',
              'QC_CAREER',
              'QC_PERSONALITY',
              'QC_FAMILY',
            ],
          },
        ),
      QuestionType.subjective => Uri.parse(
        '$_baseUrl${ApiEndpoints.essayQuestionsSnapshot}',
      ),
    };

    final response = await _client.get(uri, headers: ApiRequestHeaders.auth());

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.fetchQuestionsFailed);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return switch (type) {
      QuestionType.objective => _parseObjectiveQuestions(decoded),
      QuestionType.subjective => _parseSubjectiveQuestions(decoded),
    };
  }

  @override
  Future<void> submitObjectiveAnswers({
    required ObjectiveQuestionAnswers answers,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.choiceQuestionAnswers}'),
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
      Uri.parse('$_baseUrl${ApiEndpoints.essayQuestionAnswers}'),
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

  List<QuestionDto> _parseObjectiveQuestions(Map<String, dynamic> decoded) {
    final snapshots = decoded.values.whereType<Map<String, dynamic>>();
    return snapshots.expand((snapshot) {
      final rawQuestions =
          snapshot['questions'] as List<dynamic>? ?? <dynamic>[];
      return rawQuestions.map((e) {
        final json = e as Map<String, dynamic>;
        final rawOptions = json['options'] as List<dynamic>? ?? <dynamic>[];
        return QuestionDto(
          id: json['id']?.toString() ?? '',
          type: QuestionType.objective,
          category: null,
          content: json['content']?.toString() ?? '',
          options: rawOptions.asMap().entries.map((entry) {
            final option = entry.value as Map<String, dynamic>;
            return QuestionOptionDto(
              id: (option['id'] as num?)?.toInt() ?? 0,
              order: entry.key + 1,
              content: option['content']?.toString() ?? '',
            );
          }).toList(),
        );
      });
    }).toList();
  }

  List<QuestionDto> _parseSubjectiveQuestions(Map<String, dynamic> decoded) {
    final rawQuestions = decoded['questions'] as List<dynamic>? ?? <dynamic>[];
    return rawQuestions.map((e) {
      final json = e as Map<String, dynamic>;
      return QuestionDto(
        id: json['id']?.toString() ?? '',
        type: QuestionType.subjective,
        category: null,
        content: json['content']?.toString() ?? '',
        options: null,
      );
    }).toList();
  }
}
