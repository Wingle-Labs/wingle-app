import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// 전화번호 입력 TextField
class UnderlineField extends ConsumerStatefulWidget {
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

  /// 생성자
  const UnderlineField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.keyboardType,
    this.autofillHints,
    this.bottomPadding = AppSpacing.md,
    this.focusNode,
  });

  @override
  ConsumerState<UnderlineField> createState() => _UnderlineFieldState();
}

class _UnderlineFieldState extends ConsumerState<UnderlineField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label.tr(),
            labelStyle: TextStyle(
              fontSize: AppFontSize.medium,
              color: theme.hintColor,
            ),
            hintText: widget.hint?.tr(),
            hintStyle: TextStyle(
              fontSize: AppFontSize.large,
              color: theme.hintColor,
            ),
            fillColor: theme.primaryColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
            ),
            focusColor: theme.primaryColor,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
          keyboardType: widget.keyboardType,
          style: TextStyle(fontSize: AppFontSize.large),
          cursorColor: theme.primaryColor,
          cursorHeight: AppFontSize.large,
          autofillHints: widget.autofillHints,
          focusNode: widget.focusNode,
        ),
        SizedBox(height: widget.bottomPadding),
      ],
    );
  }
}
