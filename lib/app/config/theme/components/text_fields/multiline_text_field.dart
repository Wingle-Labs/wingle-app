import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/color.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';

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
    final theme = Theme.of(context);
    return SmoothRectWrapper(
      child: TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        cursorColor: AppColor.primary,
        focusNode: focusNode,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.hintColor),
          helperText: helper,
          helperStyle: TextStyle(color: theme.hintColor),
          focusColor: AppColor.primary,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor, width: 2),
            borderRadius: AppRadius.iosStyleRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.primary, width: 2),
            borderRadius: AppRadius.iosStyleRadius,
          ),
          contentPadding: .all(AppPadding.textfield),
        ),
      ),
    );
  }
}
