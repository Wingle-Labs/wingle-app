import 'package:easy_localization/easy_localization.dart';
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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
      inputFormatters: AuthConstrants.phoneFormatter,
      suffix: isSent
          ? TextButton(
              onPressed: ref.read(phoneAuthProvider.notifier).changePhoneNumber,
              child: Text("onboarding.phone.button.change".tr()),
            )
          : const SizedBox(),
      maxLength: AuthConstrants.phoneTextMaxLength,
      bottomPadding: 0,
    );
  }
}
