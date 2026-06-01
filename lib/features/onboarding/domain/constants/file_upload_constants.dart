/// 파일 업로드 정책 상수.
class FileUploadConstants {
  /// 서버 업로드 이미지 표준 content-type.
  static const String webpImageContentType = 'image/webp';

  /// 프로필 이미지 기본 content-type.
  static const String defaultProfileImageContentType = webpImageContentType;

  /// 학적 증명서 기본 content-type.
  static const String defaultCertificationContentType = webpImageContentType;

  /// 서버 업로드 이미지 표준 확장자.
  static const String webpImageExtension = 'webp';

  /// 프로필 사진 WebP 압축 옵션.
  static const UploadImageCompressionOptions profilePhotoCompressionOptions =
      UploadImageCompressionOptions(
        minWidth: 1440,
        minHeight: 1440,
        quality: 82,
      );

  /// 증명서처럼 글자 판독과 해상도가 중요한 이미지의 WebP 압축 옵션.
  static const UploadImageCompressionOptions documentImageCompressionOptions =
      UploadImageCompressionOptions(
        minWidth: 2400,
        minHeight: 2400,
        quality: 92,
      );

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

/// 서버 업로드 전 이미지 압축 옵션.
class UploadImageCompressionOptions {
  /// 압축 후 짧은 변 기준 목표 너비.
  final int minWidth;

  /// 압축 후 짧은 변 기준 목표 높이.
  final int minHeight;

  /// WebP 품질. 값이 높을수록 압축률이 낮고 품질이 좋다.
  final int quality;

  /// 생성자.
  const UploadImageCompressionOptions({
    required this.minWidth,
    required this.minHeight,
    required this.quality,
  });
}
