import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/text_fields/underline_text_field.dart';

/// 전화번호 입력 TextField
class PhoneOtpTextField extends StatefulWidget {
  /// 생성자
  const PhoneOtpTextField({super.key});

  @override
  State<PhoneOtpTextField> createState() => _PhoneOtpTextFieldState();
}

class _PhoneOtpTextFieldState extends State<PhoneOtpTextField> {
  final TextEditingController _phoneOtpController = TextEditingController();

  @override
  void dispose() {
    _phoneOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnderlineField(
          controller: _phoneOtpController,
          label: 'onboarding.phone.otp.textfield.label',
          keyboardType: .number,
          autofillHints: [AutofillHints.oneTimeCode],
        ),
      ],
    );
  }
}
