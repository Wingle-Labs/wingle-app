import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// 밑줄이 그어진 텍스트 필드
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
  ConsumerState<UnderlineField> createState() => _UnderlineFieldState();
}

class _UnderlineFieldState extends ConsumerState<UnderlineField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TextFormField(
          autofocus: true,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            helperStyle: TextStyle(
              fontSize: AppFontSize.caption,
              color: theme.hintColor,
            ),
            labelText: widget.label.tr(),
            labelStyle: TextStyle(
              fontSize: AppFontSize.body,
              color: theme.hintColor,
            ),
            hintText: widget.hint?.tr(),
            hintStyle: TextStyle(
              fontSize: AppFontSize.body,
              color: theme.hintColor,
            ),
            helperText: widget.helper?.tr(),
            alignLabelWithHint: true,
            fillColor: theme.primaryColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
            focusColor: theme.primaryColor,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.hintColor),
            ),
          ),
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          style: TextStyle(fontSize: AppFontSize.subtitle),
          cursorColor: theme.primaryColor,
          cursorHeight: AppFontSize.subtitle,
          autofillHints: widget.autofillHints,
          focusNode: widget.focusNode,
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s8),
          child: widget.suffix,
        ),
        SizedBox(height: widget.bottomPadding),
      ],
    );
  }
}
