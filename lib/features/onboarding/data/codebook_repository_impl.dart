import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/repository/codebook_repository.dart';

/// 코드북 API 실패 예외.
class CodebookApiException implements Exception {
  /// 에러 메시지.
  final String message;

  /// 요청 URI.
  final Uri uri;

  /// HTTP 상태 코드.
  final int? statusCode;

  /// 응답 본문.
  final String? responseBody;

  /// 생성자.
  const CodebookApiException({
    required this.message,
    required this.uri,
    required this.statusCode,
    required this.responseBody,
  });

  @override
  String toString() {
    final buffer = StringBuffer(message)..write('\nuri=$uri');
    if (statusCode != null) {
      buffer.write('\nstatusCode=$statusCode');
    }
    if (responseBody != null && responseBody!.isNotEmpty) {
      buffer.write('\nresponseBody=${_truncate(responseBody!)}');
    }
    return buffer.toString();
  }

  String _truncate(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 400) return trimmed;
    return '${trimmed.substring(0, 400)}...';
  }
}

/// 코드북 Repository HTTP 구현.
class CodebookRepositoryImpl implements CodebookRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  CodebookRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<TermSnapshot> fetchTermsSnapshot() async {
    final decoded = await _getJson(ApiEndpoints.termsSnapshot);
    return TermSnapshot.fromJson(decoded);
  }

  @override
  Future<Map<String, int>> fetchTermsCurrentVersions() async {
    return _getVersionMap(ApiEndpoints.termsCurrentVersions);
  }

  @override
  Future<Map<String, CodeSnapshot>> fetchCodebookSnapshot({
    required List<String> groups,
  }) async {
    final decoded = await _getJson(
      ApiEndpoints.codebookSnapshot,
      queryParameters: {'groups': groups.join(',')},
    );
    return decoded.map(
      (key, value) =>
          MapEntry(key, CodeSnapshot.fromJson(value as Map<String, dynamic>)),
    );
  }

  @override
  Future<Map<String, int>> fetchCodebookCurrentVersions() async {
    return _getVersionMap(ApiEndpoints.codebookCurrentVersions);
  }

  @override
  Future<Map<String, ChoiceQuestionSetSnapshot>> fetchChoiceQuestionSnapshot({
    required List<String> categories,
  }) async {
    final decoded = await _getJson(
      ApiEndpoints.choiceQuestionsSnapshot,
      queryParameters: {'categories': categories.join(',')},
    );
    return decoded.map(
      (key, value) => MapEntry(
        key,
        ChoiceQuestionSetSnapshot.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<Map<String, int>> fetchChoiceQuestionCurrentVersions() async {
    return _getVersionMap(ApiEndpoints.choiceQuestionsCurrentVersions);
  }

  @override
  Future<EssayQuestionSnapshot> fetchEssayQuestionSnapshot() async {
    final decoded = await _getJson(ApiEndpoints.essayQuestionsSnapshot);
    return EssayQuestionSnapshot.fromJson(decoded);
  }

  @override
  Future<CurrentVersionResponse> fetchEssayQuestionCurrentVersion() async {
    final decoded = await _getJson(ApiEndpoints.essayQuestionsCurrentVersions);
    return CurrentVersionResponse.fromJson(decoded);
  }

  Future<Map<String, int>> _getVersionMap(String path) async {
    final decoded = await _getJson(path);
    return decoded.map((key, value) {
      final version = value is num
          ? value.toInt()
          : int.parse(value.toString());
      return MapEntry(key, version);
    });
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: queryParameters);
    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CodebookApiException(
        message: ApiErrorMessages.fetchCodebookFailed,
        uri: uri,
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (error) {
      throw CodebookApiException(
        message:
            '${ApiErrorMessages.fetchCodebookFailed} (invalid json: $error)',
        uri: uri,
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }
}
