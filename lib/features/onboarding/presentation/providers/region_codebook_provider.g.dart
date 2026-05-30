// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_codebook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// REGION 코드북 트리를 제공하는 Provider.

@ProviderFor(regionCodebookTree)
const regionCodebookTreeProvider = RegionCodebookTreeProvider._();

/// REGION 코드북 트리를 제공하는 Provider.

final class RegionCodebookTreeProvider
    extends
        $FunctionalProvider<
          RegionCodebookTree,
          RegionCodebookTree,
          RegionCodebookTree
        >
    with $Provider<RegionCodebookTree> {
  /// REGION 코드북 트리를 제공하는 Provider.
  const RegionCodebookTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionCodebookTreeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionCodebookTreeHash();

  @$internal
  @override
  $ProviderElement<RegionCodebookTree> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegionCodebookTree create(Ref ref) {
    return regionCodebookTree(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegionCodebookTree value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegionCodebookTree>(value),
    );
  }
}

String _$regionCodebookTreeHash() =>
    r'e0807c9420274804a26e747c4e6911b0ac9207b5';
