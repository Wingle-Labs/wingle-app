// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_photo_picker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 사진 갤러리 선택 함수를 제공한다.

@ProviderFor(profilePhotoPicker)
const profilePhotoPickerProvider = ProfilePhotoPickerProvider._();

/// 프로필 사진 갤러리 선택 함수를 제공한다.

final class ProfilePhotoPickerProvider
    extends
        $FunctionalProvider<
          ProfilePhotoPickerFn,
          ProfilePhotoPickerFn,
          ProfilePhotoPickerFn
        >
    with $Provider<ProfilePhotoPickerFn> {
  /// 프로필 사진 갤러리 선택 함수를 제공한다.
  const ProfilePhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilePhotoPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilePhotoPickerHash();

  @$internal
  @override
  $ProviderElement<ProfilePhotoPickerFn> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfilePhotoPickerFn create(Ref ref) {
    return profilePhotoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfilePhotoPickerFn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfilePhotoPickerFn>(value),
    );
  }
}

String _$profilePhotoPickerHash() =>
    r'17a1fc36d5bb6bf2e02b46326478c90dd29508cb';

/// 프로필 사진 WebP 압축 함수 override를 제공한다.

@ProviderFor(profilePhotoUploadImageCompressor)
const profilePhotoUploadImageCompressorProvider =
    ProfilePhotoUploadImageCompressorProvider._();

/// 프로필 사진 WebP 압축 함수 override를 제공한다.

final class ProfilePhotoUploadImageCompressorProvider
    extends
        $FunctionalProvider<
          UploadImageCompressionFn?,
          UploadImageCompressionFn?,
          UploadImageCompressionFn?
        >
    with $Provider<UploadImageCompressionFn?> {
  /// 프로필 사진 WebP 압축 함수 override를 제공한다.
  const ProfilePhotoUploadImageCompressorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilePhotoUploadImageCompressorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$profilePhotoUploadImageCompressorHash();

  @$internal
  @override
  $ProviderElement<UploadImageCompressionFn?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UploadImageCompressionFn? create(Ref ref) {
    return profilePhotoUploadImageCompressor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadImageCompressionFn? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadImageCompressionFn?>(value),
    );
  }
}

String _$profilePhotoUploadImageCompressorHash() =>
    r'ecdfc6fd2bd2691a2ae129bcbfd109450c36622e';
