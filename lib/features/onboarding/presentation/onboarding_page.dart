import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_text_button.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
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

    return ConstrainedScrollableScaffold(
      padding: .zero,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        actions: currentIndex < lastIndex
            ? [
                IntrinsicWidth(
                  child: DefaultTextButton(
                    label: "건너뛰기",
                    onPressed: () {
                      ref
                          .read(onboardingCarouselProvider.notifier)
                          .skipToLast(lastIndex);
                    },
                  ),
                ),
              ]
            : null,
        actionsPadding: .only(right: AppSpacing.xs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IndicatorCarousel(
            items: onboardingCarouselItems,
            controller: controller,
            currentIndex: currentIndex,
            onIndexChanged: (index) {
              ref.read(onboardingCarouselProvider.notifier).update(index);
            },
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 32,
            ),
            child: OnboardingBottomButtons(
              controller: controller,
              isLastPage: currentIndex == lastIndex,
            ),
          ),
        ],
      ),
    );
  }
}
