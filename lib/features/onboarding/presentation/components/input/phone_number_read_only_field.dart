import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 비밀번호 입력 필드
class PhoneNumberReadOnlyField extends ConsumerWidget {
  /// 전화번호
  final String phoneNumber;

  /// 생성자
  const PhoneNumberReadOnlyField({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.inputFieldLabelInternal,
      children: [
        // ! Label
        DefaultText(
          'onboarding.password.field.phone.label',
          style: typography.body.copyWith(color: colors.textAlternative),
          policy: .cappedMedium,
        ),
        // ! Input Field
        DefaultOutlinedInputField(
          policy: .cappedMedium,
          hintText: 'onboarding.password.field.phone.hint',
          initialValue: phoneNumber,
          isDisabled: true,
        ),
      ],
    );
  }
}
