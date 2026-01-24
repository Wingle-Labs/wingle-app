import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Label + 아웃라인 입력 필드
class DefaultOutlinedInputField extends StatelessWidget {
  /// 힌트 텍스트
  final String? hintText;

  /// 키보드 타입
  final TextInputType keyboardType;

  /// 비밀번호 입력 여부
  final bool obscureText;

  /// 자동 완성 힌트
  final List<String>? autofillHints;

  /// 에러 텍스트
  final String? errorText;

  /// 값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 텍스트 스케일링 정책
  final TextScalePolicy policy;

  /// 생성자
  const DefaultOutlinedInputField({
    super.key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autofillHints,
    this.errorText,
    this.onChanged,
    this.policy = TextScalePolicy.system,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextScaleWrapper(
      policy: policy,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofillHints: autofillHints,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: AppPadding.textfield),
          isDense: true,
          hintText: hintText?.tr(),
          hintStyle: typography.body.copyWith(color: colors.textInactive),
          filled: true,
          fillColor: colors.surface,
          contentPadding: const EdgeInsets.all(AppPadding.textfield),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.iosStyleRadius,
            borderSide: BorderSide(color: colors.primaryScale70, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.iosStyleRadius,
            borderSide: BorderSide(color: colors.primaryScale70, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.iosStyleRadius,
            borderSide: BorderSide(color: colors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.iosStyleRadius,
            borderSide: BorderSide(color: colors.error, width: 2),
          ),
          errorText: errorText?.tr(),
        ),
      ),
    );
  }
}
