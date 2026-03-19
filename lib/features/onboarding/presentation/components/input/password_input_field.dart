import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:wingle/app/config/theme/components/buttons/default_icon_button.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 재사용 가능한 비밀번호 입력 필드
class PasswordInputField extends StatelessWidget {
  /// 현재 입력된 비밀번호 값
  final String value;

  /// 비밀번호 표시 여부
  final bool isVisible;

  /// 비밀번호 유효성 검사 결과
  final bool isValid;

  /// 비밀번호 변경 콜백
  final ValueChanged<String> onChanged;

  /// 비밀번호 표시 토글 콜백
  final VoidCallback onToggleVisibility;

  /// 비밀번호 재입력 필드 여부
  final bool isConfirm;

  /// 생성자
  const PasswordInputField({
    super.key,
    required this.value,
    required this.isVisible,
    required this.isValid,
    required this.onChanged,
    required this.onToggleVisibility,
    this.isConfirm = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.inputFieldLabelInternal,
      children: [
        DefaultText(
          "비밀번호를 ${isConfirm ? '다시 ' : ''}입력해주세요",
          style: typography.body.copyWith(color: colors.textAlternative),
          policy: .cappedMedium,
        ),
        DefaultOutlinedInputField(
          policy: .cappedMedium,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          onChanged: onChanged,
          hintText: "비밀번호 ${isConfirm ? '재' : ''}입력",
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r'[\u{1F300}-\u{1FAFF}]', unicode: true),
            ),
          ],
          suffix: DefaultIconButton(
            icon: isVisible
                ? Iconify(Ph.eye_closed_bold, color: colors.textAssistive)
                : Iconify(
                    Ic.baseline_remove_red_eye,
                    color: colors.textAssistive,
                  ),
            onPressed: onToggleVisibility,
            isEnabled: true,
          ),
          obscureText: !isVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 입력해주세요';
            }
            if (value.length < 8) {
              return '8자리 이상 입력해주세요';
            }
            if (value.contains(' ')) {
              return '공백을 포함할 수 없습니다';
            }
            if (!RegExp(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
            ).hasMatch(value)) {
              return '영문 소문자, 대문자, 숫자, 특수문자를 모두 포함해야 합니다';
            }
            if (isConfirm && !isValid) {
              return '비밀번호가 일치하지 않습니다';
            }
            return null;
          },
        ),
      ],
    );
  }
}
