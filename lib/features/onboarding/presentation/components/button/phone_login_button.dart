import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 휴대폰 번호 로그인 버튼
class PhoneLoginButton extends ConsumerWidget {
  /// const 생성자
  const PhoneLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextButton(
      onPressed: () => context.pushNamed(OnboardingRoutes.login.name),
      label: 'onboarding.button.login',
      variant: .fullWidth,
    );
  }
}
