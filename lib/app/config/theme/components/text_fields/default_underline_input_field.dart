import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// 밑줄 형태 Input Field
class DefaultUnderlineInputField extends StatelessWidget {
  /// controller
  final TextEditingController controller;

  /// 라벨
  final String? labelText;

  /// hint
  final String? hintText;

  /// assistive
  final String? assistiveText;

  /// keyboard type
  final TextInputType keyboardType;

  /// autofill hints
  final List<String>? autofillHints;

  /// on changed
  final ValueChanged<String>? onChanged;

  /// enabled
  final bool isEnabled;

  /// suffix
  final Widget? suffix;

  /// max length
  final int? maxLength;

  /// formatters
  final List<TextInputFormatter>? inputFormatters;

  /// scale policy
  final TextScalePolicy policy;

  /// 생성자
  const DefaultUnderlineInputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.assistiveText,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.onChanged,
    this.isEnabled = true,
    this.suffix,
    this.maxLength,
    this.inputFormatters,
    this.policy = TextScalePolicy.system,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      variant: DefaultInputFieldVariant.underline,
      type: DefaultInputFieldType.inputSuffix,
      labelText: labelText,
      hintText: hintText,
      assistiveText: assistiveText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      onChanged: onChanged,
      controller: controller,
      inputFormatters: inputFormatters,
      suffix: suffix,
      isDisabled: !isEnabled,
      maxLength: maxLength,
      policy: policy,
    );
  }
}
