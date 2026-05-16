import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/color/contracts/app_color_scheme.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Chip Button 테마
enum DefaultChipButtonTheme {
  /// 강조형 선택 칩
  primary,

  /// 중립형 선택 칩
  secondary,
}

/// Chip Button 크기
enum DefaultChipButtonSize {
  /// 기본 크기
  md,
}

/// Chip Button 상태
enum DefaultChipButtonState {
  /// 초기 기본 상태
  defaultState,

  /// 선택된 상태
  selected,

  /// 선택되지 않은 상태
  unselected,

  /// 비활성 상태
  disabled,
}

/// 앱 전역에서 사용하는 기본 Chip Button 컴포넌트
class DefaultChipButton extends StatelessWidget {
  /// 표시 텍스트
  final String label;

  /// 테마
  final DefaultChipButtonTheme theme;

  /// 크기
  final DefaultChipButtonSize size;

  /// 상태
  final DefaultChipButtonState state;

  /// 클릭 콜백
  final VoidCallback? onPressed;

  /// 생성자
  const DefaultChipButton({
    super.key,
    required this.label,
    this.theme = DefaultChipButtonTheme.primary,
    this.size = DefaultChipButtonSize.md,
    this.state = DefaultChipButtonState.unselected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spec = _DefaultChipButtonSpec.resolve(size);
    final visual = _resolveVisual(colors);
    final isDisabled = state == DefaultChipButtonState.disabled;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      selected: state == DefaultChipButtonState.selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(spec.radius),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (isDisabled) {
              return null;
            }

            if (states.contains(WidgetState.pressed)) {
              return colors.overlayPressed;
            }

            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return colors.overlayInactive;
            }

            return null;
          }),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: visual.backgroundColor,
              borderRadius: BorderRadius.circular(spec.radius),
              border: visual.borderSide == BorderSide.none
                  ? null
                  : Border.fromBorderSide(visual.borderSide),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: spec.height),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spec.horizontalPadding,
                  vertical: spec.verticalPadding,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.buttonMedium.copyWith(
                    color: visual.foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _DefaultChipButtonVisual _resolveVisual(AppColorScheme colors) {
    return switch ((theme, state)) {
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.selected) =>
        _DefaultChipButtonVisual(
          backgroundColor: colors.componentChipButtonPrimarySelectedBackground,
          foregroundColor: colors.componentChipButtonPrimarySelectedForeground,
        ),
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.unselected) ||
      (
        DefaultChipButtonTheme.primary,
        DefaultChipButtonState.defaultState,
      ) => _DefaultChipButtonVisual(
        backgroundColor: colors.componentChipButtonPrimaryUnselectedBackground,
        foregroundColor: colors.componentChipButtonPrimaryUnselectedForeground,
        borderSide: BorderSide(
          color: colors.componentChipButtonPrimaryUnselectedBorder,
        ),
      ),
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.disabled) =>
        _DefaultChipButtonVisual(
          backgroundColor: colors.componentChipButtonPrimaryDisabledBackground,
          foregroundColor: colors.componentChipButtonPrimaryDisabledForeground,
        ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.defaultState) =>
        _DefaultChipButtonVisual(
          backgroundColor: colors.componentChipButtonSecondaryDefaultBackground,
          foregroundColor: colors.componentChipButtonSecondaryDefaultForeground,
        ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.selected) =>
        _DefaultChipButtonVisual(
          backgroundColor:
              colors.componentChipButtonSecondarySelectedBackground,
          foregroundColor:
              colors.componentChipButtonSecondarySelectedForeground,
        ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.unselected) =>
        _DefaultChipButtonVisual(
          backgroundColor:
              colors.componentChipButtonSecondaryUnselectedBackground,
          foregroundColor:
              colors.componentChipButtonSecondaryUnselectedForeground,
          borderSide: BorderSide(
            color: colors.componentChipButtonSecondaryUnselectedBorder,
          ),
        ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.disabled) =>
        _DefaultChipButtonVisual(
          backgroundColor:
              colors.componentChipButtonSecondaryDisabledBackground,
          foregroundColor:
              colors.componentChipButtonSecondaryDisabledForeground,
        ),
    };
  }
}

class _DefaultChipButtonSpec {
  final double height;
  final double radius;
  final double horizontalPadding;
  final double verticalPadding;

  const _DefaultChipButtonSpec({
    required this.height,
    required this.radius,
    required this.horizontalPadding,
    required this.verticalPadding,
  });

  static _DefaultChipButtonSpec resolve(DefaultChipButtonSize size) {
    return switch (size) {
      DefaultChipButtonSize.md => const _DefaultChipButtonSpec(
        height: AppChipButtonHeight.md,
        radius: AppRadius.chipButton,
        horizontalPadding: AppPadding.chipButtonHorizontal,
        verticalPadding: AppPadding.chipButtonVertical,
      ),
    };
  }
}

class _DefaultChipButtonVisual {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide borderSide;

  const _DefaultChipButtonVisual({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderSide = BorderSide.none,
  });
}
