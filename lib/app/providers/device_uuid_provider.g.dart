// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_uuid_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기기 고유 ID를 관리하는 Provider

@ProviderFor(DeviceUuid)
const deviceUuidProvider = DeviceUuidProvider._();

/// 기기 고유 ID를 관리하는 Provider
final class DeviceUuidProvider extends $NotifierProvider<DeviceUuid, String> {
  /// 기기 고유 ID를 관리하는 Provider
  const DeviceUuidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceUuidProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceUuidHash();

  @$internal
  @override
  DeviceUuid create() => DeviceUuid();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$deviceUuidHash() => r'2aef5254da8e92a81630c1c434f8c7e9063bfcc4';

/// 기기 고유 ID를 관리하는 Provider

abstract class _$DeviceUuid extends $Notifier<String> {
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
