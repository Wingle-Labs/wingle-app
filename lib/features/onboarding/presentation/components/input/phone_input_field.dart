import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 연락처(아이디) 입력 필드
class PhoneInputField extends StatelessWidget {
  /// 값 변경 콜백
  final ValueChanged<String> onChanged;

  /// 입력 컨트롤러
  final TextEditingController? controller;

  /// 검증 메시지
  final String? errorText;

  /// 클리어 버튼 표시 여부
  final bool showClearButton;

  /// 클리어 버튼 콜백
  final VoidCallback? onClear;

  /// 생성자
  const PhoneInputField({
    super.key,
    required this.onChanged,
    this.controller,
    this.errorText,
    this.showClearButton = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.inputFieldLabelInternal,
      children: [
        // ! Label
        DefaultText(
          'onboarding.login.field.phone.label',
          style: typography.body.copyWith(color: colors.textAlternative),
          policy: .cappedMedium,
        ),
        // ! Input Field
        DefaultOutlinedInputField(
          controller: controller,
          policy: .cappedMedium,
          keyboardType: .phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          onChanged: onChanged,
          hintText: 'onboarding.login.field.phone.hint',
          errorText: errorText,
          inputFormatters: AuthConstrants.phoneFormatter,
          onClear: onClear,
          showClearButton: showClearButton,
        ),
      ],
    );
  }
}
