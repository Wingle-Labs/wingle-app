import 'package:flutter/widgets.dart';

/// Onboarding에서 Carousel의 위젯과 이미지 쌍을 저장하는 모델
class OnboardingCarouselItem {
  /// Carousel의 위젯
  final Widget content;

  /// Carousel의 이미지
  final ImageProvider image;

  /// const 생성자
  const OnboardingCarouselItem({required this.content, required this.image});
}
