// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_auth_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 휴대폰 인증 레포지토리

@ProviderFor(phoneAuthRepository)
const phoneAuthRepositoryProvider = PhoneAuthRepositoryProvider._();

/// 휴대폰 인증 레포지토리

final class PhoneAuthRepositoryProvider
    extends
        $FunctionalProvider<
          PhoneAuthRepository,
          PhoneAuthRepository,
          PhoneAuthRepository
        >
    with $Provider<PhoneAuthRepository> {
  /// 휴대폰 인증 레포지토리
  const PhoneAuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneAuthRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneAuthRepositoryHash();

  @$internal
  @override
  $ProviderElement<PhoneAuthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhoneAuthRepository create(Ref ref) {
    return phoneAuthRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneAuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneAuthRepository>(value),
    );
  }
}

String _$phoneAuthRepositoryHash() =>
    r'cf69a17ce1d8ad7d2b580f85ef07e3343d6cb454';
