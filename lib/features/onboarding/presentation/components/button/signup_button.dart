import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 회원가입 페이지로 이동하는 버튼
class SignupButton extends ConsumerWidget {
  /// const 생성자
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => context.pushNamed(OnboardingRoutes.phone.name),
      child: Text('onboarding.button.signUp'.tr()),
    );
  }
}
