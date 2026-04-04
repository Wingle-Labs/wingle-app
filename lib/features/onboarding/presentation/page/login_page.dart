import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/dividers/default_vertical_divider.dart';
import 'package:wingle/app/config/theme/components/states/default_toast.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/components/button/change_phone_number_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/reset_password_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/signup_button.dart';
import 'package:wingle/features/onboarding/presentation/components/input/password_input_field.dart';
import 'package:wingle/features/onboarding/presentation/components/input/phone_input_field.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';

/// 로그인 페이지
class LoginPage extends ConsumerStatefulWidget {
  /// const 생성자
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final state = ref.watch(loginPageProvider);
    final notifier = ref.read(loginPageProvider.notifier);

    return ConstrainedScrollableScaffold(
      padding: .zero,
      appBar: DefaultAppBar(),
      floatingActionButton: Padding(
        padding: .symmetric(horizontal: AppPadding.btnHorizontal),
        child: DefaultFilledButton(
          isDisabled: !state.canLogin,
          onPressed: () async {
            final isSuccess = await notifier.submit();
            if (!context.mounted) return;

            if (isSuccess) {
              DefaultToast.show(context, 'onboarding.login.toast.success');
              final nextPath = _nextPathForStatus(
                ref.read(loginPageProvider).profileStatus,
              );
              context.go(nextPath);
              return;
            }

            final message =
                ref.read(loginPageProvider).errorMessage ??
                'common.error.api.loginFailed';
            DefaultToast.show(context, message);
          },
          label: "onboarding.login.button.done",
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // ! 로그인 안내
          Container(
            padding: .symmetric(horizontal: AppPadding.scaffold),
            margin: .only(top: AppPadding.vertical, bottom: AppPadding.card),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                DefaultInstruction('onboarding.login.title'),
                DefaultText(
                  'onboarding.login.instruction',
                  style: typography.bodySub,
                  policy: .cappedMedium,
                ),
              ],
            ),
          ),

          // ! 로그인 정보 입력
          Container(
            padding: .symmetric(
              vertical: AppPadding.card,
              horizontal: AppPadding.scaffold,
            ),
            child: Column(
              spacing: AppSpacing.xs,
              children: [
                // ! 전화번호 입력
                PhoneInputField(
                  controller: notifier.phoneController,
                  onChanged: notifier.updatePhone,
                  errorText: state.phoneErrorText,
                  onClear: notifier.clearPhone,
                  showClearButton: state.phone.isNotEmpty,
                ),
                PasswordInputField(
                  controller: notifier.passwordController,
                  value: state.password,
                  isVisible: state.isPasswordVisible,
                  isValid: state.isPasswordValid,
                  onChanged: notifier.updatePassword,
                  onToggleVisibility: () => notifier.togglePasswordVisibility(),
                ),
              ],
            ),
          ),

          Container(
            padding: .symmetric(horizontal: AppPadding.scaffold),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Expanded(child: ChangePhoneNumberButton()),
                DefaultVerticalDivider(
                  textScalePolicy: .cappedLarge,
                  fontSize: context.typography.buttonSmall.fontSize,
                ),
                Expanded(child: ResetPasswordButton()),
                DefaultVerticalDivider(
                  textScalePolicy: .cappedLarge,
                  fontSize: context.typography.buttonSmall.fontSize,
                ),
                Expanded(child: SignupButton(isInOnboarding: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _nextPathForStatus(LoginProfileStatus? profileStatus) {
    if (profileStatus?.isApproved ?? true) {
      return AppRoute.home.path;
    }

    return AppRoute.onboarding.path;
  }
}
