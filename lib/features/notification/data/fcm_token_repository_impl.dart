import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_error_response.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

/// FCM 디바이스 토큰 등록 API 구현체.
class FcmTokenRepositoryImpl implements FcmTokenRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자.
  FcmTokenRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<void> registerToken({required String token}) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      throw Exception(ApiErrorMessages.registerFcmTokenFailed);
    }

    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.notificationToken}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({'token': normalizedToken}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.registerFcmTokenFailed,
      );
    }
  }
}
