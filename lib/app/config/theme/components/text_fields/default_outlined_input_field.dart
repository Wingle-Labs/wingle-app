import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Label + 아웃라인 입력 필드
class DefaultOutlinedInputField extends StatefulWidget {
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

  /// 입력 컨트롤러
  final TextEditingController? controller;

  /// 텍스트 스케일링 정책
  final TextScalePolicy policy;

  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;

  /// Leading 위젯
  final Widget? prefix;

  /// Trailing 위젯
  final Widget? suffix;

  /// Clear 버튼 클릭 시 Callback
  final VoidCallback? onClear;

  /// Clear 버튼 노출 여부
  final bool showClearButton;

  /// 비활성화 여부
  final bool isDisabled;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 초기 값
  final String? initialValue;

  /// Validator
  final String? Function(String?)? validator;

  /// 생성자
  const DefaultOutlinedInputField({
    super.key,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autofillHints,
    this.errorText,
    this.onChanged,
    this.controller,
    this.policy = TextScalePolicy.system,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.onClear,
    this.showClearButton = false,
    this.isDisabled = false,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.validator,
  }) : assert(
         controller == null || initialValue == null,
         'controller와 initialValue는 동시에 사용할 수 없습니다.',
       );

  @override
  State<DefaultOutlinedInputField> createState() =>
      _DefaultOutlinedInputFieldState();
}

class _DefaultOutlinedInputFieldState extends State<DefaultOutlinedInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _shouldShowValidation = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _showValidation();
    }
  }

  void _showValidation() {
    if (_shouldShowValidation) return;

    setState(() {
      _shouldShowValidation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return TextScaleWrapper(
      policy: widget.policy,
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        initialValue: widget.controller == null ? widget.initialValue : null,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        autofillHints: widget.autofillHints,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onEditingComplete: () {
          _showValidation();
          _focusNode.unfocus();
        },
        onTapOutside: (_) {
          _focusNode.unfocus();
        },
        enabled: !widget.isDisabled,
        textAlignVertical: TextAlignVertical.center,
        autovalidateMode: _shouldShowValidation
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        cursorColor: colors.primaryNormal,
        cursorErrorColor: colors.statusNegative,
        cursorWidth: AppLineWidth.inputFieldCursor,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            minHeight: AppContainerSize.inputFieldMinimun,
          ),
          isDense: true,
          hintText: widget.hintText?.tr(),
          hintStyle: typography.body.copyWith(color: colors.textAssistive),
          filled: true,
          fillColor: colors.backgroundNormal,
          contentPadding: const EdgeInsets.all(AppPadding.textfield),
          prefixIconColor: colors.interactionInactive,
          prefixIcon: widget.prefix != null
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: AppPadding.textfield,
                    right: AppPadding.textfieldSuffix,
                  ),
                  child: widget.prefix,
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
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
          errorText: _shouldShowValidation ? widget.errorText?.tr() : null,
          suffixIconColor: colors.interactionInactive,
          suffixIcon: widget.suffix != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.suffix as Widget,
                    const SizedBox(width: AppPadding.textfieldSuffix),
                  ],
                )
              : widget.onClear != null && widget.showClearButton
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: DefaultIcon(
                        icon: Icons.clear,
                        size: AppIconSize.md,
                        semanticLabel: 'common.action.clear'.tr(),
                      ),
                      onPressed: widget.onClear,
                    ),
                    const SizedBox(width: AppPadding.textfieldSuffix),
                  ],
                )
              : null,
        ),
        validator: widget.validator == null
            ? null
            : (value) {
                if (!_shouldShowValidation) return null;
                return widget.validator?.call(value)?.tr();
              },
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
