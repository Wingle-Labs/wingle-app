import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/presentation/utils/upload_image_compressor.dart';

void main() {
  test('이미지를 WebP 업로드 파일로 변환한다', () async {
    late UploadImageCompressionOptions receivedOptions;
    late Uint8List receivedBytes;

    final result = await UploadImageCompressor.compressToWebp(
      bytes: Uint8List.fromList([1, 2, 3]),
      originalName: 'profile.jpg',
      options: FileUploadConstants.profilePhotoCompressionOptions,
      compressor: (bytes, options) async {
        receivedBytes = bytes;
        receivedOptions = options;
        return Uint8List.fromList([9, 8, 7]);
      },
    );

    expect(receivedBytes, [1, 2, 3]);
    expect(receivedOptions, FileUploadConstants.profilePhotoCompressionOptions);
    expect(result.name, 'profile.webp');
    expect(result.contentType, FileUploadConstants.webpImageContentType);
    expect(result.bytes, [9, 8, 7]);
    expect(result.originalSizeInBytes, 3);
    expect(result.sizeInBytes, 3);
  });

  test('확장자가 없는 파일도 WebP 파일명으로 변환한다', () async {
    final result = await UploadImageCompressor.compressToWebp(
      bytes: Uint8List.fromList([1]),
      originalName: 'school-certification',
      options: FileUploadConstants.documentImageCompressionOptions,
      compressor: (_, _) async => Uint8List.fromList([2]),
    );

    expect(result.name, 'school-certification.webp');
  });

  test('압축 결과가 비어 있으면 실패한다', () async {
    expect(
      () => UploadImageCompressor.compressToWebp(
        bytes: Uint8List.fromList([1]),
        originalName: 'empty.png',
        options: FileUploadConstants.profilePhotoCompressionOptions,
        compressor: (_, _) async => Uint8List(0),
      ),
      throwsStateError,
    );
  });
}
