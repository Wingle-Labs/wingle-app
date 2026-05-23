// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_password_input_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 로그인 페이지 상태 관리

@ProviderFor(OnboardingPasswordInputPage)
const onboardingPasswordInputPageProvider =
    OnboardingPasswordInputPageProvider._();

/// 로그인 페이지 상태 관리
final class OnboardingPasswordInputPageProvider
    extends
        $NotifierProvider<
          OnboardingPasswordInputPage,
          OnboardingPasswordInputModel
        > {
  /// 로그인 페이지 상태 관리
  const OnboardingPasswordInputPageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingPasswordInputPageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingPasswordInputPageHash();

  @$internal
  @override
  OnboardingPasswordInputPage create() => OnboardingPasswordInputPage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingPasswordInputModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingPasswordInputModel>(value),
    );
  }
}

String _$onboardingPasswordInputPageHash() =>
    r'42f9c187cd4006fdb288f3e4621d0f33b2ab1a47';

/// 로그인 페이지 상태 관리

abstract class _$OnboardingPasswordInputPage
    extends $Notifier<OnboardingPasswordInputModel> {
  OnboardingPasswordInputModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<OnboardingPasswordInputModel, OnboardingPasswordInputModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                OnboardingPasswordInputModel,
                OnboardingPasswordInputModel
              >,
              OnboardingPasswordInputModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
