import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용하는 기본 토글 스위치 컴포넌트
class DefaultToggleSwitch extends StatelessWidget {
  /// 활성화 여부
  final bool isActive;

  /// 활성화 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// semantic label
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultToggleSwitch({
    super.key,
    required this.isActive,
    this.onChanged,
    this.isDisabled = false,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final width = AppContainerSize.toggleSwitchWidth * clampedScale;
    final height = AppContainerSize.toggleSwitchHeight * clampedScale;
    final thumb = AppContainerSize.toggleSwitchThumb * clampedScale;
    final inset = AppContainerSize.toggleSwitchInset * clampedScale;
    final padding = AppPadding.toggleSwitchPadding * clampedScale;
    final thumbOffset = isActive ? width - thumb - inset : inset;

    return Semantics(
      label: semanticLabel,
      toggled: isActive,
      enabled: !isDisabled,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(!isActive),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) =>
                _ToggleSwitchOverlay.resolve(states, isDisabled, context),
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _resolveTrackColor(context),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: _resolveTrackBorderColor(context)),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedPositioned(
                    duration: Duration.zero,
                    left: thumbOffset,
                    width: thumb,
                    height: height - padding * 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.backgroundElevatedNormal,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveTrackColor(BuildContext context) {
    final colors = context.colors;
    if (isDisabled) {
      return colors.interactionDisable;
    }

    return isActive ? colors.primaryNormal : colors.interactionDisable;
  }

  Color _resolveTrackBorderColor(BuildContext context) {
    final colors = context.colors;
    if (isDisabled) {
      return colors.strokeStructuralBorder;
    }

    return isActive ? colors.primaryNormal : colors.interactionDisable;
  }
}

class _ToggleSwitchOverlay {
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
