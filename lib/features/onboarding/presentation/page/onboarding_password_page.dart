import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/input/password_input_field.dart';
import 'package:wingle/features/onboarding/presentation/components/input/phone_number_read_only_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_password_input_page_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// Onboarding에서 Password를 입력하는 페이지
class OnboardingPasswordPage extends ConsumerStatefulWidget {
  /// 인증된 유저 전화번호
  final String phoneNumber;

  /// 생성자
  const OnboardingPasswordPage({super.key, required this.phoneNumber});

  @override
  ConsumerState<OnboardingPasswordPage> createState() =>
      _OnboardingPasswordPageState();
}

class _OnboardingPasswordPageState
    extends ConsumerState<OnboardingPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingPasswordInputPageProvider);
    final notifier = ref.watch(onboardingPasswordInputPageProvider.notifier);

    return ScrollableScaffold(
      canPop: false,
      onPop: showOnPop,
      spacing: 0,
      body: [
        DefaultInstruction('onboarding.password.title', textAlign: .left),
        DefaultText('onboarding.password.instruction', policy: .cappedLarge),
        SizedBox(height: AppSpacing.xl),
        PhoneNumberReadOnlyField(phoneNumber: widget.phoneNumber),
        SizedBox(height: AppSpacing.lg),
        PasswordInputField(
          value: state.password,
          isVisible: state.isPasswordVisible,
          isValid: state.isPasswordValid,
          onChanged: notifier.updatePassword,
          onToggleVisibility: notifier.togglePasswordVisibility,
        ),
        SizedBox(height: AppSpacing.md),
        PasswordInputField(
          value: state.confirmPassword,
          isVisible: state.isConfirmPasswordVisible,
          isValid: state.isPasswordEqual,
          onChanged: notifier.updateConfirmPassword,
          onToggleVisibility: notifier.toggleConfirmPasswordVisibility,
          isConfirm: true,
        ),
      ],
      floatingActionButton: DefaultFloatingButton(
        label: 'onboarding.password.button.complete',
        onPressed: () async {
          final result = await notifier.submit();

          if (!context.mounted) return;
          if (result) {
            DefaultToast.show(context, 'onboarding.password.toast.success');
            context.goNamed(OnboardingRoutes.login.name);
          } else {
            DefaultToast.show(context, 'onboarding.password.toast.failure');
          }
        },
        isLoading: state.isLoading,
      ),
    );
  }

  void showOnPop() {
    DefaultBottomSheet.show(
      context,
      isHandleContained: true,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          DefaultInstruction('onboarding.password.bottomSheet.title'),
          DefaultText('onboarding.password.bottomSheet.description'),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
      onMain: () {
        context.pop();
      },
      mainLabel: 'onboarding.password.bottomSheet.mainLabel',
      onSub: () {
        context.pop();
        context.pop();
      },
      subLabel: 'onboarding.password.bottomSheet.subLabel',
    );
  }
}
