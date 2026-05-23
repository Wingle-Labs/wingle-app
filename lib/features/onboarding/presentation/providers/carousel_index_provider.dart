import 'package:carousel_slider/carousel_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'carousel_index_provider.g.dart';

/// Carousel의 현재 인덱스를 관리하는 Notifier
@Riverpod(keepAlive: true)
class OnboardingCarousel extends _$OnboardingCarousel {
  /// CarouselSliderController
  late final CarouselSliderController controller;

  @override
  int build() {
    controller = CarouselSliderController();
    return 0;
  }

  /// 다음 페이지로 이동
  void next() {
    state++;
    controller.animateToPage(state);
  }

  /// 마지막 페이지로 이동
  void skipToLast(int lastIndex) {
    controller.jumpToPage(lastIndex);
  }

  /// 인덱스 업데이트
  void update(int index) {
    state = index;
  }
}
