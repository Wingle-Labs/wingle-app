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
      title: "커넥트 이후 독점 대화 기능",
      message: "개울가에 이르니, 며칠째 보이지 않던 소녀가 건너편 가에 앉아 물장난을 하고 있었다.",
      crossAxisAlignment: .center,
      textAlign: .center,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/onboarding/chain.png'),
  ),
  OnboardingCarouselItem(
    content: GuideCard(
      title: "앱으로 간편하게 로테이션 소개팅",
      message: "소녀의 흰 얼굴이, 분홍 스웨터가, 남색 스커트가, 안고 있는 꽃과 함께 범벅이 된다.",
      crossAxisAlignment: .center,
      textAlign: .center,
      spacing: AppSpacing.sm,
    ),
    image: AssetImage('assets/images/onboarding/puzzle.png'),
  ),
  OnboardingCarouselItem(
    content: GuideCard(
      title: "도용 걱정 없는 철저한 본인 인증",
      message: "이것만은 소녀가 흉내 내지 못할, 자기 혼자만이 할 수 있는 일인 것이다.",
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
          "조건보다 중요한 건 가치",
          textAlign: .center,
          style: AppTypographyToken.nBody16,
        ),
        DefaultInstruction("윙글과 함께 시작해보세요", textAlign: .center, padding: .zero),
      ],
    ),
    image: AssetImage('assets/images/logo.png'),
  ),
];
