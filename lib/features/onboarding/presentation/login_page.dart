import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/components/wrappers/constrained_scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/components/button/change_phone_number_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/reset_password_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/signup_button.dart';
import 'package:wingle/features/onboarding/presentation/components/input/password_input_field.dart';
import 'package:wingle/features/onboarding/presentation/components/input/phone_input_field.dart';

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
    final colorScheme = context.colors;
    final typography = context.typography;

    return ConstrainedScrollableScaffold(
      padding: .zero,
      appBar: AppBar(backgroundColor: colorScheme.background),
      floatingActionButton: Padding(
        padding: .symmetric(horizontal: AppPadding.btnHorizontal),
        child: DefaultFilledButton(
          onPressed: () {},
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
                TextScaleWrapper(
                  policy: .cappedLarge,
                  child: DefaultInstruction("로그인"),
                ),
                TextScaleWrapper(
                  policy: .cappedLarge,
                  child: Text(
                    "여기서 소녀는 아래편으로 한 삼 마장쯤,\n소년은 우대로 한 십 리 가까운 길을 가야 한다.",
                    style: typography.body,
                  ),
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
                TextScaleWrapper(
                  policy: .cappedLarge,
                  child: PhoneInputField(),
                ),

                TextScaleWrapper(
                  policy: .cappedLarge,
                  child: PasswordInputField(),
                ),
              ],
            ),
          ),

          SizedBox(
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Expanded(child: ChangePhoneNumberButton()),
                Expanded(child: ResetPasswordButton()),
                Expanded(child: SignupButton(isInOnboarding: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
