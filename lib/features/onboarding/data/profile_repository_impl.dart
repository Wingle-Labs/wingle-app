import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_error_response.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
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
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.fetchRandomNicknameFailed,
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final nickname = decoded['nickname']?.toString() ?? '';

    if (nickname.isEmpty) {
      throw Exception(ApiErrorMessages.fetchRandomNicknameFailed);
    }

    return nickname;
  }

  @override
  Future<MyProfileSnapshot?> fetchMyProfile() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl${ApiEndpoints.meProfile}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.fetchMyProfileFailed,
      );
    }

    final decoded = _decodeResponseBody(response.body);
    final profileJson = _extractProfileJson(decoded);
    if (profileJson == null) {
      return null;
    }

    final snapshot = MyProfileSnapshot.fromJson(profileJson);
    return snapshot.hasAnyValue ? snapshot : null;
  }

  @override
  Future<LoginBasicProfile?> fetchMyBasicProfile() async {
    final snapshot = await fetchMyProfile();
    return snapshot?.basicProfile;
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    await _postJson(
      path: ApiEndpoints.signupProfile,
      body: _basicProfileBody(
        nickname: nickname,
        residence: residence,
        height: height,
        bodyTypeCode: bodyTypeCode,
      ),
      errorMessage: ApiErrorMessages.submitBasicProfileFailed,
    );
  }

  @override
  Future<void> updateBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    await _putJson(
      path: ApiEndpoints.userProfile,
      body: _basicProfileBody(
        nickname: nickname,
        residence: residence,
        height: height,
        bodyTypeCode: bodyTypeCode,
      ),
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
      body: _profileDetailsBody(
        mbti: mbti,
        selfIntroduction: selfIntroduction,
        mainStylePhotoKey: mainStylePhotoKey,
        subStylePhotoKeys: subStylePhotoKeys,
        mainFacePhotoKey: mainFacePhotoKey,
        subFacePhotoKeys: subFacePhotoKeys,
      ),
      errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
    );
  }

  @override
  Future<void> updateProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  }) async {
    await _putJson(
      path: ApiEndpoints.profileDetailReapply,
      body: _profileDetailsBody(
        mbti: mbti,
        selfIntroduction: selfIntroduction,
        mainStylePhotoKey: mainStylePhotoKey,
        subStylePhotoKeys: subStylePhotoKeys,
        mainFacePhotoKey: mainFacePhotoKey,
        subFacePhotoKeys: subFacePhotoKeys,
      ),
      errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
    );
  }

  @override
  Future<void> submitEducation({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) async {
    await _postJson(
      path: ApiEndpoints.profileEducation,
      body: _educationProfileBody(
        university: university,
        customUniversityName: customUniversityName,
        educationLevel: educationLevel,
      ),
      errorMessage: ApiErrorMessages.submitEducationFailed,
    );
  }

  @override
  Future<void> updateEducation({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) async {
    await _putJson(
      path: ApiEndpoints.profileEducationReapply,
      body: _educationProfileBody(
        university: university,
        customUniversityName: customUniversityName,
        educationLevel: educationLevel,
      ),
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
  Future<void> submitJob({String? company, required String occupation}) async {
    await _postJson(
      path: ApiEndpoints.profileJob,
      body: _jobProfileBody(company: company, occupation: occupation),
      errorMessage: ApiErrorMessages.submitJobFailed,
    );
  }

  @override
  Future<void> updateJob({String? company, required String occupation}) async {
    await _putJson(
      path: ApiEndpoints.profileJobReapply,
      body: _jobProfileBody(company: company, occupation: occupation),
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
  Future<void> submitEducationCertification({
    required String certificationKey,
  }) async {
    final key = _requiredS3Key(
      certificationKey,
      directory: 'certification',
      errorMessage: ApiErrorMessages.submitEducationCertificationFailed,
    );

    await _postJson(
      path: ApiEndpoints.profileEducationCertification,
      body: {'certificationKey': key},
      errorMessage: ApiErrorMessages.submitEducationCertificationFailed,
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
    await _postEmpty(
      path: ApiEndpoints.profileApprovalRequest,
      errorMessage: ApiErrorMessages.requestProfileApprovalFailed,
    );
  }

  @override
  Future<void> requestProfileReapply() async {
    await _postEmpty(
      path: ApiEndpoints.profileReapply,
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
      throw apiExceptionFromResponse(
        response,
        fallbackMessage: ApiErrorMessages.fetchRejectionReasonFailed,
      );
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
      throw apiExceptionFromResponse(response, fallbackMessage: errorMessage);
    }
  }

  Future<void> _putJson({
    required String path,
    required Map<String, dynamic> body,
    required String errorMessage,
  }) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl$path'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(body),
    );

    if (!_isSuccess(response)) {
      throw apiExceptionFromResponse(response, fallbackMessage: errorMessage);
    }
  }

  Future<void> _postEmpty({
    required String path,
    required String errorMessage,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw apiExceptionFromResponse(response, fallbackMessage: errorMessage);
    }
  }

  Map<String, dynamic> _basicProfileBody({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) {
    return {
      'nickname': nickname,
      'residenceCode': residence.level3,
      'height': height,
      'bodyTypeCode': bodyTypeCode,
    };
  }

  Map<String, dynamic> _jobProfileBody({
    required String? company,
    required String occupation,
  }) {
    final normalizedCompany = company?.trim();

    return {
      'company': normalizedCompany == null || normalizedCompany.isEmpty
          ? null
          : normalizedCompany,
      'occupation': occupation,
    };
  }

  Map<String, dynamic> _profileDetailsBody({
    required String mbti,
    required String selfIntroduction,
    required String? mainStylePhotoKey,
    required List<String> subStylePhotoKeys,
    required String? mainFacePhotoKey,
    required List<String> subFacePhotoKeys,
  }) {
    final normalizedMainStylePhotoKey = _optionalS3Key(
      mainStylePhotoKey,
      directory: 'style',
      errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
    );
    final normalizedSubStylePhotoKeys = subStylePhotoKeys
        .map(
          (key) => _requiredS3Key(
            key,
            directory: 'style',
            errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
          ),
        )
        .toList(growable: false);
    final normalizedMainFacePhotoKey = _optionalS3Key(
      mainFacePhotoKey,
      directory: 'face',
      errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
    );
    final normalizedSubFacePhotoKeys = subFacePhotoKeys
        .map(
          (key) => _requiredS3Key(
            key,
            directory: 'face',
            errorMessage: ApiErrorMessages.submitProfileDetailsFailed,
          ),
        )
        .toList(growable: false);

    return {
      'mbti': mbti,
      'selfIntroduction': selfIntroduction,
      if (normalizedMainStylePhotoKey != null)
        'mainStylePhotoKey': normalizedMainStylePhotoKey,
      'subStylePhotoKeys': normalizedSubStylePhotoKeys,
      if (normalizedMainFacePhotoKey != null)
        'mainFacePhotoKey': normalizedMainFacePhotoKey,
      'subFacePhotoKeys': normalizedSubFacePhotoKeys,
    };
  }

  Map<String, dynamic> _educationProfileBody({
    required String? university,
    required String? customUniversityName,
    required String educationLevel,
  }) {
    final normalizedUniversity = university?.trim();
    final normalizedCustomUniversityName = customUniversityName?.trim();
    final hasUniversity =
        normalizedUniversity != null && normalizedUniversity.isNotEmpty;
    final hasCustomUniversityName =
        normalizedCustomUniversityName != null &&
        normalizedCustomUniversityName.isNotEmpty;

    if (hasUniversity == hasCustomUniversityName) {
      throw Exception(ApiErrorMessages.submitEducationFailed);
    }

    return {
      'educationLevel': educationLevel,
      if (hasUniversity)
        'university': normalizedUniversity
      else
        'customUniversityName': normalizedCustomUniversityName,
    };
  }

  String? _optionalS3Key(
    String? value, {
    required String directory,
    required String errorMessage,
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return _requiredS3Key(
      trimmed,
      directory: directory,
      errorMessage: errorMessage,
    );
  }

  String _requiredS3Key(
    String value, {
    required String directory,
    required String errorMessage,
  }) {
    final trimmed = value.trim();
    final pattern = RegExp('^users/[0-9]+/$directory/.+');
    if (!pattern.hasMatch(trimmed) ||
        Uri.tryParse(trimmed)?.hasScheme == true) {
      throw Exception(errorMessage);
    }

    return trimmed;
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Object? _decodeResponseBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }
    return jsonDecode(body);
  }

  Map<String, dynamic>? _extractProfileJson(Object? decoded) {
    if (decoded is! Map) {
      return null;
    }

    final json = decoded.map((key, value) => MapEntry(key.toString(), value));
    final candidates = <Object?>[
      json,
      json['data'],
      json['profile'],
      json['basicProfile'],
      json['basic_profile'],
    ];

    for (final candidate in candidates) {
      final profileJson = _asStringKeyedMap(candidate);
      if (profileJson == null) continue;
      if (_hasProfileField(profileJson)) {
        return profileJson;
      }
    }

    return null;
  }

  Map<String, dynamic>? _asStringKeyedMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  bool _hasProfileField(Map<String, dynamic> json) {
    return json.containsKey('nickname') ||
        json.containsKey('residenceCode') ||
        json.containsKey('residence_code') ||
        json.containsKey('height') ||
        json.containsKey('bodyTypeCode') ||
        json.containsKey('body_type_code') ||
        json.containsKey('onboardingStatus') ||
        json.containsKey('onboarding_status') ||
        json.containsKey('job') ||
        json.containsKey('education') ||
        json.containsKey('mbti') ||
        json.containsKey('selfIntroduction') ||
        json.containsKey('self_introduction');
  }
}
