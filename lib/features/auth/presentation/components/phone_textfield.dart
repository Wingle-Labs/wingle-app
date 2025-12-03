import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/underline_text_field.dart';
import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';
import 'package:wingle/features/auth/presentation/providers/phone_auth_provider.dart';

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
    final isSent = ref.watch(phoneAuthProvider.select((state) => state.isSent));
    final isSending = ref.watch(
      phoneAuthProvider.select((state) => state.isSending),
    );

    return UnderlineField(
      controller: _phoneController,
      onChanged: ref.read(phoneAuthProvider.notifier).onChanged,
      label: 'onboarding.phone.textfield.label',
      hint: 'onboarding.phone.textfield.helper',
      keyboardType: .phone,
      autofillHints: [AutofillHints.telephoneNumberDevice],
      enabled: !isSent && !isSending,
      suffix: isSent
          ? TextButton(
              onPressed: ref.read(phoneAuthProvider.notifier).changePhoneNumber,
              // child: Text("onboarding.phone.button.change".tr()),
              child: Text('번호를 변경하고 싶어요'),
            )
          : const SizedBox(),
      maxLength: AuthConstrants.phoneMaxLength,
      bottomPadding: 0,
    );
  }
}
