// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pass_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PASS 인증 Repository Provider

@ProviderFor(passRepository)
const passRepositoryProvider = PassRepositoryProvider._();

/// PASS 인증 Repository Provider

final class PassRepositoryProvider
    extends $FunctionalProvider<PassRepository, PassRepository, PassRepository>
    with $Provider<PassRepository> {
  /// PASS 인증 Repository Provider
  const PassRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passRepositoryHash();

  @$internal
  @override
  $ProviderElement<PassRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PassRepository create(Ref ref) {
    return passRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PassRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PassRepository>(value),
    );
  }
}

String _$passRepositoryHash() => r'0934d47e1ed5925f346dee72353b1a108332849e';

/// PASS 인증 Provider

@ProviderFor(PassVerification)
const passVerificationProvider = PassVerificationProvider._();

/// PASS 인증 Provider
final class PassVerificationProvider
    extends
        $AsyncNotifierProvider<PassVerification, PortoneConfirmResponseDto?> {
  /// PASS 인증 Provider
  const PassVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passVerificationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passVerificationHash();

  @$internal
  @override
  PassVerification create() => PassVerification();
}

String _$passVerificationHash() => r'f2d886059ef8ba6cd07f1d052edd39c453ad4a00';

/// PASS 인증 Provider

abstract class _$PassVerification
    extends $AsyncNotifier<PortoneConfirmResponseDto?> {
  FutureOr<PortoneConfirmResponseDto?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PortoneConfirmResponseDto?>,
              PortoneConfirmResponseDto?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PortoneConfirmResponseDto?>,
                PortoneConfirmResponseDto?
              >,
              AsyncValue<PortoneConfirmResponseDto?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
