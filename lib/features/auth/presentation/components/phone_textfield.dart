import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/underline_text_field.dart';

/// 전화번호 입력 TextField
class PhoneTextField extends ConsumerStatefulWidget {
  /// 생성자
  const PhoneTextField({super.key});

  @override
  ConsumerState<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends ConsumerState<PhoneTextField> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnderlineField(
          controller: _phoneController,
          label: 'onboarding.phone.textfield.label',
          hint: 'onboarding.phone.textfield.hint',
          keyboardType: .phone,
          autofillHints: [AutofillHints.telephoneNumberDevice],
        ),
      ],
    );
  }
}
