import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/cards/guide_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 카드 컴포넌트 프리뷰
class CardsPage extends StatelessWidget {
  /// 생성자
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final cardHeight = context.knobs.double.slider(
      label: 'Card Height',
      initialValue: 128,
      min: 80,
      max: 240,
    );
    final centered = context.knobs.object.dropdown<bool>(
      label: 'Guide Centered',
      options: const [false, true],
      initialOption: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cards', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'DefaultCard, GuideCard',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            Text('DefaultCard', style: typography.main),
            const SizedBox(height: 12),
            DefaultCard(
              height: cardHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultText(
                    'DefaultCard',
                    style: typography.main,
                    isTranslationKey: false,
                  ),
                  const SizedBox(height: 8),
                  DefaultText(
                    '카드 내부 콘텐츠를 토큰 기반 padding과 border로 감쌉니다.',
                    color: colors.textAlternative,
                    isTranslationKey: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('GuideCard', style: typography.main),
            const SizedBox(height: 12),
            DefaultCard(
              child: GuideCard(
                title: 'onboarding.agreement.guide.title',
                message: 'onboarding.agreement.guide.message',
                crossAxisAlignment: centered
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                textAlign: centered ? TextAlign.center : TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
