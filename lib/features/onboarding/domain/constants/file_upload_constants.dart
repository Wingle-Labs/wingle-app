/// 파일 업로드 정책 상수.
class FileUploadConstants {
  /// 프로필 이미지 기본 content-type.
  static const String defaultProfileImageContentType = 'image/jpeg';

  /// presigned url 기본 만료 초.
  static const int defaultPresignedUrlExpiresInSeconds = 300;

  /// 생성자 방지
  FileUploadConstants._();
}
