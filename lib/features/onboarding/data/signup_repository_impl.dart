import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/signup_repository.dart';

/// 회원가입 Repository HTTP 구현
class SignupRepositoryImpl implements SignupRepository {
  /// HTTP 클라이언트
  final http.Client _client;

  /// API Base URL
  final String _baseUrl;

  /// 생성자
  SignupRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<void> submitPassword({
    required String uuid,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.signupPassword}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({'password': password, 'UUID': uuid}),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.signupPasswordFailed);
    }
  }

  @override
  Future<void> submitIdentityVerification({
    required String uuid,
    required PortoneVerifiedCustomerDto user,
    required int age,
    required String impUid,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.signupIdentityVerification}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({
        'name': user.name,
        'isForeigner': user.isForeigner,
        'phoneNumber': user.phoneNumber,
        'CI': user.ci,
        'gender': _genderToApiValue(user.gender),
        'UUID': uuid,
        'age': age,
        'impUid': impUid,
      }),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.signupIdentityVerificationFailed);
    }
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  String _genderToApiValue(PassGender? gender) {
    switch (gender) {
      case PassGender.male:
        return '남';
      case PassGender.female:
        return '여';
      case PassGender.other:
        return '기타';
      case null:
        throw Exception(ApiErrorMessages.signupIdentityVerificationFailed);
    }
  }
}
