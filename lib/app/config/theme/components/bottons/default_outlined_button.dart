import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/bottons/default_button.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용되는 테두리 버튼 컴포넌트
class DefaultOutlinedButton extends StatelessWidget {
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

  /// const 생성자
  const DefaultOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      label: label,
      backgroundColor: context.colors.background,
      pressedColor: context.colors.overlayPressed,
      // TODO: 테두리 버튼의 전경 색상 전용 Color token 추가 예정
      foregroundColor: isDisabled
          ? context.colors.textDisabledStrong
          : context.colors.primary,
      onPressed: isDisabled ? null : onPressed,
      leading: leadingIcon,
      trailing: trailingIcon,
      isDisabled: isDisabled,
      borderSide: BorderSide(
        color: isDisabled
            ? context.colors.textDisabledStrong
            : context.colors.btnDefault,
        width: AppLineWidth.outline,
      ),
    );
  }
}
