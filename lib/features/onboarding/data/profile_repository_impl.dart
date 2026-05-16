import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

/// 프로필 Repository HTTP 구현
class ProfileRepositoryImpl implements ProfileRepository {
  /// HTTP 클라이언트
  final http.Client _client;

  /// API Base URL
  final String _baseUrl;

  /// 생성자
  ProfileRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<String> fetchRandomNickname() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.signupNicknameRandom}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.fetchRandomNicknameFailed);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final nickname = decoded['nickname']?.toString() ?? '';

    if (nickname.isEmpty) {
      throw Exception(ApiErrorMessages.fetchRandomNicknameFailed);
    }

    return nickname;
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  }) async {
    await _postJson(
      path: ApiEndpoints.signupProfile,
      body: {
        'nickname': nickname,
        'residenceCode': residence.level3,
        'height': height,
        'bodyTypeCode': bodyType,
      },
      errorMessage: ApiErrorMessages.submitBasicProfileFailed,
    );
  }

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  }) async {
    await _postJson(
      path: ApiEndpoints.profileDetail,
      body: {
        'mbti': mbti,
        'selfIntroduction': selfIntroduction,
        if (mainStylePhotoKey != null) 'mainStylePhotoKey': mainStylePhotoKey,
        'subStylePhotoKeys': subStylePhotoKeys,
        if (mainFacePhotoKey != null) 'mainFacePhotoKey': mainFacePhotoKey,
        'subFacePhotoKeys': subFacePhotoKeys,
      },
      errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
    );
  }

  @override
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  }) async {
    await _postJson(
      path: ApiEndpoints.profileEducation,
      body: {
        'educationLevel': educationLevel,
        if (university != null && university.trim().isNotEmpty)
          'university': university,
      },
      errorMessage: ApiErrorMessages.submitEducationFailed,
    );
  }

  @override
  Future<void> verifyEducationEmail({required String email}) async {
    await _postJson(
      path: ApiEndpoints.profileEducationEmailVerifications,
      body: {'email': email},
      errorMessage: ApiErrorMessages.verifyEducationEmailFailed,
    );
  }

  @override
  Future<void> submitJob({
    required String company,
    required String occupation,
  }) async {
    await _postJson(
      path: ApiEndpoints.profileJob,
      body: {'company': company, 'occupation': occupation},
      errorMessage: ApiErrorMessages.submitJobFailed,
    );
  }

  @override
  Future<void> verifyJobEmail({required String email}) async {
    await _postJson(
      path: ApiEndpoints.profileJobEmailVerifications,
      body: {'email': email},
      errorMessage: ApiErrorMessages.verifyJobEmailFailed,
    );
  }

  @override
  Future<void> confirmEducationEmail({
    required String email,
    required int verificationCode,
  }) async {
    await _postJson(
      path: ApiEndpoints.profileEducationEmailVerificationsConfirm,
      body: {'email': email, 'verificationCode': verificationCode},
      errorMessage: ApiErrorMessages.verifyEducationEmailFailed,
    );
  }

  @override
  Future<void> confirmJobEmail({
    required String email,
    required int verificationCode,
  }) async {
    await _postJson(
      path: ApiEndpoints.profileJobEmailVerificationsConfirm,
      body: {'email': email, 'verificationCode': verificationCode},
      errorMessage: ApiErrorMessages.verifyJobEmailFailed,
    );
  }

  @override
  Future<void> requestProfileApproval() async {
    await _postJson(
      path: ApiEndpoints.profileApprovalRequest,
      body: const <String, dynamic>{},
      errorMessage: ApiErrorMessages.requestProfileApprovalFailed,
    );
  }

  @override
  Future<void> requestProfileReapply() async {
    await _postJson(
      path: ApiEndpoints.profileReapply,
      body: const <String, dynamic>{},
      errorMessage: ApiErrorMessages.requestProfileReapplyFailed,
    );
  }

  @override
  Future<RejectionReason> fetchRejectionReason() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.profileRejectionReason}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.fetchRejectionReasonFailed);
    }

    return RejectionReason.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> _postJson({
    required String path,
    required Map<String, dynamic> body,
    required String errorMessage,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(body),
    );

    if (!_isSuccess(response)) {
      throw Exception(errorMessage);
    }
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
