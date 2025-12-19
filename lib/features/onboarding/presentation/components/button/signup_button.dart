import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_elevated_button.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 회원가입 페이지로 이동하는 버튼
class SignupButton extends ConsumerWidget {
  /// const 생성자
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultElevatedButton(
      onPressed: () => context.pushNamed(OnboardingRoutes.signup.name),
      backgroundColor: theme.primaryColor,
      foregroundColor: AppColor.darkButtonText,
      child: SizedBox(
        width: double.infinity,
        child: Text('onboarding.button.signUp'.tr(), textAlign: .center),
      ),
    );
  }
}
