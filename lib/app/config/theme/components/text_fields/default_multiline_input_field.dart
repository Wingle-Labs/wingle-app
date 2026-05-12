import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// 멀티라인 Input Field
class DefaultMultilineInputField extends StatelessWidget {
  /// min lines
  final int? minLines;

  /// max lines
  final int? maxLines;

  /// focus node
  final FocusNode? focusNode;

  /// on changed
  final ValueChanged<String>? onChanged;

  /// controller
  final TextEditingController? controller;

  /// label
  final String? labelText;

  /// hint
  final String? hintText;

  /// assistive
  final String? assistiveText;

  /// scale policy
  final TextScalePolicy policy;

  /// 생성자
  const DefaultMultilineInputField({
    super.key,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.onChanged,
    this.controller,
    this.labelText,
    this.hintText,
    this.assistiveText,
    this.policy = TextScalePolicy.system,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      variant: DefaultInputFieldVariant.multiline,
      type: DefaultInputFieldType.inputSuffix,
      labelText: labelText,
      hintText: hintText,
      assistiveText: assistiveText,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      minLines: minLines ?? 4,
      maxLines: maxLines ?? 8,
      policy: policy,
    );
  }
}
