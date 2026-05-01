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
            child: Row(
              mainAxisAlignment: .center,
              mainAxisSize: .max,
              spacing: AppSpacing.buttonInternal,
              children: [
                if (leading != null || leadingWidget != null)
                  _ButtonIconSlot(
                    icon: leading,
                    color: foregroundColor,
                    child: leadingWidget,
                  ),
                Flexible(
                  child: TextScaleWrapper(
                    policy: .cappedLarge,
                    child: Text(
                      label.tr(),
                      style: (textStyle ?? context.typography.buttonLarge)
                          .copyWith(color: foregroundColor),
                      textAlign: .center,
                    ),
                  ),
                ),

                if (trailing != null || trailingWidget != null)
                  _ButtonIconSlot(
                    icon: trailing,
                    color: foregroundColor,
                    child: trailingWidget,
                  ),
              ],
            ),
          ),
        ),
      ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.buttonIconSlot),
      child: SizedBox.square(
        dimension: AppContainerSize.buttonIconSlot,
        child:
            child ??
            DefaultIcon(
              icon: icon!,
              size: AppContainerSize.buttonIconSlot,
              color: color,
            ),
      ),
    );
  }
}
