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
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/presentation/components/input/password_input_field.dart';
import 'package:wingle/features/onboarding/presentation/components/input/phone_number_read_only_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_password_input_page_provider.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// Onboarding에서 Password를 입력하는 페이지
class OnboardingPasswordPage extends ConsumerStatefulWidget {
  /// 인증된 유저 정보 객체
  final PortoneVerifiedCustomerDto user;

  /// 생성자
  const OnboardingPasswordPage({super.key, required this.user});

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
        DefaultInstruction("비밀번호 설정", textAlign: .left),
        DefaultText("영문 소문자, 대문자, 특수 기호를 포함하여 설정해주세요.", policy: .cappedLarge),
        SizedBox(height: AppSpacing.xl),
        PhoneNumberReadOnlyField(
          phoneNumber: widget.user.phoneNumber.toString(),
        ),
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
        label: "회원가입 완료",
        onPressed: () async {
          final result = await notifier.submit();

          if (!context.mounted) return;
          if (result) {
            DefaultToast.show(context, "회원가입이 완료되었습니다.");
            context.goNamed(OnboardingRoutes.login.name);
          } else {
            DefaultToast.show(context, "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
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
          DefaultInstruction("이전 단계로 이동하시겠어요?"),
          DefaultText("이전 단계로 이동하면 본인 인증을 다시 진행해야 해요"),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
      onMain: () {
        context.pop();
      },
      mainLabel: "가입 계속하기",
      onSub: () {
        context.pop();
        context.pop();
      },
      subLabel: "이전 단계로 이동",
    );
  }
}
