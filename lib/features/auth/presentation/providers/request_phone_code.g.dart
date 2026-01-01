// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_phone_code.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 휴대폰 인증번호 요청

@ProviderFor(requestPhoneCode)
const requestPhoneCodeProvider = RequestPhoneCodeProvider._();

/// 휴대폰 인증번호 요청

final class RequestPhoneCodeProvider
    extends
        $FunctionalProvider<
          RequestPhoneCode,
          RequestPhoneCode,
          RequestPhoneCode
        >
    with $Provider<RequestPhoneCode> {
  /// 휴대폰 인증번호 요청
  const RequestPhoneCodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestPhoneCodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestPhoneCodeHash();

  @$internal
  @override
  $ProviderElement<RequestPhoneCode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RequestPhoneCode create(Ref ref) {
    return requestPhoneCode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestPhoneCode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestPhoneCode>(value),
    );
  }
}

String _$requestPhoneCodeHash() => r'0bc84b3a42137283c45749f5041ec948cac4f336';
