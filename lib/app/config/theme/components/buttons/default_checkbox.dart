import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Checkbox 선택 상태
enum DefaultCheckboxState {
  /// 선택되지 않음
  unselected,

  /// 선택됨
  selected,

  /// 일부 선택됨
  partial,
}

/// 앱 전역에서 사용하는 기본 체크박스 컴포넌트
class DefaultCheckbox extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 부분 선택 여부
  final bool isPartial;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// semantic label
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultCheckbox({
    super.key,
    required this.isChecked,
    this.isPartial = false,
    this.onChanged,
    this.isDisabled = false,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final size = AppIconSize.sm * clampedScale;
    final state = isPartial
        ? DefaultCheckboxState.partial
        : isChecked
        ? DefaultCheckboxState.selected
        : DefaultCheckboxState.unselected;

    return Semantics(
      label: semanticLabel,
      checked: state == DefaultCheckboxState.selected,
      enabled: !isDisabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(!isChecked),
          borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => _CheckboxOverlay.resolve(states, isDisabled, context),
          ),
          child: SizedBox.square(
            dimension: size,
            child: _CheckboxMark(
              state: state,
              isDisabled: isDisabled,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxOverlay {
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

class _CheckboxMark extends StatelessWidget {
  final DefaultCheckboxState state;
  final bool isDisabled;
  final double size;

  const _CheckboxMark({
    required this.state,
    required this.isDisabled,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = state != DefaultCheckboxState.unselected;
    final fillColor = isDisabled
        ? colors.interactionDisable
        : selected
        ? colors.primaryNormal
        : colors.backgroundElevatedNormal;
    final borderColor = isDisabled
        ? colors.strokeStructuralBorder
        : selected
        ? colors.primaryNormal
        : colors.strokeStructuralBorder;
    final iconColor = isDisabled
        ? colors.componentCheckboxIconDisabled
        : colors.componentCheckboxIconEnabled;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: switch (state) {
          DefaultCheckboxState.unselected => null,
          DefaultCheckboxState.selected => Icon(
            Icons.check_rounded,
            size: size,
            color: iconColor,
          ),
          DefaultCheckboxState.partial => Icon(
            Icons.remove_rounded,
            size: size,
            color: iconColor,
          ),
        },
      ),
    );
  }
}
