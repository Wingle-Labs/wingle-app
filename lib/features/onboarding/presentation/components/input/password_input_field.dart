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
import 'package:wingle/features/auth/domain/models/password.dart';

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

  /// 입력 컨트롤러
  final TextEditingController? controller;

  /// 비밀번호 표시 토글 콜백
  final VoidCallback onToggleVisibility;

  /// 비밀번호 재입력 필드 여부
  final bool isConfirm;

  /// 포커스 시 스크롤 여백
  final EdgeInsets scrollPadding;

  /// 필드 외부 탭 시 포커스 해제 여부
  final bool unfocusOnTapOutside;

  /// 생성자
  const PasswordInputField({
    super.key,
    required this.value,
    required this.isVisible,
    required this.isValid,
    required this.onChanged,
    required this.onToggleVisibility,
    this.controller,
    this.isConfirm = false,
    this.scrollPadding = const EdgeInsets.all(20),
    this.unfocusOnTapOutside = true,
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
          isConfirm
              ? 'onboarding.password.field.confirm.label'
              : 'onboarding.login.field.password.label',
          style: typography.body.copyWith(color: colors.textAlternative),
          policy: .cappedMedium,
        ),
        DefaultOutlinedInputField(
          controller: controller,
          policy: .cappedMedium,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          onChanged: onChanged,
          hintText: isConfirm
              ? 'onboarding.password.field.confirm.hint'
              : 'onboarding.login.field.password.hint',
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r'[\u{1F300}-\u{1FAFF}]', unicode: true),
            ),
          ],
          scrollPadding: scrollPadding,
          unfocusOnTapOutside: unfocusOnTapOutside,
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
              return 'common.validation.password.required';
            }
            final password = Password(value);
            if (!password.isValid) {
              return password.errorText;
            }
            if (isConfirm && !isValid) {
              return 'common.validation.password.mismatch';
            }
            return null;
          },
        ),
      ],
    );
  }
}
