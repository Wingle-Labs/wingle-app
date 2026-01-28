import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';

/// 연락처(아이디) 입력 필드
class PhoneInputField extends ConsumerWidget {
  /// 생성자
  const PhoneInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typography = context.typography;
    final loginState = ref.watch(loginPageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.inputFieldLabelInternal,
      children: [
        // ! Label
        DefaultText(
          '아이디를 입력해주세요',
          style: typography.body.copyWith(color: colors.textInactive),
          policy: .cappedMedium,
        ),
        // ! Input Field
        DefaultOutlinedInputField(
          policy: .cappedMedium,
          keyboardType: .phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          onChanged: ref.read(loginPageProvider.notifier).updatePhone,
          hintText: '연락처',
          errorText: loginState.phone.isEmpty || loginState.isPhoneValid
              ? null
              : '010으로 시작하는 11자리 숫자를 입력하세요',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onClear: () => ref.read(loginPageProvider.notifier).updatePhone(''),
          showClearButton: loginState.phone.isNotEmpty,
        ),
      ],
    );
  }
}
