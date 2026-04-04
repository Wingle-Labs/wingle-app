import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/file_repository_impl.dart';
import 'package:wingle/features/onboarding/data/mock/mock_file_repository.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('MockFileRepository', () {
    test('모든 파일 관련 API가 완료된다', () async {
      final repository = MockFileRepository();

      final profileImage = await repository.createProfileImagePresignedUrl();
      final uploadPresign = await repository.createUploadPresign(
        fileName: 'profile.jpg',
        contentType: 'image/jpeg',
        size: 345678,
        purpose: 'PROFILE_IMAGE',
      );
      final completed = await repository.completeUpload(
        uploadId: uploadPresign.uploadId,
        key: uploadPresign.key,
        etag: '"etag"',
        size: 345678,
      );
      final downloadUrl = await repository.createPresignedUrl(
        fileId: completed.fileId,
      );
      final deleted = await repository.deleteFile(completed.fileId);

      expect(profileImage, isA<ProfileImagePresignResult>());
      expect(uploadPresign.method, 'PUT');
      expect(completed.status, 'UPLOADED');
      expect(downloadUrl.fileId, completed.fileId);
      expect(deleted.status, 'SOFT_DELETED');
    });
  });

  group('FileRepositoryImpl', () {
    test('프로필 이미지 presigned url을 발급한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/files/presigned/profile');
        expect(request.url.queryParameters['contentType'], 'image/png');
        return http.Response(
          jsonEncode({
            'presigned_url': 'https://mock-upload.example.com/profile.png',
            's3_key': 'users/1/profile/original/profile.png',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createProfileImagePresignedUrl(
        contentType: 'image/png',
      );

      expect(
        result.presignedUrl,
        'https://mock-upload.example.com/profile.png',
      );
      expect(result.s3Key, 'users/1/profile/original/profile.png');
    });

    test('프로필 이미지 presigned url 기본 contentType을 사용한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/files/presigned/profile');
        expect(
          request.url.queryParameters['contentType'],
          FileUploadConstants.defaultProfileImageContentType,
        );
        return http.Response(
          jsonEncode({
            'presigned_url': 'https://mock-upload.example.com/profile.jpg',
            's3_key': 'users/1/profile/original/profile.jpg',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createProfileImagePresignedUrl();

      expect(
        result.presignedUrl,
        'https://mock-upload.example.com/profile.jpg',
      );
    });

    test('업로드 url을 발급한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/files/uploads/presign');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'uploadId': 'up_01',
            'method': 'PUT',
            'uploadUrl': 'https://mock-upload.example.com/up_01',
            'headers': {'Content-Type': 'image/jpeg'},
            'key': 'users/1/profile/original/profile.jpg',
            'expiresAt': '2026-02-02T10:20:00+09:00',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createUploadPresign(
        fileName: 'profile.jpg',
        contentType: 'image/jpeg',
        size: 345678,
        purpose: 'PROFILE_IMAGE',
        checksum: 'checksum-123',
      );

      expect(body, {
        'fileName': 'profile.jpg',
        'contentType': 'image/jpeg',
        'size': 345678,
        'purpose': 'PROFILE_IMAGE',
        'checksum': 'checksum-123',
      });
      expect(result.uploadId, 'up_01');
      expect(result.method, 'PUT');
      expect(result.headers, {'Content-Type': 'image/jpeg'});
    });

    test('업로드 완료를 통지한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/files/uploads/complete');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'fileId': 'file_01',
            'status': 'UPLOADED',
            'key': 'users/1/profile/original/profile.jpg',
            'createdAt': '2026-02-02T09:50:12+09:00',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.completeUpload(
        uploadId: 'up_01',
        key: 'users/1/profile/original/profile.jpg',
        etag: '"etag"',
        size: 345678,
        contentType: 'image/jpeg',
      );

      expect(body, {
        'uploadId': 'up_01',
        'key': 'users/1/profile/original/profile.jpg',
        'etag': '"etag"',
        'size': 345678,
        'contentType': 'image/jpeg',
      });
      expect(result.fileId, 'file_01');
      expect(result.status, 'UPLOADED');
    });

    test('이미지 조회용 presigned url을 발급한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/files/file_01/presigned-url');
        expect(request.url.queryParameters['expiresIn'], '120');
        return http.Response(
          jsonEncode({
            'fileId': 'file_01',
            'url': 'https://mock-download.example.com/file_01',
            'expiresAt': '2026-02-02T09:55:00+09:00',
            'contentType': 'image/jpeg',
            'size': 345678,
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createPresignedUrl(
        fileId: 'file_01',
        expiresIn: 120,
      );

      expect(result.fileId, 'file_01');
      expect(result.url, 'https://mock-download.example.com/file_01');
      expect(result.size, 345678);
    });

    test('이미지 조회용 presigned url 기본 만료 시간을 사용한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/files/file_01/presigned-url');
        expect(
          request.url.queryParameters['expiresIn'],
          FileUploadConstants.defaultPresignedUrlExpiresInSeconds.toString(),
        );
        return http.Response(
          jsonEncode({
            'fileId': 'file_01',
            'url': 'https://mock-download.example.com/file_01',
            'expiresAt': '2026-02-02T09:55:00+09:00',
            'contentType': 'image/jpeg',
            'size': 345678,
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createPresignedUrl(fileId: 'file_01');

      expect(result.fileId, 'file_01');
      expect(result.url, 'https://mock-download.example.com/file_01');
    });

    test('파일을 삭제한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/v1/files/file_01');
        return http.Response(
          jsonEncode({
            'fileId': 'file_01',
            'status': 'SOFT_DELETED',
            'deletedAt': '2026-02-02T10:05:12+09:00',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.deleteFile('file_01');

      expect(result.fileId, 'file_01');
      expect(result.status, 'SOFT_DELETED');
      expect(result.deletedAt, '2026-02-02T10:05:12+09:00');
    });
  });
}
