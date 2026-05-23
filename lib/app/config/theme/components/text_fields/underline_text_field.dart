import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_underline_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 밑줄이 그어진 텍스트 필드
class UnderlineField extends StatelessWidget {
  /// Controller
  final TextEditingController controller;

  /// 텍스트 필드 라벨
  final String label;

  /// 텍스트 필드 힌트
  final String? hint;

  /// 텍스트 필드 키보드 타입
  final TextInputType keyboardType;

  /// AutoFillHints
  final List<String>? autofillHints;

  /// bottom Padding
  final double? bottomPadding;

  /// 포커스 node
  final FocusNode? focusNode;

  /// onChanged 콜백
  final void Function(String)? onChanged;

  /// enabled
  final bool? enabled;

  /// suffix widget
  final Widget suffix;

  /// max length
  final int? maxLength;

  /// helper text
  final String? helper;

  /// InputFormatters
  final List<TextInputFormatter>? inputFormatters;

  /// 생성자
  const UnderlineField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.keyboardType,
    this.autofillHints,
    this.bottomPadding = AppPadding.card,
    this.focusNode,
    this.onChanged,
    this.enabled,
    this.suffix = const SizedBox(),
    this.maxLength,
    this.helper,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final suffixWidget = suffix;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 0),
      child: DefaultUnderlineInputField(
        controller: controller,
        labelText: label,
        hintText: hint,
        assistiveText: helper,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        onChanged: onChanged,
        isEnabled: enabled ?? true,
        suffix: suffixWidget is SizedBox ? null : suffixWidget,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        policy: TextScalePolicy.cappedMedium,
      ),
    );
  }
}
