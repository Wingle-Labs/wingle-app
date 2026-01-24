import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_text_button.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 비밀번호 재설정 페이지로 이동하는 버튼
class ResetPasswordButton extends ConsumerWidget {
  /// const 생성자
  const ResetPasswordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextButton(
      onPressed: () => context.pushNamed(OnboardingRoutes.phone.name),
      label: 'onboarding.login.button.reset-password',
    );
  }
}
