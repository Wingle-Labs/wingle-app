import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_typography.dart';

part 'default_button_spec.dart';
part 'default_button_size_spec.dart';
part 'default_button_content.dart';

/// 디자인 시스템 기본 버튼
class DefaultButton extends ConsumerWidget {
  /// 버튼 내부 내용
  final String label;

  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;

  /// Button 크기 variant
  final DefaultButtonVariant variant;

  /// Button 상태
  final DefaultButtonStatus status;

  /// Button 시각 제원
  final DefaultButtonVisualSpec visualSpec;

  /// Leading 아이콘
  final IconData? leading;

  /// Trailing 아이콘
  final IconData? trailing;

  /// Leading 아이콘 슬롯에 직접 넣을 위젯
  final Widget? leadingWidget;

  /// Trailing 아이콘 슬롯에 직접 넣을 위젯
  final Widget? trailingWidget;

  /// Font Style
  final TextStyle? textStyle;

  /// 버튼 내부 패딩 override
  final EdgeInsetsGeometry? contentPadding;

  /// 버튼 높이 override
  final double? height;

  /// 버튼 최소 너비 override
  final double? minWidth;

  /// const 생성자
  const DefaultButton({
    super.key,
    required this.label,
    required this.visualSpec,
    this.onPressed,
    this.variant = DefaultButtonVariant.lg,
    this.status = DefaultButtonStatus.enabled,
    this.leading,
    this.trailing,
    this.leadingWidget,
    this.trailingWidget,
    this.textStyle,
    this.contentPadding,
    this.height,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeSpec = _DefaultButtonSizeSpec.from(variant, context);
    final resolvedBorderRadius =
        visualSpec.borderRadius ??
        sizeSpec.borderRadius ??
        AppRadius.iosStyleRadius;
    final resolvedHeight = height ?? sizeSpec.height;
    final resolvedMinWidth = minWidth ?? sizeSpec.minWidth;
    final resolvedContentPadding = contentPadding ?? sizeSpec.padding;
    final resolvedTextStyle = (textStyle ?? sizeSpec.textStyle).copyWith(
      color: visualSpec.foregroundColor,
    );
    final isInteractive = status == DefaultButtonStatus.enabled;
    final isLoading = status == DefaultButtonStatus.loading;

    return Material(
      color: visualSpec.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: resolvedBorderRadius,
        side: visualSpec.borderSide,
      ),
      child: InkWell(
        onTap: isInteractive ? onPressed?.call : null,
        canRequestFocus: isInteractive,
        borderRadius: resolvedBorderRadius,
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (!isInteractive) return null;
          if (states.contains(WidgetState.pressed)) {
            return visualSpec.pressedOverlayColor;
          }
          return null;
        }),
        child: SizedBox(
          width: variant == DefaultButtonVariant.fullWidth
              ? double.infinity
              : null,
          height: resolvedHeight,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: resolvedMinWidth),
            child: Padding(
              padding: resolvedContentPadding,
              child: _ButtonContent(
                label: label.tr(),
                leading: leading,
                trailing: trailing,
                leadingWidget: leadingWidget,
                trailingWidget: trailingWidget,
                foregroundColor: visualSpec.foregroundColor,
                textStyle: resolvedTextStyle,
                isLoading: isLoading,
                expandToMaxWidth: variant == DefaultButtonVariant.fullWidth,
                iconLabelGap: sizeSpec.iconLabelGap,
                iconSlotSize: sizeSpec.iconSlotSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
