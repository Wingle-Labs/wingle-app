// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [SignupRepository] 구현체를 제공하는 Provider.

@ProviderFor(signupRepository)
const signupRepositoryProvider = SignupRepositoryProvider._();

/// [SignupRepository] 구현체를 제공하는 Provider.

final class SignupRepositoryProvider
    extends
        $FunctionalProvider<
          SignupRepository,
          SignupRepository,
          SignupRepository
        >
    with $Provider<SignupRepository> {
  /// [SignupRepository] 구현체를 제공하는 Provider.
  const SignupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupRepositoryHash();

  @$internal
  @override
  $ProviderElement<SignupRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignupRepository create(Ref ref) {
    return signupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupRepository>(value),
    );
  }
}

String _$signupRepositoryHash() => r'83d9a146933e89beada659d02d3f9ae1c7cd0003';
