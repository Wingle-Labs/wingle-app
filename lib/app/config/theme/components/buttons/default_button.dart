import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 디자인 시스템 기본 버튼
class DefaultButton extends ConsumerWidget {
  /// 버튼 내부 내용
  final String label;

  /// 버튼 클릭 시 실행될 콜백
  final VoidCallback? onPressed;

  /// 기본 배경색
  final Color backgroundColor;

  /// 눌렸을 때 배경색 (overlay)
  final Color pressedColor;

  /// 텍스트 색상
  final Color foregroundColor;

  /// 버튼 테두리
  final BorderSide borderSide;

  /// Leading 아이콘
  final IconData? leading;

  /// Trailing 아이콘
  final IconData? trailing;

  /// Leading 아이콘 슬롯에 직접 넣을 위젯
  final Widget? leadingWidget;

  /// Trailing 아이콘 슬롯에 직접 넣을 위젯
  final Widget? trailingWidget;

  /// 비활성화 상태 여부
  final bool isDisabled;

  /// Font Style
  final TextStyle? textStyle;

  /// 버튼 내부 패딩
  final EdgeInsetsGeometry contentPadding;

  /// const 생성자
  const DefaultButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.pressedColor,
    required this.foregroundColor,
    this.onPressed,
    this.borderSide = .none,
    this.leading,
    this.trailing,
    this.leadingWidget,
    this.trailingWidget,
    this.isDisabled = false,
    this.textStyle,
    this.contentPadding = const .symmetric(
      vertical: AppPadding.buttonVertical,
      horizontal: AppPadding.buttonHorizontal,
    ),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.iosStyleRadius,
        side: borderSide,
      ),
      child: InkWell(
        onTap: isDisabled ? null : onPressed?.call,
        canRequestFocus: !isDisabled,
        borderRadius: AppRadius.iosStyleRadius,
        overlayColor: .resolveWith<Color?>((states) {
          if (isDisabled) return null;
          if (states.contains(WidgetState.pressed)) return pressedColor;
          return null;
        }),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppContainerSize.buttonHeight,
            minHeight: AppContainerSize.buttonHeight,
          ),
          child: Padding(
            padding: contentPadding,
            child: _ButtonContent(
              label: label.tr(),
              leading: leading,
              trailing: trailing,
              leadingWidget: leadingWidget,
              trailingWidget: trailingWidget,
              foregroundColor: foregroundColor,
              textStyle: (textStyle ?? context.typography.buttonLarge).copyWith(
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? leading;
  final IconData? trailing;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final Color foregroundColor;
  final TextStyle textStyle;

  const _ButtonContent({
    required this.label,
    required this.leading,
    required this.trailing,
    required this.leadingWidget,
    required this.trailingWidget,
    required this.foregroundColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null || leadingWidget != null;
    final hasTrailing = trailing != null || trailingWidget != null;
    final hasIcon = hasLeading || hasTrailing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth = hasIcon
            ? AppContainerSize.buttonIconSlot + AppSpacing.buttonInternal
            : 0.0;
        final maxTextWidth = constraints.hasBoundedWidth
            ? (constraints.maxWidth - sideWidth * 2).clamp(
                0.0,
                constraints.maxWidth,
              )
            : double.infinity;

        return Center(
          child: Row(
            mainAxisSize: .min,
            children: [
              if (hasIcon) ...[
                _ReservedButtonIconSlot(
                  child: hasLeading
                      ? _ButtonIconSlot(
                          icon: leading,
                          color: foregroundColor,
                          child: leadingWidget,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.buttonInternal),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxTextWidth),
                child: TextScaleWrapper(
                  policy: .cappedLarge,
                  child: Text(
                    label,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: .center,
                  ),
                ),
              ),
              if (hasIcon) ...[
                const SizedBox(width: AppSpacing.buttonInternal),
                _ReservedButtonIconSlot(
                  child: hasTrailing
                      ? _ButtonIconSlot(
                          icon: trailing,
                          color: foregroundColor,
                          child: trailingWidget,
                        )
                      : null,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ReservedButtonIconSlot extends StatelessWidget {
  final Widget? child;

  const _ReservedButtonIconSlot({this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppContainerSize.buttonIconSlot,
      child: child,
    );
  }
}

class _ButtonIconSlot extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final Widget? child;

  const _ButtonIconSlot({
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppContainerSize.buttonIconSlot,
      child: child == null
          ? DefaultIcon(
              icon: icon!,
              size: AppContainerSize.buttonIconSlot,
              color: color,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
              child: child,
            ),
    );
  }
}
