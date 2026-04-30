import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Radio 크기
enum DefaultRadioSize {
  /// 기본 크기
  normal,

  /// 작은 크기
  small,
}

/// 앱 전역에서 사용하는 기본 라디오 컴포넌트
class DefaultRadio extends StatelessWidget {
  /// 선택 여부
  final bool isSelected;

  /// 선택 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// 크기
  final DefaultRadioSize size;

  /// semantic label
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultRadio({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.isDisabled = false,
    this.size = DefaultRadioSize.normal,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final spec = _DefaultRadioSpec.fromSize(size, clampedScale);

    return Semantics(
      label: semanticLabel,
      checked: isSelected,
      enabled: !isDisabled,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(true),
          customBorder: const CircleBorder(),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => _RadioOverlay.resolve(states, isDisabled, context),
          ),
          child: SizedBox.square(
            dimension: spec.touch,
            child: Center(
              child: SizedBox.square(
                dimension: spec.outer,
                child: _RadioMark(
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  spec: spec,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultRadioSpec {
  final double touch;
  final double outer;
  final double inner;

  const _DefaultRadioSpec({
    required this.touch,
    required this.outer,
    required this.inner,
  });

  factory _DefaultRadioSpec.fromSize(DefaultRadioSize size, double scale) {
    final touch = switch (size) {
      DefaultRadioSize.normal => AppIconTouchSize.sm,
      DefaultRadioSize.small => AppIconTouchSize.xs,
    };
    final outer = switch (size) {
      DefaultRadioSize.normal => AppIconSize.radioNormal,
      DefaultRadioSize.small => AppIconSize.radioSmall,
    };
    final inner = switch (size) {
      DefaultRadioSize.normal => AppIconSize.radioInnerNormal,
      DefaultRadioSize.small => AppIconSize.radioInnerSmall,
    };

    return _DefaultRadioSpec(
      touch: touch * scale,
      outer: outer * scale,
      inner: inner * scale,
    );
  }
}

class _RadioOverlay {
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

class _RadioMark extends StatelessWidget {
  final bool isSelected;
  final bool isDisabled;
  final _DefaultRadioSpec spec;

  const _RadioMark({
    required this.isSelected,
    required this.isDisabled,
    required this.spec,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeColor = isDisabled
        ? colors.interactionDisable
        : colors.primaryNormal;
    final borderColor = isDisabled
        ? colors.strokeStructuralBorder
        : activeColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: AppLineWidth.radioButtonBorder,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: Duration.zero,
          width: isSelected ? spec.inner : 0,
          height: isSelected ? spec.inner : 0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: activeColor),
        ),
      ),
    );
  }
}
