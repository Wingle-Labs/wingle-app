import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/models/onboarding_carousel_item.dart';

/// Indicator와 Carousel을 포함한 Widget
class IndicatorCarousel extends StatelessWidget {
  /// Carousel의 아이템들
  final List<OnboardingCarouselItem> items;

  /// Carousel의 컨트롤러
  final CarouselSliderController controller;

  /// 인덱스 변경시 호출되는 콜백
  final ValueChanged<int> onIndexChanged;

  /// const 생성자
  const IndicatorCarousel({
    super.key,
    required this.items,
    required this.controller,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          carouselController: controller,
          items: items.map((entry) {
            return SizedBox(
              width: AppContainerSize.carouselContainer,
              child: Column(
                children: [
                  SizedBox(
                    child: Center(
                      child: Image(
                        image: entry.image,
                        width: AppContainerSize.carouselImageContainer,
                        height: AppContainerSize.carouselImageContainer,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  TextScaleWrapper(
                    policy: .fixed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                      ),
                      height: AppContainerSize.indicatorDescription,
                      child: entry.content,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height:
                AppContainerSize.indicatorDescription +
                AppContainerSize.carouselImageContainer +
                AppSpacing.s8,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => onIndexChanged(index),
          ),
        ),
      ],
    );
  }
}
