import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 프로필 입력에서 사용하는 3자리 키 입력 컴포넌트.
class BasicProfileHeightInput extends StatefulWidget {
  /// 초기값
  final String initialValue;

  /// 값 변경 콜백
  final ValueChanged<String> onChanged;

  /// 모든 칸이 채워졌을 때 호출되는 콜백
  final VoidCallback? onCompleted;

  /// 생성자
  const BasicProfileHeightInput({
    super.key,
    this.initialValue = '',
    required this.onChanged,
    this.onCompleted,
  });

  @override
  State<BasicProfileHeightInput> createState() =>
      _BasicProfileHeightInputState();
}

class _BasicProfileHeightInputState extends State<BasicProfileHeightInput> {
  static const int _digitCount = 3;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _wasComplete = false;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      _digitCount,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(_digitCount, (_) => FocusNode());
    _syncControllers(widget.initialValue);
    _wasComplete = _isComplete;
  }

  @override
  void didUpdateWidget(covariant BasicProfileHeightInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue == widget.initialValue) return;

    _syncControllers(widget.initialValue);
    _wasComplete = _isComplete;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var index = 0; index < _digitCount; index++) ...[
          Expanded(
            child: _DigitBox(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textStyle: typography.title.copyWith(
                color: colors.textNeutral,
                fontWeight: FontWeight.w700,
              ),
              onChanged: (value) => _handleChanged(context, index, value),
              onTap: () {
                _focusNodes[index].requestFocus();
              },
              autofocus: index == 0,
              textInputAction: index == _digitCount - 1
                  ? TextInputAction.done
                  : TextInputAction.next,
            ),
          ),
          if (index < _digitCount - 1) const SizedBox(width: AppSpacing.xs),
        ],
        const SizedBox(width: AppSpacing.sm),
        DefaultText(
          'CM',
          style: typography.title.copyWith(
            color: colors.textNeutral,
            fontWeight: FontWeight.w700,
          ),
          isTranslationKey: false,
        ),
      ],
    );
  }

  void _handleChanged(BuildContext context, int index, String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (sanitized != value) {
      _controllers[index].value = _controllers[index].value.copyWith(
        text: sanitized,
        selection: TextSelection.collapsed(offset: sanitized.length),
        composing: TextRange.empty,
      );
      _emitValue(context);
      return;
    }

    if (sanitized.length > 1) {
      _syncControllers(sanitized);
      _emitValue(context);
      return;
    }

    if (sanitized.isNotEmpty && index < _digitCount - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (sanitized.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _emitValue(context);
  }

  void _syncControllers(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '').split('');
    for (var index = 0; index < _digitCount; index++) {
      final nextValue = index < digits.length ? digits[index] : '';
      _controllers[index].value = TextEditingValue(
        text: nextValue,
        selection: TextSelection.collapsed(offset: nextValue.length),
      );
    }
  }

  void _emitValue(BuildContext context) {
    final isComplete = _isComplete;
    final shouldNotifyComplete = isComplete && !_wasComplete;
    widget.onChanged(_value);
    setState(() {
      _wasComplete = isComplete;
    });

    if (shouldNotifyComplete && widget.onCompleted != null) {
      widget.onCompleted?.call();
      FocusScope.of(context).unfocus();
    }
  }

  bool get _isComplete =>
      _controllers.every((controller) => controller.text.isNotEmpty);

  String get _value => _controllers.map((controller) => controller.text).join();
}

class _DigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle textStyle;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final bool autofocus;
  final TextInputAction textInputAction;

  const _DigitBox({
    required this.controller,
    required this.focusNode,
    required this.textStyle,
    required this.onChanged,
    required this.onTap,
    required this.autofocus,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 92,
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: textStyle,
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.backgroundNormal,
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: colors.strokeStructuralBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: colors.strokeStructuralBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: BorderSide(color: colors.primaryNormal, width: 1.4),
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
        cursorColor: colors.primaryNormal,
      ),
    );
  }
}
