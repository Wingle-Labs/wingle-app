import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/component_tokens.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/text/app_typography.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Input Field 상태
enum DefaultInputFieldState {
  /// 기본
  defaultState,

  /// 값이 채워짐
  filled,

  /// 포커스됨
  focused,

  /// 에러
  error,
}

/// Input Field 타입
enum DefaultInputFieldType {
  /// 입력 + suffix
  inputSuffix,

  /// 입력 + prefix + suffix
  inputPrefixSuffix,

  /// 입력 + 보조 액션
  inputAssistiveAction,
}

/// Input Field 외형 variant
enum DefaultInputFieldVariant {
  /// 외곽선
  outlined,

  /// 밑줄
  underline,

  /// 멀티라인
  multiline,
}

/// 공용 Input Field
class DefaultInputField extends StatefulWidget {
  /// variant
  final DefaultInputFieldVariant variant;

  /// 명시적 상태 override
  final DefaultInputFieldState? state;

  /// 타입
  final DefaultInputFieldType type;

  /// 라벨
  final String? labelText;

  /// 힌트
  final String? hintText;

  /// 보조 텍스트
  final String? assistiveText;

  /// 에러 텍스트
  final String? errorText;

  /// 키보드 타입
  final TextInputType keyboardType;

  /// 비밀번호 여부
  final bool obscureText;

  /// 자동완성 힌트
  final List<String>? autofillHints;

  /// 값 변경
  final ValueChanged<String>? onChanged;

  /// controller
  final TextEditingController? controller;

  /// 텍스트 스케일 정책
  final TextScalePolicy policy;

  /// input formatter
  final List<TextInputFormatter>? inputFormatters;

  /// prefix
  final Widget? prefix;

  /// suffix
  final Widget? suffix;

  /// assistive action
  final Widget? assistiveAction;

  /// clear callback
  final VoidCallback? onClear;

  /// clear 버튼 표시
  final bool showClearButton;

  /// 비활성화 여부
  final bool isDisabled;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 초기 값
  final String? initialValue;

  /// validator
  final String? Function(String?)? validator;

  /// 외부 focus node
  final FocusNode? focusNode;

  /// min lines
  final int? minLines;

  /// max lines
  final int? maxLines;

  /// max length
  final int? maxLength;

  /// suffix semantic label
  final String? suffixSemanticLabel;

  /// 생성자
  const DefaultInputField({
    super.key,
    this.variant = DefaultInputFieldVariant.outlined,
    this.state,
    this.type = DefaultInputFieldType.inputSuffix,
    this.labelText,
    this.hintText,
    this.assistiveText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autofillHints,
    this.onChanged,
    this.controller,
    this.policy = TextScalePolicy.system,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.assistiveAction,
    this.onClear,
    this.showClearButton = false,
    this.isDisabled = false,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.validator,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.suffixSemanticLabel,
  }) : assert(
         controller == null || initialValue == null,
         'controller와 initialValue는 동시에 사용할 수 없습니다.',
       );

  @override
  State<DefaultInputField> createState() => _DefaultInputFieldState();
}

class _DefaultInputFieldState extends State<DefaultInputField> {
  FocusNode? _internalFocusNode;
  bool _shouldShowValidation = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant DefaultInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.removeListener(_handleFocusChange);
        _internalFocusNode?.dispose();
      }
      if (widget.focusNode == null) {
        _internalFocusNode = FocusNode();
      }
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _showValidation();
    }
    setState(() {});
  }

  void _showValidation() {
    if (_shouldShowValidation) {
      return;
    }
    setState(() {
      _shouldShowValidation = true;
    });
  }

  String get _currentText =>
      widget.controller?.text ?? widget.initialValue ?? '';

  DefaultInputFieldState get _resolvedState {
    if (widget.state != null) {
      return widget.state!;
    }
    if (widget.errorText != null) {
      return DefaultInputFieldState.error;
    }
    if (_focusNode.hasFocus) {
      return DefaultInputFieldState.focused;
    }
    if (_currentText.isNotEmpty) {
      return DefaultInputFieldState.filled;
    }
    return DefaultInputFieldState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final resolvedState = _resolvedState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          DefaultText(
            widget.labelText!,
            style: typography.body.copyWith(color: colors.textAlternative),
            policy: widget.policy,
          ),
          const SizedBox(height: AppComponentSpacing.inputLabelGap),
        ],
        TextScaleWrapper(
          policy: widget.policy,
          child: Theme(
            data: Theme.of(context).copyWith(platform: TargetPlatform.iOS),
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              inputFormatters: widget.inputFormatters,
              initialValue: widget.controller == null
                  ? widget.initialValue
                  : null,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              autofillHints: widget.autofillHints,
              readOnly: widget.readOnly,
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {});
              },
              onTap: widget.onTap,
              onEditingComplete: () {
                _showValidation();
                _focusNode.unfocus();
              },
              onTapOutside: (_) {
                _focusNode.unfocus();
              },
              enabled: !widget.isDisabled,
              maxLength: widget.maxLength,
              minLines: widget.variant == DefaultInputFieldVariant.multiline
                  ? widget.minLines
                  : 1,
              maxLines: widget.variant == DefaultInputFieldVariant.multiline
                  ? widget.maxLines
                  : 1,
              textAlignVertical: TextAlignVertical.center,
              autovalidateMode: _shouldShowValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              cursorColor: colors.primaryNormal,
              cursorErrorColor: colors.statusNegative,
              cursorWidth: AppLineWidth.inputFieldCursor,
              style: typography.body.copyWith(
                color: widget.isDisabled
                    ? colors.textAssistive
                    : resolvedState == DefaultInputFieldState.error
                    ? colors.statusNegative
                    : colors.textNormal,
              ),
              decoration: _buildDecoration(
                context,
                colors,
                typography,
                resolvedState,
              ),
              validator: widget.validator == null
                  ? null
                  : (value) {
                      if (!_shouldShowValidation) {
                        return null;
                      }
                      return widget.validator?.call(value)?.tr();
                    },
            ),
          ),
        ),
        if (_resolvedState == DefaultInputFieldState.error &&
            widget.errorText != null) ...[
          const SizedBox(height: AppComponentSpacing.inputAssistiveGap),
          DefaultText(
            widget.errorText!,
            style: typography.caption.copyWith(color: colors.statusNegative),
            policy: widget.policy,
          ),
        ] else if (widget.assistiveText != null) ...[
          const SizedBox(height: AppComponentSpacing.inputAssistiveGap),
          DefaultText(
            widget.assistiveText!,
            style: typography.caption.copyWith(color: colors.textAssistive),
            policy: widget.policy,
          ),
        ],
        if (widget.type == DefaultInputFieldType.inputAssistiveAction &&
            widget.assistiveAction != null) ...[
          const SizedBox(height: AppComponentSpacing.inputAssistiveActionGap),
          widget.assistiveAction!,
        ],
      ],
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    AppColorScheme colors,
    AppTypography typography,
    DefaultInputFieldState resolvedState,
  ) {
    return InputDecoration(
      constraints: BoxConstraints(
        minHeight: widget.variant == DefaultInputFieldVariant.multiline
            ? AppComponentSize.inputMinHeight *
                  AppComponentSize.inputMultilineMinHeightMultiplier
            : AppComponentSize.inputMinHeight,
      ),
      isDense: true,
      hintText: widget.hintText?.tr(),
      hintStyle: typography.body.copyWith(color: colors.textAssistive),
      filled: widget.variant != DefaultInputFieldVariant.underline,
      fillColor: widget.isDisabled
          ? colors.backgroundAlternative
          : colors.backgroundNormal,
      contentPadding: widget.variant == DefaultInputFieldVariant.underline
          ? const EdgeInsets.symmetric(
              vertical: AppComponentPadding.inputUnderlineVertical,
            )
          : const EdgeInsets.symmetric(
              horizontal: AppComponentPadding.inputHorizontal,
              vertical: AppComponentPadding.inputVertical,
            ),
      prefixIconColor: colors.interactionInactive,
      prefixIcon: widget.prefix != null
          ? Padding(
              padding: const EdgeInsets.only(
                left: AppComponentPadding.inputHorizontal,
                right: AppComponentPadding.inputPrefixGap,
              ),
              child: widget.prefix,
            )
          : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIconColor: colors.interactionInactive,
      suffixIcon: _buildSuffix(),
      enabledBorder: _buildBorder(_resolveBorderColor(colors, resolvedState)),
      focusedBorder: _buildBorder(_resolveBorderColor(colors, resolvedState)),
      errorBorder: _buildBorder(colors.statusNegative),
      focusedErrorBorder: _buildBorder(colors.statusNegative),
      disabledBorder: _buildBorder(colors.strokeStructuralBorder),
      border: _buildBorder(_resolveBorderColor(colors, resolvedState)),
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffix != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.suffix!,
          const SizedBox(width: AppComponentPadding.inputSuffixGap),
        ],
      );
    }

    if (widget.onClear != null && widget.showClearButton) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onClear,
            child: Semantics(
              label: widget.suffixSemanticLabel ?? 'common.action.clear'.tr(),
              child: Icon(
                Icons.close_rounded,
                size: AppIconSize.xs,
                color: context.colors.interactionInactive,
              ),
            ),
          ),
          const SizedBox(width: AppComponentPadding.inputSuffixGap),
        ],
      );
    }

    return null;
  }

  Color _resolveBorderColor(
    AppColorScheme colors,
    DefaultInputFieldState state,
  ) {
    if (state == DefaultInputFieldState.error) {
      return colors.statusNegative;
    }
    if (state == DefaultInputFieldState.focused) {
      return colors.primaryNormal;
    }
    return colors.strokeStructuralBorder;
  }

  InputBorder _buildBorder(Color color) {
    final side = BorderSide(
      color: color,
      width: AppLineWidth.inputFieldOutline,
      strokeAlign: BorderSide.strokeAlignOutside,
    );

    if (widget.variant == DefaultInputFieldVariant.underline) {
      return UnderlineInputBorder(borderSide: side);
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppComponentRadius.input),
      borderSide: side,
    );
  }
}
