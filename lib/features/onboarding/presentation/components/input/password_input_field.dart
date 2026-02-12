import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:wingle/app/config/theme/components/bottons/default_icon_button.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_outlined_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/features/onboarding/presentation/providers/login_page_provider.dart';

/// 비밀번호 입력 필드
class PasswordInputField extends ConsumerWidget {
  /// 생성자
  const PasswordInputField({super.key});

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
          '비밀번호를 입력해주세요',
          style: typography.body.copyWith(color: colors.textInactive),
          policy: .cappedMedium,
        ),
        // ! Input Field
        DefaultOutlinedInputField(
          policy: .cappedMedium,
          keyboardType: TextInputType.visiblePassword,
          autofillHints: const [AutofillHints.password],
          onChanged: ref.read(loginPageProvider.notifier).updatePassword,
          hintText: '비밀번호',
          errorText: loginState.password.isEmpty || loginState.isPasswordValid
              ? null
              : '8자리 이상 입력해주세요',
          // 이모지를 입력하지 못하게 제한
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r'[\u{1F300}-\u{1FAFF}]', unicode: true),
            ),
          ],
          suffix: DefaultIconButton(
            icon: loginState.isPasswordVisible
                ? Iconify(Ph.eye_closed_bold, color: colors.textInactive)
                : Iconify(
                    Ic.baseline_remove_red_eye,
                    color: colors.textInactive,
                  ),
            onPressed: ref
                .read(loginPageProvider.notifier)
                .togglePasswordVisibility,
            isEnabled: true,
          ),
          obscureText: !loginState.isPasswordVisible,
        ),
      ],
    );
  }
}
