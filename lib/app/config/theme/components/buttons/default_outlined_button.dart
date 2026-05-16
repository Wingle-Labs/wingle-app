import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Outlined 버튼 테마
enum DefaultOutlinedButtonTheme {
  /// Primary
  primary,

  /// Secondary
  secondary,

  /// Assistive
  assistive,
}

/// 앱 전역에서 사용되는 테두리 버튼 컴포넌트
class DefaultOutlinedButton extends StatelessWidget {
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

  /// Outlined 버튼 테마
  final DefaultOutlinedButtonTheme theme;

  /// 버튼 상태
  final DefaultButtonStatus status;

  /// 생성자
  const DefaultOutlinedButton({
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
    this.theme = DefaultOutlinedButtonTheme.primary,
    this.status = DefaultButtonStatus.enabled,
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
    );
  }

  DefaultButtonVisualSpec _visualSpec(
    AppColorScheme colors,
    DefaultButtonStatus status,
  ) {
    final isDisabled = status == DefaultButtonStatus.disabled;

    return switch (theme) {
      DefaultOutlinedButtonTheme.primary => DefaultButtonVisualSpec(
        backgroundColor: colors.backgroundNormal,
        foregroundColor: isDisabled
            ? colors.componentPrimaryOutlinedButtonDisabled
            : colors.componentPrimaryOutlinedButtonEnabled,
        pressedOverlayColor: colors.overlayPressed,
        borderSide: BorderSide(
          color: isDisabled
              ? colors.componentPrimaryOutlinedButtonDisabled
              : colors.componentPrimaryOutlinedButtonEnabled,
          width: AppLineWidth.outline,
        ),
      ),
      DefaultOutlinedButtonTheme.secondary => DefaultButtonVisualSpec(
        backgroundColor: colors.backgroundNormal,
        foregroundColor: isDisabled
            ? colors.componentSecondaryOutlinedButtonDisabled
            : colors.componentSecondaryOutlinedButtonEnabled,
        pressedOverlayColor: colors.overlayPressed,
        borderSide: BorderSide(
          color: isDisabled
              ? colors.componentSecondaryOutlinedButtonDisabled
              : colors.componentSecondaryOutlinedButtonEnabled,
          width: AppLineWidth.outline,
        ),
      ),
      DefaultOutlinedButtonTheme.assistive => DefaultButtonVisualSpec(
        backgroundColor: colors.backgroundNormal,
        foregroundColor: isDisabled
            ? colors.componentAssistiveOutlinedButtonDisabled
            : colors.componentAssistiveOutlinedButtonEnabled,
        pressedOverlayColor: colors.overlayPressed,
        borderSide: BorderSide(
          color: isDisabled
              ? colors.componentAssistiveOutlinedButtonDisabled
              : colors.componentAssistiveOutlinedButtonEnabled,
          width: AppLineWidth.outline,
        ),
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
