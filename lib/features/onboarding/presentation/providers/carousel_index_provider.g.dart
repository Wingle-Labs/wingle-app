// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_index_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carousel의 현재 인덱스를 관리하는 Notifier

@ProviderFor(OnboardingCarousel)
const onboardingCarouselProvider = OnboardingCarouselProvider._();

/// Carousel의 현재 인덱스를 관리하는 Notifier
final class OnboardingCarouselProvider
    extends $NotifierProvider<OnboardingCarousel, int> {
  /// Carousel의 현재 인덱스를 관리하는 Notifier
  const OnboardingCarouselProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCarouselProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCarouselHash();

  @$internal
  @override
  OnboardingCarousel create() => OnboardingCarousel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$onboardingCarouselHash() =>
    r'8ad19f1d1b5d50e396f630645127a612580d4728';

/// Carousel의 현재 인덱스를 관리하는 Notifier

abstract class _$OnboardingCarousel extends $Notifier<int> {
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
