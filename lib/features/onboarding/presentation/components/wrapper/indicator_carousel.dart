import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/states/indicator.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/models/onboarding_carousel_item.dart';

/// Indicator와 Carousel을 포함한 Widget
class IndicatorCarousel extends StatelessWidget {
  /// Carousel의 아이템들
  final List<OnboardingCarouselItem> items;

  /// Carousel의 컨트롤러
  final CarouselSliderController controller;

  /// 현재 인덱스
  final int currentIndex;

  /// 인덱스 변경시 호출되는 콜백
  final ValueChanged<int> onIndexChanged;

  /// const 생성자
  const IndicatorCarousel({
    super.key,
    required this.items,
    required this.controller,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Indicator(currentIndex: currentIndex, length: items.length),
        CarouselSlider(
          carouselController: controller,
          items: items.map((entry) {
            return Column(
              children: [
                SizedBox(
                  height: AppContainerSize.indicatorDescription,
                  child: Center(child: entry.content),
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  height: AppContainerSize.indicatorImage,
                  width: AppContainerSize.indicatorImage,
                  child: Image(image: entry.image, fit: BoxFit.cover),
                ),
              ],
            );
          }).toList(),
          // TODO: 매직 넘버 제거
          options: CarouselOptions(
            aspectRatio: 1 / 1.5,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => onIndexChanged(index),
          ),
        ),
      ],
    );
  }
}
