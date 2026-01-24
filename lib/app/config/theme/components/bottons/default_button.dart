import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// 비활성화 상태 여부
  final bool isDisabled;

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
    this.isDisabled = false,
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
        onTap: isDisabled
            ? null
            : () {
                onPressed?.call();
              },
        canRequestFocus: !isDisabled,
        borderRadius: AppRadius.iosStyleRadius,
        overlayColor: .resolveWith<Color?>((states) {
          if (isDisabled) return null;
          if (states.contains(WidgetState.pressed)) return pressedColor;
          return null;
        }),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppContainerSize.buttonMinimun,
            minHeight: AppContainerSize.buttonMinimun,
          ),
          child: Padding(
            padding: const .symmetric(
              vertical: AppPadding.btnVertical,
              horizontal: AppPadding.btnHorizontal,
            ),
            child: Row(
              mainAxisAlignment: .center,
              mainAxisSize: .max,
              spacing: AppSpacing.buttonInternal,
              children: [
                if (leading != null)
                  Icon(
                    leading,
                    size: AppFontSize.button,
                    color: foregroundColor,
                    applyTextScaling: true,
                  ),
                Flexible(
                  child: TextScaleWrapper(
                    policy: .cappedLarge,
                    child: Text(
                      label.tr(),
                      style: context.typography.button.copyWith(
                        color: foregroundColor,
                      ),
                      textAlign: .center,
                    ),
                  ),
                ),

                if (trailing != null)
                  Icon(
                    trailing,
                    size: AppFontSize.button,
                    color: foregroundColor,
                    applyTextScaling: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
