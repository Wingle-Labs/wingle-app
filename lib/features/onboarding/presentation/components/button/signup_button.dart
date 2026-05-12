import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 회원가입 페이지로 이동하는 버튼
class SignupButton extends ConsumerWidget {
  /// TextButton 또는 ElevatedButton으로 구현
  final bool isInOnboarding;

  /// const 생성자
  const SignupButton({super.key, this.isInOnboarding = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = isInOnboarding
        ? 'onboarding.button.signUp'
        : 'onboarding.login.button.signUp';
    final typography = context.typography;

    return isInOnboarding
        ? DefaultFilledButton(
            onPressed: () => context.pushNamed(OnboardingRoutes.agreement.name),
            label: text,
            textStyle: typography.buttonLarge,
            variant: .fullWidth,
          )
        : DefaultTextButton(
            onPressed: () => context.pushNamed(OnboardingRoutes.agreement.name),
            label: text,
            textStyle: typography.buttonSmall,
            foregroundColor: context.colors.textNeutral,
          );
  }
}
