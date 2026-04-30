import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용하는 기본 체크 마크 컴포넌트
class DefaultCheck extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// semantic label
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultCheck({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.isDisabled = false,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final markSize = AppIconSize.sm * clampedScale;
    final touchSize = AppIconTouchSize.sm * clampedScale;

    return Semantics(
      label: semanticLabel,
      checked: isChecked,
      enabled: !isDisabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(!isChecked),
          customBorder: const CircleBorder(),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => _CheckOverlay.resolve(states, isDisabled, context),
          ),
          child: SizedBox.square(
            dimension: touchSize,
            child: Center(
              child: SizedBox.square(
                dimension: markSize,
                child: Icon(
                  Icons.check_rounded,
                  size: markSize,
                  color: _resolveIconColor(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveIconColor(BuildContext context) {
    final colors = context.colors;
    if (isDisabled) {
      return colors.interactionDisable;
    }

    return isChecked ? colors.primaryNormal : colors.interactionInactive;
  }
}

class _CheckOverlay {
  static Color? resolve(
    Set<WidgetState> states,
    bool disabled,
    BuildContext context,
  ) {
    if (disabled) {
      return null;
    }

    final colors = context.colors;
    if (states.contains(WidgetState.pressed)) {
      return colors.overlayPressed;
    }

    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.hovered)) {
      return colors.overlayInactive;
    }

    return null;
  }
}
