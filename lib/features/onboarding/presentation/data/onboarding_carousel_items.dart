import 'package:flutter/widgets.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/text/app_typography_token.dart';

import '../models/onboarding_carousel_item.dart';

/// Onboarding 페이지의 Carousel 아이템들
const onboardingCarouselItems = [
  OnboardingCarouselItem(
    content: GuideCard(
      title: 'onboarding.carousel.exclusiveChat.title',
      message: 'onboarding.carousel.exclusiveChat.message',
      crossAxisAlignment: .center,
      textAlign: .center,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/onboarding/chain.png'),
  ),
  OnboardingCarouselItem(
    content: GuideCard(
      title: 'onboarding.carousel.rotationDating.title',
      message: 'onboarding.carousel.rotationDating.message',
      crossAxisAlignment: .center,
      textAlign: .center,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/onboarding/puzzle.png'),
  ),
  OnboardingCarouselItem(
    content: GuideCard(
      title: 'onboarding.carousel.identityVerification.title',
      message: 'onboarding.carousel.identityVerification.message',
      crossAxisAlignment: .center,
      textAlign: .center,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/onboarding/secure.png'),
  ),
  OnboardingCarouselItem(
    content: Column(
      mainAxisAlignment: .center,
      spacing: AppSpacing.sm,
      children: [
        DefaultText(
          'onboarding.carousel.value.title',
          textAlign: .center,
          style: AppTypographyToken.nBody16,
        ),
        DefaultInstruction(
          'onboarding.carousel.value.message',
          textAlign: .center,
          padding: .zero,
        ),
      ],
    ),
    image: AssetImage('assets/images/logo.png'),
  ),
];
