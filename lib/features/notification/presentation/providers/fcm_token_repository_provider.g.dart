// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [FcmTokenRepository] 구현체를 제공한다.

@ProviderFor(fcmTokenRepository)
const fcmTokenRepositoryProvider = FcmTokenRepositoryProvider._();

/// [FcmTokenRepository] 구현체를 제공한다.

final class FcmTokenRepositoryProvider
    extends
        $FunctionalProvider<
          FcmTokenRepository,
          FcmTokenRepository,
          FcmTokenRepository
        >
    with $Provider<FcmTokenRepository> {
  /// [FcmTokenRepository] 구현체를 제공한다.
  const FcmTokenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmTokenRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmTokenRepositoryHash();

  @$internal
  @override
  $ProviderElement<FcmTokenRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FcmTokenRepository create(Ref ref) {
    return fcmTokenRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FcmTokenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FcmTokenRepository>(value),
    );
  }
}

String _$fcmTokenRepositoryHash() =>
    r'8bff7dd1dc0b3b24b58ac242f723a32f4b215901';
