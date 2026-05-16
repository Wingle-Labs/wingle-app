import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Filled 버튼 테마
enum DefaultFilledButtonTheme {
  /// Primary
  primary,

  /// Secondary
  secondary,

  /// Tertiary
  tertiary,
}

/// 앱 전역에서 사용되는 채워진 버튼 컴포넌트
class DefaultFilledButton extends StatelessWidget {
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

  /// 버튼 크기 variant
  final DefaultButtonVariant variant;

  /// Filled 버튼 테마
  final DefaultFilledButtonTheme theme;

  /// 버튼 상태
  final DefaultButtonStatus status;

  /// 글자 스타일
  final TextStyle? textStyle;

  /// 생성자
  const DefaultFilledButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingWidget,
    this.trailingWidget,
    this.isDisabled = false,
    this.isLoading = false,
    this.variant = DefaultButtonVariant.lg,
    this.theme = DefaultFilledButtonTheme.primary,
    this.status = DefaultButtonStatus.enabled,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedStatus = _resolveStatus(status, isDisabled, isLoading);
    final colors = context.colors;

    return DefaultButton(
      label: label,
      variant: variant,
      status: resolvedStatus,
      visualSpec: _visualSpec(colors, resolvedStatus),
      onPressed: resolvedStatus == DefaultButtonStatus.enabled
          ? onPressed
          : null,
      leading: leadingIcon,
      trailing: trailingIcon,
      leadingWidget: leadingWidget,
      trailingWidget: trailingWidget,
      textStyle: textStyle,
    );
  }

  DefaultButtonVisualSpec _visualSpec(
    AppColorScheme colors,
    DefaultButtonStatus status,
  ) {
    final isDisabled = status == DefaultButtonStatus.disabled;

    return switch (theme) {
      DefaultFilledButtonTheme.primary => DefaultButtonVisualSpec(
        backgroundColor: isDisabled
            ? colors.componentPrimaryFilledButtonDisabled
            : colors.componentPrimaryFilledButtonEnabled,
        foregroundColor: isDisabled
            ? colors.textAssistive
            : colors.onPrimaryNormal,
        pressedOverlayColor: colors.overlayPressed,
      ),
      DefaultFilledButtonTheme.secondary => DefaultButtonVisualSpec(
        backgroundColor: isDisabled
            ? colors.componentSecondaryFilledButtonDisabled
            : colors.componentSecondaryFilledButtonEnabled,
        foregroundColor: isDisabled
            ? colors.textAssistive
            : colors.onSecondaryNormal,
        pressedOverlayColor: colors.overlayPressed,
      ),
      DefaultFilledButtonTheme.tertiary => DefaultButtonVisualSpec(
        backgroundColor: isDisabled
            ? colors.componentTertiaryFilledButtonDisabled
            : colors.componentTertiaryFilledButtonEnabled,
        foregroundColor: isDisabled ? colors.textAssistive : colors.textNormal,
        pressedOverlayColor: colors.overlayPressed,
      ),
    };
  }
}

DefaultButtonStatus _resolveStatus(
  DefaultButtonStatus status,
  bool isDisabled,
  bool isLoading,
) {
  if (isDisabled) return DefaultButtonStatus.disabled;
  if (isLoading) return DefaultButtonStatus.loading;
  return status;
}
