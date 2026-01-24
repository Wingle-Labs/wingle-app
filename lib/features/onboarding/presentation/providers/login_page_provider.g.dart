// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 로그인 페이지 상태 관리

@ProviderFor(LoginPage)
const loginPageProvider = LoginPageProvider._();

/// 로그인 페이지 상태 관리
final class LoginPageProvider
    extends $NotifierProvider<LoginPage, LoginPageModel> {
  /// 로그인 페이지 상태 관리
  const LoginPageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginPageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginPageHash();

  @$internal
  @override
  LoginPage create() => LoginPage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginPageModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginPageModel>(value),
    );
  }
}

String _$loginPageHash() => r'd134a678261509ac1d21d4cc615817ac6938a20e';

/// 로그인 페이지 상태 관리

abstract class _$LoginPage extends $Notifier<LoginPageModel> {
  LoginPageModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoginPageModel, LoginPageModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginPageModel, LoginPageModel>,
              LoginPageModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
