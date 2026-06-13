// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_contact_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기기 연락처 조회 서비스를 제공한다.

@ProviderFor(deviceContactService)
const deviceContactServiceProvider = DeviceContactServiceProvider._();

/// 기기 연락처 조회 서비스를 제공한다.

final class DeviceContactServiceProvider
    extends
        $FunctionalProvider<
          DeviceContactService,
          DeviceContactService,
          DeviceContactService
        >
    with $Provider<DeviceContactService> {
  /// 기기 연락처 조회 서비스를 제공한다.
  const DeviceContactServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceContactServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceContactServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceContactService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceContactService create(Ref ref) {
    return deviceContactService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceContactService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceContactService>(value),
    );
  }
}

String _$deviceContactServiceHash() =>
    r'd8a2d6beb71dcbefa90682ba4851ef80586ca189';
