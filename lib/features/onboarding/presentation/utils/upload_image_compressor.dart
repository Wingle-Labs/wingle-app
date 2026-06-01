import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';

/// 이미지 압축 함수 타입.
typedef UploadImageCompressionFn =
    Future<Uint8List> Function(
      Uint8List bytes,
      UploadImageCompressionOptions options,
    );

/// 서버 업로드용 이미지 파일.
class UploadImageFile {
  /// WebP로 변환된 파일명.
  final String name;

  /// 서버에 전달할 MIME 타입.
  final String contentType;

  /// WebP 압축 바이트.
  final Uint8List bytes;

  /// 원본 파일 크기.
  final int originalSizeInBytes;

  /// 생성자.
  const UploadImageFile({
    required this.name,
    required this.contentType,
    required this.bytes,
    required this.originalSizeInBytes,
  });

  /// 압축 후 파일 크기.
  int get sizeInBytes => bytes.length;
}

/// 이미지 파일을 서버 업로드 표준인 WebP로 변환한다.
abstract final class UploadImageCompressor {
  /// [bytes]를 WebP로 압축하고 파일명/content-type을 서버 업로드 규격으로 맞춘다.
  static Future<UploadImageFile> compressToWebp({
    required Uint8List bytes,
    required String originalName,
    required UploadImageCompressionOptions options,
    UploadImageCompressionFn? compressor,
  }) async {
    final compressedBytes = await (compressor ?? _compressWithPlugin)(
      bytes,
      options,
    );

    if (compressedBytes.isEmpty) {
      throw StateError('Image compression returned empty bytes.');
    }

    return UploadImageFile(
      name: _webpFileName(originalName),
      contentType: FileUploadConstants.webpImageContentType,
      bytes: compressedBytes,
      originalSizeInBytes: bytes.length,
    );
  }

  static Future<Uint8List> _compressWithPlugin(
    Uint8List bytes,
    UploadImageCompressionOptions options,
  ) {
    return FlutterImageCompress.compressWithList(
      bytes,
      minWidth: options.minWidth,
      minHeight: options.minHeight,
      quality: options.quality,
      format: CompressFormat.webp,
      keepExif: false,
    );
  }

  static String _webpFileName(String originalName) {
    final trimmed = originalName.trim();
    final name = trimmed.isEmpty ? 'upload' : trimmed;
    final extensionIndex = name.lastIndexOf('.');
    final baseName = extensionIndex <= 0
        ? name
        : name.substring(0, extensionIndex);
    final normalizedBaseName = baseName.trim().isEmpty ? 'upload' : baseName;

    return '$normalizedBaseName.${FileUploadConstants.webpImageExtension}';
  }
}
