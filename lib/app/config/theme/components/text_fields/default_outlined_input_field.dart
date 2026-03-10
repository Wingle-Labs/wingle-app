import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
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

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// Trailing 위젯
  final Widget? suffix;

  /// Clear 버튼 클릭 시 Callback
  final VoidCallback? onClear;

  /// Clear 버튼 노출 여부
  final bool showClearButton;

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
    this.inputFormatters,
    this.suffix,
    this.onClear,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextScaleWrapper(
      policy: policy,
      child: TextFormField(
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofillHints: autofillHints,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: colors.primaryNormal,
        cursorErrorColor: colors.statusNegative,
        cursorWidth: AppLineWidth.inputFieldCursor,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: AppContainerSize.inputFieldMinimun,
          ),
          isDense: true,
          hintText: hintText?.tr(),
          hintStyle: typography.body.copyWith(color: colors.textAssistive),
          filled: true,
          fillColor: colors.backgroundNormal,
          contentPadding: const EdgeInsets.all(AppPadding.textfield),
          // 입력 가능 상태
          enabledBorder: getBorder(colors.strokeStructuralBorder),
          // 입력 중인 상태
          focusedBorder: getBorder(colors.primaryNormal),
          // 에러 상태
          errorBorder: getBorder(colors.statusNegative),
          // 에러 상태(입력 중)
          focusedErrorBorder: getBorder(colors.statusNegative),
          // 비활성화 상태
          disabledBorder: getBorder(colors.strokeStructuralBorder),
          errorText: errorText?.tr(),
          suffixIconColor: colors.interactionInactive,
          suffixIcon: suffix != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    suffix as Widget,
                    const SizedBox(width: AppPadding.textfieldSuffix),
                  ],
                )
              : onClear != null && showClearButton
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        applyTextScaling: true,
                        size: AppIconSize.large,
                        fontWeight: AppFontWeight.regular,
                        semanticLabel: "Clear".tr(),
                      ),
                      onPressed: onClear,
                    ),
                    const SizedBox(width: AppPadding.textfieldSuffix),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  /// 입력 필드를 감싸는 테두리 스타일 반환 함수
  OutlineInputBorder getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: AppRadius.iosStyleRadius,
      borderSide: BorderSide(
        color: color,
        width: AppLineWidth.inputFieldOutline,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    );
  }
}
