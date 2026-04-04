import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// "전화번호 변경" 페이지로 이동하는 버튼
class ChangePhoneNumberButton extends ConsumerWidget {
  /// const 생성자
  const ChangePhoneNumberButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.typography;
    return DefaultTextButton(
      onPressed: () =>
          context.pushNamed(OnboardingRoutes.changePhoneNumber.name),
      label: "onboarding.login.button.changePhoneNumber",
      textStyle: typography.buttonSmall,
      foregroundColor: context.colors.textNeutral,
    );
  }
}
