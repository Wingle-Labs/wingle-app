import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/model/answer/answer_models.dart';
import 'package:wingle/features/onboarding/domain/repository/answer_repository.dart';

/// 답변 Repository HTTP 구현.
class AnswerRepositoryImpl implements AnswerRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  AnswerRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<List<ChoiceAnswerResult>> fetchChoiceAnswers() async {
    final decoded = await _getJson(ApiEndpoints.choiceQuestionAnswers);
    final rawAnswers = decoded['answers'] as List<dynamic>? ?? <dynamic>[];
    return rawAnswers
        .map((e) => ChoiceAnswerResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveChoiceAnswers({required List<ChoiceAnswerItem> answers}) {
    if (answers.isEmpty) {
      throw Exception(ApiErrorMessages.submitAnswersFailed);
    }

    return _postJson(ApiEndpoints.choiceQuestionAnswers, {
      'answers': answers.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<List<EssayAnswerResult>> fetchEssayAnswers() async {
    final decoded = await _getJson(ApiEndpoints.essayQuestionAnswers);
    final rawAnswers = decoded['answers'] as List<dynamic>? ?? <dynamic>[];
    return rawAnswers
        .map((e) => EssayAnswerResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveEssayAnswers({required List<EssayAnswerItem> answers}) {
    return _postJson(ApiEndpoints.essayQuestionAnswers, {
      'answers': answers.map((e) => e.toJson()).toList(),
    });
  }

  Future<Map<String, dynamic>> _getJson(String path) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl$path'),
      headers: ApiRequestHeaders.auth(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(ApiErrorMessages.fetchAnswersFailed);
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _postJson(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(ApiErrorMessages.submitAnswersFailed);
    }
  }
}
