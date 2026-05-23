// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [HealthRepository] 구현체를 제공하는 Provider.

@ProviderFor(healthRepository)
const healthRepositoryProvider = HealthRepositoryProvider._();

/// [HealthRepository] 구현체를 제공하는 Provider.

final class HealthRepositoryProvider
    extends
        $FunctionalProvider<
          HealthRepository,
          HealthRepository,
          HealthRepository
        >
    with $Provider<HealthRepository> {
  /// [HealthRepository] 구현체를 제공하는 Provider.
  const HealthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthRepositoryHash();

  @$internal
  @override
  $ProviderElement<HealthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthRepository create(Ref ref) {
    return healthRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthRepository>(value),
    );
  }
}

String _$healthRepositoryHash() => r'6af26989d6e9e90df44fc80cad97602dbfcba0bd';
