import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/basic_profile_input_scaffold.dart';
import 'package:wingle/features/onboarding/presentation/constants/basic_profile_input_constants.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_profile_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 회사 이메일 인증 페이지.
class BasicProfileCompanyEmailPage extends ConsumerWidget {
  /// 생성자.
  const BasicProfileCompanyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobProfileProvider);
    final notifier = ref.read(jobProfileProvider.notifier);
    final canContinue = state.isVerificationCodeSent
        ? state.canConfirmVerificationCode
        : state.canSendVerificationEmail;

    void navigateToCompanyInput() {
      OnboardingRouteChain.goPrevious(
        context,
        OnboardingRouteFlow.profileInput,
        OnboardingRoutes.basicProfileCompanyEmail,
      );
    }

    void navigateToEducation() {
      context.pushNamed(OnboardingRoutes.basicProfileEducation.name);
    }

    return BasicProfileInputScaffold(
      currentStep: BasicProfileInputConstants.companyStep,
      totalSteps: BasicProfileInputConstants.totalSteps,
      title: 'onboarding.basicProfile.companyEmail.title',
      subtitle: 'onboarding.basicProfile.companyEmail.subtitle',
      buttonLabel: 'common.button.next',
      isLoading: state.isSubmitting,
      disabled: state.isSubmitting || !canContinue,
      canPop: false,
      forceBackButton: true,
      appBarTrailing: _SkipAction(onTap: navigateToEducation),
      onBackPressed: navigateToCompanyInput,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navigateToCompanyInput();
      },
      onPressed: () async {
        final success = state.isVerificationCodeSent
            ? await notifier.confirmVerificationCode()
            : await notifier.sendVerificationEmail();
        if (!context.mounted) return;

        if (success && state.isVerificationCodeSent) {
          navigateToEducation();
          return;
        }

        if (success) {
          DefaultToast.show(
            context,
            'onboarding.basicProfile.companyEmail.codeSent',
          );
          return;
        }

        DefaultToast.show(
          context,
          ref.read(jobProfileProvider).verificationCodeErrorMessage ??
              ref.read(jobProfileProvider).emailVerificationErrorMessage ??
              ApiErrorMessages.verifyJobEmailFailed,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultInputField(
            labelText: 'onboarding.basicProfile.companyEmail.emailLabel',
            hintText: 'onboarding.basicProfile.companyEmail.emailHint',
            assistiveText:
                'onboarding.basicProfile.companyEmail.emailAssistive',
            initialValue: state.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: notifier.updateEmail,
            errorText: state.emailVerificationErrorMessage,
          ),
          if (state.isVerificationCodeSent) ...[
            const SizedBox(height: AppSpacing.s20),
            DefaultInputField(
              labelText: 'onboarding.basicProfile.companyEmail.codeLabel',
              hintText: 'onboarding.basicProfile.companyEmail.codeHint',
              initialValue: state.verificationCode,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: notifier.updateVerificationCode,
              errorText: state.verificationCodeErrorMessage,
            ),
          ],
        ],
      ),
    );
  }
}

class _SkipAction extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipAction({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        child: DefaultText(
          'onboarding.button.skip',
          style: context.typography.body.copyWith(
            color: context.colors.textAlternative,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
