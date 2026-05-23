// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_profile_height_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 프로필 키 입력 상태 관리 Notifier.

@ProviderFor(BasicProfileHeight)
const basicProfileHeightProvider = BasicProfileHeightProvider._();

/// 기본 프로필 키 입력 상태 관리 Notifier.
final class BasicProfileHeightProvider
    extends $NotifierProvider<BasicProfileHeight, String> {
  /// 기본 프로필 키 입력 상태 관리 Notifier.
  const BasicProfileHeightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basicProfileHeightProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basicProfileHeightHash();

  @$internal
  @override
  BasicProfileHeight create() => BasicProfileHeight();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$basicProfileHeightHash() =>
    r'9f49014900102b0d8d338fbc34d218708e2a5a9e';

/// 기본 프로필 키 입력 상태 관리 Notifier.

abstract class _$BasicProfileHeight extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
