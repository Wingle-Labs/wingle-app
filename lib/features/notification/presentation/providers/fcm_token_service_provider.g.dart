// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// FCM 토큰 등록 서비스를 제공한다.

@ProviderFor(fcmTokenService)
const fcmTokenServiceProvider = FcmTokenServiceProvider._();

/// FCM 토큰 등록 서비스를 제공한다.

final class FcmTokenServiceProvider
    extends
        $FunctionalProvider<FcmTokenService, FcmTokenService, FcmTokenService>
    with $Provider<FcmTokenService> {
  /// FCM 토큰 등록 서비스를 제공한다.
  const FcmTokenServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fcmTokenServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fcmTokenServiceHash();

  @$internal
  @override
  $ProviderElement<FcmTokenService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FcmTokenService create(Ref ref) {
    return fcmTokenService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FcmTokenService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FcmTokenService>(value),
    );
  }
}

String _$fcmTokenServiceHash() => r'5fea3517ef6f684887ceccf4d6111a0e383dee9e';
