// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_initializer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 부트스트랩 초기화 제공자

@ProviderFor(bootstrapInitializer)
const bootstrapInitializerProvider = BootstrapInitializerProvider._();

/// 부트스트랩 초기화 제공자

final class BootstrapInitializerProvider
    extends
        $FunctionalProvider<
          BootstrapInitializer,
          BootstrapInitializer,
          BootstrapInitializer
        >
    with $Provider<BootstrapInitializer> {
  /// 부트스트랩 초기화 제공자
  const BootstrapInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bootstrapInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bootstrapInitializerHash();

  @$internal
  @override
  $ProviderElement<BootstrapInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BootstrapInitializer create(Ref ref) {
    return bootstrapInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BootstrapInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BootstrapInitializer>(value),
    );
  }
}

String _$bootstrapInitializerHash() =>
    r'f9d772cbf08d10ef27980d202a65725bc6f6f602';
