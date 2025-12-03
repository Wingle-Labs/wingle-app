// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 휴대폰 인증 상태를 관리합니다.

@ProviderFor(PhoneAuth)
const phoneAuthProvider = PhoneAuthProvider._();

/// 휴대폰 인증 상태를 관리합니다.
final class PhoneAuthProvider
    extends $NotifierProvider<PhoneAuth, PhoneAuthState> {
  /// 휴대폰 인증 상태를 관리합니다.
  const PhoneAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneAuthHash();

  @$internal
  @override
  PhoneAuth create() => PhoneAuth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneAuthState>(value),
    );
  }
}

String _$phoneAuthHash() => r'74fa86aa8b2ce73c2a33722de728418222115d9e';

/// 휴대폰 인증 상태를 관리합니다.

abstract class _$PhoneAuth extends $Notifier<PhoneAuthState> {
  PhoneAuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhoneAuthState, PhoneAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneAuthState, PhoneAuthState>,
              PhoneAuthState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
