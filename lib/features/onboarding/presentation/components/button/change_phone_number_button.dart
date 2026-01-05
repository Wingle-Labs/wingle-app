import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_text_button.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// "전화번호 변경" 페이지로 이동하는 버튼
class ChangePhoneNumberButton extends ConsumerWidget {
  /// const 생성자
  const ChangePhoneNumberButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTextButton(
      onPressed: () =>
          context.pushNamed(OnboardingRoutes.changePhoneNumber.name),
      label: "onboarding.login.button.changePhoneNumber",
    );
  }
}
