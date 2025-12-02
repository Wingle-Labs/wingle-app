import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/config/theme/components/bottons/default_floating_button.dart';
import 'package:wingle/app/config/theme/components/cards/default_card.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/wrappers/scrollable_scaffold.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/auth/presentation/components/phone_otp_textfield.dart';

/// 전화번호 인증 페이지
class PhoneOtpPage extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneOtpPage({super.key});

  @override
  ConsumerState<PhoneOtpPage> createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends ConsumerState<PhoneOtpPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      title: 'onboarding.phone.otp.title',
      body: <Widget>[
        DefaultInstruction(
          'onboarding.phone.otp.instruction',
        ),
        DefaultCard(child: PhoneOtpTextField()),
      ],
      floatingActionButton: DefaultFloatingButton(
        onPressed: () {
          context.push(
            AppRoutes.fullPath([AppRoutes.onboarding, AppRoutes.age]),
          );
        },
        label: 'onboarding.phone.otp.button.done',
        isLoading: false,
      ),
    );
  }
}
