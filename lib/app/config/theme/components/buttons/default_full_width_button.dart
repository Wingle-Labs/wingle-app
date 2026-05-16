import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';

/// 화면 주요 CTA에 사용하는 Full Width Button 컴포넌트
class DefaultFullWidthButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String label;

  /// 버튼 클릭 시 호출될 콜백
  final VoidCallback? onPressed;

  /// 버튼 왼쪽에 표시될 아이콘
  final IconData? leadingIcon;

  /// 버튼 오른쪽에 표시될 아이콘
  final IconData? trailingIcon;

  /// 버튼 왼쪽 아이콘 슬롯에 직접 넣을 위젯
  final Widget? leadingWidget;

  /// 버튼 오른쪽 아이콘 슬롯에 직접 넣을 위젯
  final Widget? trailingWidget;

  /// 비활성화 상태 여부
  final bool isDisabled;

  /// 로딩 상태 여부
  final bool isLoading;

  /// 버튼 상태
  final DefaultButtonStatus status;

  /// 버튼 너비
  final double width;

  /// 글자 스타일
  final TextStyle? textStyle;

  /// 생성자
  const DefaultFullWidthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingWidget,
    this.trailingWidget,
    this.isDisabled = false,
    this.isLoading = false,
    this.status = DefaultButtonStatus.enabled,
    this.width = double.infinity,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DefaultFilledButton(
        label: label,
        variant: DefaultButtonVariant.fullWidth,
        theme: DefaultFilledButtonTheme.primary,
        status: status,
        onPressed: onPressed,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        leadingWidget: leadingWidget,
        trailingWidget: trailingWidget,
        isDisabled: isDisabled,
        isLoading: isLoading,
        textStyle: textStyle,
      ),
    );
  }
}
