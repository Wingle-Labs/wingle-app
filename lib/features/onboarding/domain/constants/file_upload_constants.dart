/// 파일 업로드 정책 상수.
class FileUploadConstants {
  /// 프로필 이미지 기본 content-type.
  static const String defaultProfileImageContentType = 'image/jpeg';

  /// 학적 증명서 기본 content-type.
  static const String defaultCertificationContentType = 'image/jpeg';

  /// presigned 업로드가 허용하는 이미지 content-type.
  static const Set<String> supportedImageContentTypes = {
    'image/jpeg',
    'image/png',
    'image/webp',
  };

  /// presigned url 기본 만료 초.
  static const int defaultPresignedUrlExpiresInSeconds = 300;

  /// 생성자 방지
  FileUploadConstants._();
}
