import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_elevated_button.dart';
import 'package:wingle/app/config/theme/components/bottons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 회원가입 페이지로 이동하는 버튼
class SignupButton extends ConsumerWidget {
  /// TextButton 또는 ElevatedButton으로 구현
  final bool isInOnboarding;

  /// const 생성자
  const SignupButton({super.key, this.isInOnboarding = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final text = isInOnboarding
        ? 'onboarding.button.signUp'
        : 'onboarding.login.button.signUp';

    return isInOnboarding
        ? DefaultElevatedButton(
            onPressed: () => context.pushNamed(OnboardingRoutes.signup.name),
            backgroundColor: theme.primaryColor,
            foregroundColor: AppColor.darkButtonText,
            child: SizedBox(
              width: double.infinity,
              child: Text(text.tr(), textAlign: .center),
            ),
          )
        : DefaultTextButton(
            onPressed: () => context.pushNamed(OnboardingRoutes.signup.name),
            label: text,
          );
  }
}
