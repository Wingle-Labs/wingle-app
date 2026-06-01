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
      final certification = await repository.createCertificationPresignedUrl();
      await repository.uploadBytesToPresignedUrl(
        presignedUrl: certification.presignedUrl,
        bytes: const [1, 2, 3],
        contentType: 'image/jpeg',
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
      expect(certification.s3Key, contains('/certification/'));
      expect(uploadPresign.method, 'PUT');
      expect(completed.status, 'UPLOADED');
      expect(downloadUrl.fileId, completed.fileId);
      expect(deleted.status, 'SOFT_DELETED');
    });
  });

  group('FileRepositoryImpl', () {
    test('프로필 이미지 presigned url을 발급한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/files/presigned/style');
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
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/files/presigned/style');
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

    test('학적 증명서 presigned url을 발급한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/files/presigned/certification');
        expect(request.url.queryParameters['contentType'], 'image/webp');
        return http.Response(
          jsonEncode({
            'presignedUrl':
                'https://mock-upload.example.com/certification.webp',
            's3Key': 'users/1/certification/certification.webp',
          }),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.createCertificationPresignedUrl(
        contentType: 'image/webp',
      );

      expect(
        result.presignedUrl,
        'https://mock-upload.example.com/certification.webp',
      );
      expect(result.s3Key, 'users/1/certification/certification.webp');
    });

    test('presigned url로 파일 바이트를 업로드한다', () async {
      final client = MockClient((_) async {
        fail('presigned URL 업로드는 API 인증 클라이언트를 사용하면 안 된다');
      });
      final uploadClient = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.toString(), 'https://mock-upload.example.com/file');
        expect(request.headers['Content-Type'], 'image/png');
        expect(request.bodyBytes, const [1, 2, 3]);
        return http.Response('', 200);
      });

      final repository = FileRepositoryImpl(
        client: client,
        uploadClient: uploadClient,
        baseUrl: baseUrl,
      );

      await repository.uploadBytesToPresignedUrl(
        presignedUrl: 'https://mock-upload.example.com/file',
        bytes: const [1, 2, 3],
        contentType: 'image/png',
      );
    });

    test('presigned url 응답에 URL 또는 s3Key가 없으면 실패한다', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({'presignedUrl': '', 's3Key': ''}),
          200,
        );
      });

      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(() => repository.createStyleImagePresignedUrl(), throwsException);
    });

    test('Swagger에 없는 업로드 url 발급은 호출하지 않는다', () async {
      final client = MockClient((_) async => http.Response('', 500));
      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(
        () => repository.createUploadPresign(
          fileName: 'profile.jpg',
          contentType: 'image/jpeg',
          size: 345678,
          purpose: 'PROFILE_IMAGE',
        ),
        throwsUnsupportedError,
      );
    });

    test('Swagger에 없는 업로드 완료 통지는 호출하지 않는다', () async {
      final client = MockClient((_) async => http.Response('', 500));
      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(
        () => repository.completeUpload(
          uploadId: 'up_01',
          key: 'users/1/profile/original/profile.jpg',
          etag: '"etag"',
          size: 345678,
        ),
        throwsUnsupportedError,
      );
    });

    test('Swagger에 없는 이미지 조회용 presigned url은 호출하지 않는다', () async {
      final client = MockClient((_) async => http.Response('', 500));
      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(
        () => repository.createPresignedUrl(fileId: 'file_01', expiresIn: 120),
        throwsUnsupportedError,
      );
    });

    test('Swagger에 없는 파일 삭제는 호출하지 않는다', () async {
      final client = MockClient((_) async => http.Response('', 500));
      final repository = FileRepositoryImpl(client: client, baseUrl: baseUrl);

      expect(() => repository.deleteFile('file_01'), throwsUnsupportedError);
    });
  });
}
