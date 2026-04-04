import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/domain/repository/file_repository.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';

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
    final response = await _client.post(
      Uri.parse(
        '$_baseUrl${ApiEndpoints.profileImagePresign}',
      ).replace(queryParameters: {'contentType': contentType}),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.createProfileImagePresignedUrlFailed);
    }

    return ProfileImagePresignResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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

    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.fileUploadPresign}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(body),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.createUploadPresignFailed);
    }

    return FileUploadPresignResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
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

    final response = await _client.post(
      Uri.parse('$_baseUrl${ApiEndpoints.fileUploadComplete}'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode(body),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.completeUploadFailed);
    }

    return FileUploadCompleteResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<FilePresignedUrlResult> createPresignedUrl({
    required String fileId,
    int expiresIn = FileUploadConstants.defaultPresignedUrlExpiresInSeconds,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl${ApiEndpoints.filePresignedUrl(fileId)}',
      ).replace(queryParameters: {'expiresIn': expiresIn.toString()}),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.createPresignedUrlFailed);
    }

    return FilePresignedUrlResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<FileDeleteResult> deleteFile(String fileId) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl${ApiEndpoints.fileDetail(fileId)}'),
      headers: ApiRequestHeaders.auth(),
    );

    if (!_isSuccess(response)) {
      throw Exception(ApiErrorMessages.deleteFileFailed);
    }

    return FileDeleteResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
