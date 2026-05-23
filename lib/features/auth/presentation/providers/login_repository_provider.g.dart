// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [LoginRepository] 구현체를 제공하는 Provider.

@ProviderFor(loginRepository)
const loginRepositoryProvider = LoginRepositoryProvider._();

/// [LoginRepository] 구현체를 제공하는 Provider.

final class LoginRepositoryProvider
    extends
        $FunctionalProvider<LoginRepository, LoginRepository, LoginRepository>
    with $Provider<LoginRepository> {
  /// [LoginRepository] 구현체를 제공하는 Provider.
  const LoginRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoginRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginRepository create(Ref ref) {
    return loginRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginRepository>(value),
    );
  }
}

String _$loginRepositoryHash() => r'319adcf1f7090fa796ff155806ef0870306f5a0c';
