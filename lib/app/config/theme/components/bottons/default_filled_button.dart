import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/bottons/default_button.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용되는 채워진 버튼 컴포넌트
class DefaultFilledButton extends StatelessWidget {
  /// - [label]: 버튼에 표시될 텍스트
  final String label;

  /// - [onPressed]: 버튼 클릭 시 호출될 콜백
  final VoidCallback? onPressed;

  /// - [leadingIcon]: 버튼 왼쪽에 표시될 아이콘
  final IconData? leadingIcon;

  /// - [trailingIcon]: 버튼 오른쪽에 표시될 아이콘
  final IconData? trailingIcon;

  /// - [isDisabled]: 비활성화 상태 여부
  final bool isDisabled;

  /// - [textStyle]: 글자 스타일
  final TextStyle? textStyle;

  /// const 생성자
  const DefaultFilledButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      label: label,
      backgroundColor: isDisabled
          ? context.colors.componentPrimaryFilledButtonDisabled
          : context.colors.componentPrimaryFilledButtonEnabled,
      pressedColor: context.colors.overlayPressed,
      foregroundColor: isDisabled
          ? context.colors.textAssistive
          : context.colors.onPrimaryNormal,
      onPressed: isDisabled ? null : onPressed,
      leading: leadingIcon,
      trailing: trailingIcon,
      isDisabled: isDisabled,
      textStyle: textStyle,
    );
  }
}
