import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_multiline_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// 다중 라인 TextField
class MultilineTextField extends ConsumerWidget {
  /// min line
  final int? minLines;

  /// max line
  final int? maxLines;

  /// focus node
  final FocusNode? focusNode;

  /// on change callback
  final ValueChanged<String>? onChanged;

  /// controller
  final TextEditingController? controller;

  /// hint text
  final String? hint;

  /// helper text
  final String? helper;

  /// 생성자
  const MultilineTextField({
    super.key,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.onChanged,
    this.controller,
    this.hint,
    this.helper,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultMultilineInputField(
      minLines: minLines,
      maxLines: maxLines,
      focusNode: focusNode,
      onChanged: onChanged,
      controller: controller,
      hintText: hint,
      assistiveText: helper,
      policy: TextScalePolicy.cappedMedium,
    );
  }
}
