import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/buttons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/features/auth/domain/usecases/request_phone_code.dart';
import 'package:wingle/features/auth/presentation/components/phone_textfield.dart';
import 'package:wingle/features/auth/presentation/providers/phone_auth_provider.dart';
import 'package:wingle/features/auth/presentation/states/phone_auth_state.dart';

/// 전화번호 인증 페이지
class PhoneAuthPage extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<PhoneAuthState>(phoneAuthProvider, (previous, next) {
      if (next.pushOtpCondition()) {
        RequestPhoneCode.navigateToOtp(context);
      }
    });

    return ScrollableScaffold(
      title: 'onboarding.phone.title',
      body: <Widget>[
        const DefaultPageHeader(title: 'onboarding.phone.instruction'),
        DefaultCard(child: PhoneTextField()),
      ],
      floatingActionButton: DefaultFloatingButton(
        onPressed: () async {
          await ref.read(phoneAuthProvider.notifier).requestPhoneCode();
        },
        disabled: !ref.watch(
          phoneAuthProvider.select((state) => state.phoneNumber.isValid),
        ),
        label: 'onboarding.phone.button.request',
        isLoading: ref.watch(
          phoneAuthProvider.select((state) => state.isSending),
        ),
      ),
    );
  }
}
