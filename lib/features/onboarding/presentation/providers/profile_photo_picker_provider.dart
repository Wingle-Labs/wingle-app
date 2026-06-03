import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/presentation/utils/upload_image_compressor.dart';

part 'profile_photo_picker_provider.g.dart';

/// 프로필 사진 갤러리 선택 함수.
typedef ProfilePhotoPickerFn = Future<List<XFile>> Function(int maxCount);

/// 프로필 사진 갤러리 선택 함수를 제공한다.
@riverpod
ProfilePhotoPickerFn profilePhotoPicker(Ref ref) {
  final picker = ImagePicker();

  return (maxCount) async {
    if (maxCount <= 0) {
      return const <XFile>[];
    }

    if (maxCount == 1) {
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      return image == null ? const <XFile>[] : <XFile>[image];
    }

    return picker.pickMultiImage(limit: maxCount, requestFullMetadata: false);
  };
}

/// 프로필 사진 WebP 압축 함수 override를 제공한다.
@riverpod
UploadImageCompressionFn? profilePhotoUploadImageCompressor(Ref ref) {
  return null;
}
