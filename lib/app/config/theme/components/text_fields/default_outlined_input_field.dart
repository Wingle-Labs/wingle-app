import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wingle/app/config/theme/components/text_fields/default_input_field.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// Label + 아웃라인 입력 필드
class DefaultOutlinedInputField extends StatelessWidget {
  /// 힌트 텍스트
  final String? hintText;

  /// 라벨 텍스트
  final String? labelText;

  /// 보조 텍스트
  final String? assistiveText;

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

  /// Assistive Action
  final Widget? assistiveAction;

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

  /// focus node
  final FocusNode? focusNode;

  /// max length
  final int? maxLength;

  /// 포커스 시 스크롤 여백
  final EdgeInsets scrollPadding;

  /// 필드 외부 탭 시 포커스 해제 여부
  final bool unfocusOnTapOutside;

  /// 명시적 상태
  final DefaultInputFieldState? state;

  /// 타입
  final DefaultInputFieldType type;

  /// 생성자
  const DefaultOutlinedInputField({
    super.key,
    this.hintText,
    this.labelText,
    this.assistiveText,
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
    this.assistiveAction,
    this.onClear,
    this.showClearButton = false,
    this.isDisabled = false,
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.validator,
    this.focusNode,
    this.maxLength,
    this.scrollPadding = const EdgeInsets.all(20),
    this.unfocusOnTapOutside = true,
    this.state,
    this.type = DefaultInputFieldType.inputSuffix,
  }) : assert(
         controller == null || initialValue == null,
         'controller와 initialValue는 동시에 사용할 수 없습니다.',
       );

  @override
  Widget build(BuildContext context) {
    return DefaultInputField(
      variant: DefaultInputFieldVariant.outlined,
      state: state,
      type: type,
      labelText: labelText,
      hintText: hintText,
      assistiveText: assistiveText,
      errorText: errorText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onChanged: onChanged,
      controller: controller,
      policy: policy,
      inputFormatters: inputFormatters,
      prefix: prefix,
      suffix: suffix,
      assistiveAction: assistiveAction,
      onClear: onClear,
      showClearButton: showClearButton,
      isDisabled: isDisabled,
      readOnly: readOnly,
      onTap: onTap,
      initialValue: initialValue,
      validator: validator,
      focusNode: focusNode,
      maxLength: maxLength,
      scrollPadding: scrollPadding,
      unfocusOnTapOutside: unfocusOnTapOutside,
    );
  }
}
