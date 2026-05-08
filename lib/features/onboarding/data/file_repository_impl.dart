import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/domain/repository/file_repository.dart';

/// 파일 Repository HTTP 구현
class FileRepositoryImpl implements FileRepository {
  /// HTTP 클라이언트
  final http.Client _client;

  /// API Base URL
  final String _baseUrl;

  /// 생성자
  FileRepositoryImpl({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  @override
  Future<ProfileImagePresignResult> createProfileImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) async {
    return createStyleImagePresignedUrl(contentType: contentType);
  }

  @override
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl${ApiEndpoints.styleImagePresign}',
      ).replace(queryParameters: {'contentType': contentType}),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.createProfileImagePresignedUrlFailed);
    }

    final result = ProfileImagePresignResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    return _validateProfileImagePresignResult(result);
  }

  @override
  Future<ProfileImagePresignResult> createFaceImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl${ApiEndpoints.faceImagePresign}',
      ).replace(queryParameters: {'contentType': contentType}),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.createProfileImagePresignedUrlFailed);
    }

    final result = ProfileImagePresignResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );

    return _validateProfileImagePresignResult(result);
  }

  @override
  Future<FileUploadPresignResult> createUploadPresign({
    required String fileName,
    required String contentType,
    required int size,
    required String purpose,
    String? checksum,
  }) async {
    final body = {
      'fileName': fileName,
      'contentType': contentType,
      'size': size,
      'purpose': purpose,
      if (checksum != null) 'checksum': checksum,
    };

    body;
    throw UnsupportedError('Swagger 명세에 없는 파일 업로드 API입니다.');
  }

  @override
  Future<FileUploadCompleteResult> completeUpload({
    required String uploadId,
    required String key,
    required String etag,
    required int size,
    String? contentType,
  }) async {
    final body = {
      'uploadId': uploadId,
      'key': key,
      'etag': etag,
      'size': size,
      if (contentType != null) 'contentType': contentType,
    };

    body;
    throw UnsupportedError('Swagger 명세에 없는 파일 업로드 완료 API입니다.');
  }

  @override
  Future<FilePresignedUrlResult> createPresignedUrl({
    required String fileId,
    int expiresIn = FileUploadConstants.defaultPresignedUrlExpiresInSeconds,
  }) async {
    expiresIn;
    throw UnsupportedError('Swagger 명세에 없는 파일 조회 API입니다.');
  }

  @override
  Future<FileDeleteResult> deleteFile(String fileId) async {
    throw UnsupportedError('Swagger 명세에 없는 파일 삭제 API입니다.');
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  ProfileImagePresignResult _validateProfileImagePresignResult(
    ProfileImagePresignResult result,
  ) {
    if (result.presignedUrl.isEmpty || result.s3Key.isEmpty) {
      throw Exception(ApiErrorMessages.createProfileImagePresignedUrlFailed);
    }

    return result;
  }
}
