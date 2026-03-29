import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/states/indicator.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_scaffold.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/indicator_carousel.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/onboarding_bottom_buttons.dart';
import 'package:wingle/features/onboarding/presentation/data/onboarding_carousel_items.dart';
import 'package:wingle/features/onboarding/presentation/providers/carousel_index_provider.dart';

/// Onboarding 페이지
class OnboardingPage extends ConsumerStatefulWidget {
  /// 초기 화면으로 사용자에게 앱을 소개하는 페이지
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(onboardingCarouselProvider);
    final controller = ref
        .watch(onboardingCarouselProvider.notifier)
        .controller;
    final lastIndex = onboardingCarouselItems.length - 1;

    return DefaultScaffold(
      padding: .zero,
      appBar: DefaultAppBar(
        isActionVisible: currentIndex < lastIndex,
        actions: [
          IntrinsicWidth(
            child: DefaultTextButton(
              label: "건너뛰기",
              onPressed: () {
                ref
                    .read(onboardingCarouselProvider.notifier)
                    .skipToLast(lastIndex);
              },
              foregroundColor: context.colors.textAlternative,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Indicator(
              currentIndex: currentIndex,
              length: onboardingCarouselItems.length,
            ),
            Expanded(
              child: Center(
                child: IndicatorCarousel(
                  items: onboardingCarouselItems,
                  controller: controller,
                  onIndexChanged: (index) {
                    ref.read(onboardingCarouselProvider.notifier).update(index);
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: AppPadding.scaffold,
                right: AppPadding.scaffold,
                top: AppPadding.scaffold,
                bottom: AppPadding.horizontal,
              ),
              child: OnboardingBottomButtons(
                controller: controller,
                isLastPage: currentIndex == lastIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
