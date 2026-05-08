import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/auth/data/dto/login_response_dto.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/domain/models/auth_token.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/domain/repositories/login_repository.dart';

/// 로그인 Repository HTTP 구현
class LoginRepositoryImpl implements LoginRepository {
  final http.Client _client;
  final String _baseUrl;

  /// 생성자
  LoginRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<LoginResult> login({
    required PhoneNumber phoneNumber,
    required Password password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.authLogin}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phoneNumber.apiValue,
        'password': password.value,
      }),
    );

    if (response.statusCode == 401) {
      throw const AuthException(ApiErrorMessages.invalidLoginCredentials);
    }

    if (response.statusCode != 200) {
      throw const AuthException(ApiErrorMessages.loginFailed);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final dto = LoginResponseDto.fromJson(decoded);

    if (dto.accessToken.isEmpty || dto.refreshToken.isEmpty) {
      throw const AuthException(ApiErrorMessages.loginFailed);
    }

    return dto.toDomain();
  }

  @override
  Future<void> logout() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.authLogout}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const AuthException(ApiErrorMessages.logoutFailed);
    }
  }

  @override
  Future<AuthToken> reissue({required String refreshToken}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.authReissue}'),
      headers: {ApiRequestHeaders.authorizationHeader: refreshToken},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const AuthException(ApiErrorMessages.reissueFailed);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final token = AuthToken.fromJson(decoded);

    if (token.accessToken.isEmpty || token.refreshToken.isEmpty) {
      throw const AuthException(ApiErrorMessages.reissueFailed);
    }

    return token;
  }
}
