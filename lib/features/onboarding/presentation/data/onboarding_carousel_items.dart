import 'package:flutter/widgets.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
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
    content: DefaultPageHeader(
      title: 'onboarding.carousel.value.title',
      subtitle: 'onboarding.carousel.value.message',
      titleTextAlign: .center,
      subtitleTextAlign: .center,
      titleStyle: AppTypographyToken.nBody16,
      titlePolicy: TextScalePolicy.system,
      padding: .zero,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/logo.png'),
  ),
];
