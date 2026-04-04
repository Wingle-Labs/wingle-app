/// 프로필 이미지 presigned URL 응답
class ProfileImagePresignResult {
  /// Presigned URL
  final String presignedUrl;

  /// S3 키
  final String s3Key;

  /// 생성자
  const ProfileImagePresignResult({
    required this.presignedUrl,
    required this.s3Key,
  });

  /// JSON에서 생성한다.
  factory ProfileImagePresignResult.fromJson(Map<String, dynamic> json) {
    return ProfileImagePresignResult(
      presignedUrl:
          (json['presigned_url'] ?? json['presignedUrl'])?.toString() ?? '',
      s3Key: (json['s3_key'] ?? json['s3Key'])?.toString() ?? '',
    );
  }
}

/// 업로드 URL 발급 응답
class FileUploadPresignResult {
  /// 업로드 요청 식별자
  final String uploadId;

  /// 업로드 HTTP 메서드
  final String method;

  /// 업로드 URL
  final String uploadUrl;

  /// 업로드 헤더
  final Map<String, String> headers;

  /// S3 Object Key
  final String key;

  /// 만료 시각
  final String expiresAt;

  /// 생성자
  const FileUploadPresignResult({
    required this.uploadId,
    required this.method,
    required this.uploadUrl,
    required this.headers,
    required this.key,
    required this.expiresAt,
  });

  /// JSON에서 생성한다.
  factory FileUploadPresignResult.fromJson(Map<String, dynamic> json) {
    final rawHeaders = json['headers'];

    return FileUploadPresignResult(
      uploadId: json['uploadId']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      uploadUrl: json['uploadUrl']?.toString() ?? '',
      headers: rawHeaders is Map
          ? rawHeaders.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : <String, String>{},
      key: json['key']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
    );
  }
}

/// 업로드 완료 응답
class FileUploadCompleteResult {
  /// 파일 ID
  final String fileId;

  /// 파일 상태
  final String status;

  /// S3 Object Key
  final String key;

  /// 생성 시각
  final String createdAt;

  /// 생성자
  const FileUploadCompleteResult({
    required this.fileId,
    required this.status,
    required this.key,
    required this.createdAt,
  });

  /// JSON에서 생성한다.
  factory FileUploadCompleteResult.fromJson(Map<String, dynamic> json) {
    return FileUploadCompleteResult(
      fileId: json['fileId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

/// 파일 조회용 presigned URL 응답
class FilePresignedUrlResult {
  /// 파일 ID
  final String fileId;

  /// Presigned Get URL
  final String url;

  /// 만료 시각
  final String expiresAt;

  /// 파일 MIME 타입
  final String contentType;

  /// 파일 크기
  final int size;

  /// 생성자
  const FilePresignedUrlResult({
    required this.fileId,
    required this.url,
    required this.expiresAt,
    required this.contentType,
    required this.size,
  });

  /// JSON에서 생성한다.
  factory FilePresignedUrlResult.fromJson(Map<String, dynamic> json) {
    final rawSize = json['size'];

    return FilePresignedUrlResult(
      fileId: json['fileId']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
      contentType: json['contentType']?.toString() ?? '',
      size: rawSize is num ? rawSize.toInt() : int.parse(rawSize.toString()),
    );
  }
}

/// 파일 삭제 응답
class FileDeleteResult {
  /// 파일 ID
  final String fileId;

  /// 파일 상태
  final String status;

  /// 삭제 시각
  final String deletedAt;

  /// 생성자
  const FileDeleteResult({
    required this.fileId,
    required this.status,
    required this.deletedAt,
  });

  /// JSON에서 생성한다.
  factory FileDeleteResult.fromJson(Map<String, dynamic> json) {
    return FileDeleteResult(
      fileId: json['fileId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deletedAt: json['deletedAt']?.toString() ?? '',
    );
  }
}
