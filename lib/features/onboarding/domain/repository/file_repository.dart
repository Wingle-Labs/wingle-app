import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';

/// 파일 관련 Repository 인터페이스.
abstract class FileRepository {
  /// 프로필 이미지 presigned URL을 발급한다.
  Future<ProfileImagePresignResult> createProfileImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  });

  /// 스타일 사진 presigned URL을 발급한다.
  Future<ProfileImagePresignResult> createStyleImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  });

  /// 얼굴 사진 presigned URL을 발급한다.
  Future<ProfileImagePresignResult> createFaceImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
  });

  /// 학적 증명서 presigned URL을 발급한다.
  Future<ProfileImagePresignResult> createCertificationPresignedUrl({
    String contentType = FileUploadConstants.defaultCertificationContentType,
  });

  /// presigned URL에 바이트 파일을 업로드한다.
  Future<void> uploadBytesToPresignedUrl({
    required String presignedUrl,
    required List<int> bytes,
    required String contentType,
  });

  /// 업로드 URL을 발급한다.
  Future<FileUploadPresignResult> createUploadPresign({
    required String fileName,
    required String contentType,
    required int size,
    required String purpose,
    String? checksum,
  });

  /// 업로드 완료를 통지한다.
  Future<FileUploadCompleteResult> completeUpload({
    required String uploadId,
    required String key,
    required String etag,
    required int size,
    String? contentType,
  });

  /// 파일 조회용 presigned URL을 발급한다.
  Future<FilePresignedUrlResult> createPresignedUrl({
    required String fileId,
    int expiresIn = FileUploadConstants.defaultPresignedUrlExpiresInSeconds,
  });

  /// 파일을 삭제한다.
  Future<FileDeleteResult> deleteFile(String fileId);
}
