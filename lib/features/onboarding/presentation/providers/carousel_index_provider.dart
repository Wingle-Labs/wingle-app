import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Carousel의 현재 인덱스를 관리하는 Provider
final onboardingCarouselProvider =
    NotifierProvider<OnboardingCarouselNotifier, int>(
      OnboardingCarouselNotifier.new,
    );

/// Carousel의 현재 인덱스를 관리하는 Notifier
class OnboardingCarouselNotifier extends Notifier<int> {
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
