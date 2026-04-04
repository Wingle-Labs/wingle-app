import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';

/// 파일 관련 Repository 인터페이스.
abstract class FileRepository {
  /// 프로필 이미지 presigned URL을 발급한다.
  Future<ProfileImagePresignResult> createProfileImagePresignedUrl({
    String contentType = FileUploadConstants.defaultProfileImageContentType,
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
