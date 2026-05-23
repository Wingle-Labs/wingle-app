import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/states/default_bottom_sheet.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/input/password_input_field.dart';
import 'package:wingle/features/onboarding/presentation/components/input/phone_number_read_only_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_password_input_page_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// Onboarding에서 Password를 입력하는 페이지
class OnboardingPasswordPage extends ConsumerWidget {
  /// 인증된 유저 전화번호
  final String phoneNumber;

  /// 생성자
  const OnboardingPasswordPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingPasswordInputPageProvider);
    final notifier = ref.watch(onboardingPasswordInputPageProvider.notifier);

    return ScrollableScaffold(
      canPop: false,
      onPop: () => _showOnPop(context),
      spacing: 0,
      body: [
        const DefaultPageHeader(
          title: 'onboarding.password.title',
          subtitle: 'onboarding.password.instruction',
        ),
        SizedBox(height: AppSpacing.s48),
        PhoneNumberReadOnlyField(phoneNumber: phoneNumber),
        SizedBox(height: AppSpacing.s32),
        PasswordInputField(
          value: state.password,
          isVisible: state.isPasswordVisible,
          isValid: state.isPasswordValid,
          onChanged: notifier.updatePassword,
          onToggleVisibility: notifier.togglePasswordVisibility,
        ),
        SizedBox(height: AppSpacing.s24),
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

  void _showOnPop(BuildContext context) {
    DefaultBottomSheet.show(
      context,
      isHandleContained: true,
      body: Column(
        crossAxisAlignment: .start,
        children: [
          const DefaultPageHeader(
            title: 'onboarding.password.bottomSheet.title',
            padding: EdgeInsets.zero,
          ),
          DefaultText('onboarding.password.bottomSheet.description'),
          SizedBox(height: AppSpacing.s16),
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
