// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_index_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carousel의 현재 인덱스를 관리하는 Provider

@ProviderFor(CarouselIndex)
const carouselIndexProvider = CarouselIndexProvider._();

/// Carousel의 현재 인덱스를 관리하는 Provider
final class CarouselIndexProvider
    extends $NotifierProvider<CarouselIndex, int> {
  /// Carousel의 현재 인덱스를 관리하는 Provider
  const CarouselIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'carouselIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$carouselIndexHash();

  @$internal
  @override
  CarouselIndex create() => CarouselIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$carouselIndexHash() => r'342b9da9c7fcf06b93c8c4ead68ea666784f2bf3';

/// Carousel의 현재 인덱스를 관리하는 Provider

abstract class _$CarouselIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
