import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/underline_text_field.dart';

/// 전화번호 입력 TextField
class PhoneOtpTextField extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneOtpTextField({super.key});

  @override
  ConsumerState<PhoneOtpTextField> createState() => _PhoneOtpTextFieldState();
}

class _PhoneOtpTextFieldState extends ConsumerState<PhoneOtpTextField> {
  final TextEditingController _phoneOtpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnderlineField(
          controller: _phoneOtpController,
          label: 'onboarding.phone.otp.textfield.label',
          keyboardType: TextInputType.number,
          autofillHints: [AutofillHints.oneTimeCode],
        ),
      ],
    );
  }
}
