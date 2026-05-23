// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_shape_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [BodyShapeRepository] 구현체를 제공하는 Provider.

@ProviderFor(bodyShapeRepository)
const bodyShapeRepositoryProvider = BodyShapeRepositoryProvider._();

/// [BodyShapeRepository] 구현체를 제공하는 Provider.

final class BodyShapeRepositoryProvider
    extends
        $FunctionalProvider<
          BodyShapeRepository,
          BodyShapeRepository,
          BodyShapeRepository
        >
    with $Provider<BodyShapeRepository> {
  /// [BodyShapeRepository] 구현체를 제공하는 Provider.
  const BodyShapeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyShapeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyShapeRepositoryHash();

  @$internal
  @override
  $ProviderElement<BodyShapeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BodyShapeRepository create(Ref ref) {
    return bodyShapeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyShapeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyShapeRepository>(value),
    );
  }
}

String _$bodyShapeRepositoryHash() =>
    r'd49fa2e1ddf89acc308182d2dec9040a526cc85a';

/// 체형 코드북을 제공하는 Provider.

@ProviderFor(bodyShapeCodebook)
const bodyShapeCodebookProvider = BodyShapeCodebookProvider._();

/// 체형 코드북을 제공하는 Provider.

final class BodyShapeCodebookProvider
    extends
        $FunctionalProvider<
          BodyShapeCodebook,
          BodyShapeCodebook,
          BodyShapeCodebook
        >
    with $Provider<BodyShapeCodebook> {
  /// 체형 코드북을 제공하는 Provider.
  const BodyShapeCodebookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyShapeCodebookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyShapeCodebookHash();

  @$internal
  @override
  $ProviderElement<BodyShapeCodebook> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BodyShapeCodebook create(Ref ref) {
    return bodyShapeCodebook(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyShapeCodebook value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyShapeCodebook>(value),
    );
  }
}

String _$bodyShapeCodebookHash() => r'46589ae08d44a85aa5237f8ca25c46d27818ca5a';
