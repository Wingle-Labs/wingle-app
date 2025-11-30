// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 어플리케이션 로컬라이제이션
/// 어플리케이션의 다국어 지원을 관리합니다.

@ProviderFor(Localization)
const localizationProvider = LocalizationProvider._();

/// 어플리케이션 로컬라이제이션
/// 어플리케이션의 다국어 지원을 관리합니다.
final class LocalizationProvider
    extends $NotifierProvider<Localization, Locale> {
  /// 어플리케이션 로컬라이제이션
  /// 어플리케이션의 다국어 지원을 관리합니다.
  const LocalizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localizationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localizationHash();

  @$internal
  @override
  Localization create() => Localization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localizationHash() => r'a6dfa2c0b1c97f0b4ca5a29f96e756b312a22506';

/// 어플리케이션 로컬라이제이션
/// 어플리케이션의 다국어 지원을 관리합니다.

abstract class _$Localization extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
