import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/bottons/default_elevated_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/auth/presentation/components/phone_textfield.dart';
import 'package:wingle/features/onboarding/presentation/components/button/change_phone_number_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/reset_password_button.dart';
import 'package:wingle/features/onboarding/presentation/components/button/signup_button.dart';

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
    return ScrollableScaffold(
      title: "onboarding.login.title",
      floatingActionButton: DefaultElevatedButton(
        child: Text("onboarding.login.button.done".tr()),
        onPressed: () {},
      ),
      crossAxisAlignment: .center,
      body: [
        // TODO: 구현
        DefaultCard(
          child: Column(
            mainAxisSize: .min,
            children: [
              PhoneTextField(),
              // TODO: 비밀번호 입력 Field로 변경
              TextFormField(),
              Padding(padding: .only(bottom: AppSpacing.md)),
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
    );
  }
}
