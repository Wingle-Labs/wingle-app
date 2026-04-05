import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 기본 프로필 입력의 키(Height) 입력 페이지 스텁.
class BasicProfileHeightPage extends StatelessWidget {
  /// 생성자
  const BasicProfileHeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.heightStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.height.title',
      subtitle: null,
      buttonLabel: 'common.button.next',
      onPressed: () {
        context.pushNamed(OnboardingRoutes.age.name);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _HeightDigitBox(),
          const SizedBox(width: AppSpacing.xs),
          const _HeightDigitBox(),
          const SizedBox(width: AppSpacing.xs),
          const _HeightDigitBox(),
          const SizedBox(width: AppSpacing.sm),
          DefaultText(
            'CM',
            style: typography.title.copyWith(color: colors.textNeutral),
            isTranslationKey: false,
          ),
        ],
      ),
    );
  }
}

class _HeightDigitBox extends StatelessWidget {
  /// 생성자
  const _HeightDigitBox();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
    );
  }
}
