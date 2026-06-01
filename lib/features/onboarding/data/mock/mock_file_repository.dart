import 'dart:async';

import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/domain/repository/file_repository.dart';

/// 파일 Repository Mock 구현
class MockFileRepository implements FileRepository {
  @override
  Future<ProfileImagePresignResult> createProfileImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/profile-image',
      s3Key: 'users/mock/profile/original/mock-profile.webp',
    );
  }

  @override
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) {
    return createProfileImagePresignedUrl(contentType: contentType);
  }

  @override
  Future<ProfileImagePresignResult> createFaceImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  }) {
    return createProfileImagePresignedUrl(contentType: contentType);
  }

  @override
  Future<ProfileImagePresignResult> createCertificationPresignedUrl({
    String contentType = FileUploadConstants.defaultCertificationContentType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const ProfileImagePresignResult(
      presignedUrl: 'https://mock-upload.example.com/certification',
      s3Key: 'users/mock/certification/mock-certification.webp',
    );
  }

  @override
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<FileUploadPresignResult> createUploadPresign({
    required String fileName,
    required String contentType,
    required int size,
    required String purpose,
    String? checksum,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return FileUploadPresignResult(
      uploadId: 'up_mock_01',
      method: 'PUT',
      uploadUrl: 'https://mock-upload.example.com/files/up_mock_01',
      headers: {'Content-Type': contentType},
      key: 'users/mock/files/$fileName',
      expiresAt: '2026-02-02T10:20:00+09:00',
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return FileUploadCompleteResult(
      fileId: 'file_mock_01',
      status: 'UPLOADED',
      key: key,
      createdAt: '2026-02-02T09:50:12+09:00',
    );
  }

  @override
  Future<FilePresignedUrlResult> createPresignedUrl({
    required String fileId,
    int expiresIn = 300,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return FilePresignedUrlResult(
      fileId: fileId,
      url: 'https://mock-download.example.com/$fileId?expiresIn=$expiresIn',
      expiresAt: '2026-02-02T09:55:00+09:00',
      contentType: FileUploadConstants.webpImageContentType,
      size: 345678,
    );
  }

  @override
  Future<FileDeleteResult> deleteFile(String fileId) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return FileDeleteResult(
      fileId: fileId,
      status: 'SOFT_DELETED',
      deletedAt: '2026-02-02T10:05:12+09:00',
    );
  }
}
