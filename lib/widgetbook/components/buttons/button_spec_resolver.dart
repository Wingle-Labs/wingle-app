import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_outlined_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Widgetbook에서 보여줄 버튼 spec row
class WidgetbookButtonSpecEntry {
  /// spec 항목 라벨
  final String label;

  /// 사람이 읽을 값 문자열
  final String value;

  /// 색상 swatch가 필요한 경우 표시할 색
  final Color? swatchColor;

  /// 생성자
  const WidgetbookButtonSpecEntry({
    required this.label,
    required this.value,
    this.swatchColor,
  });
}

/// Widgetbook에서 보여줄 버튼 spec 묶음
class WidgetbookButtonResolvedSpec {
  /// spec 카드 제목
  final String title;

  /// spec row 목록
  final List<WidgetbookButtonSpecEntry> entries;

  /// 생성자
  const WidgetbookButtonResolvedSpec({
    required this.title,
    required this.entries,
  });
}

/// 버튼 Widgetbook 페이지 전용 spec resolver
class WidgetbookButtonSpecResolver {
  const WidgetbookButtonSpecResolver._();

  /// 공통 버튼 base spec을 계산한다.
  static WidgetbookButtonResolvedSpec resolveBase({
    required BuildContext context,
    required DefaultButtonVariant variant,
    required DefaultButtonStatus status,
    required DefaultButtonVisualSpec visualSpec,
    required String backgroundToken,
    required String foregroundToken,
    String borderToken = 'none',
    required String pressedOverlayToken,
  }) {
    final sizeSpec = _ButtonVariantLayoutSpec.from(variant);

    return WidgetbookButtonResolvedSpec(
      title: 'Resolved Spec',
      entries: [
        WidgetbookButtonSpecEntry(label: 'Variant', value: variant.name),
        WidgetbookButtonSpecEntry(label: 'Status', value: status.name),
        WidgetbookButtonSpecEntry(
          label: 'Width policy',
          value: variant == DefaultButtonVariant.fullWidth
              ? 'fill width'
              : 'hug by content',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Height',
          value: '${sizeSpec.height.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Min width',
          value: sizeSpec.minWidth == 0
              ? 'none'
              : '${sizeSpec.minWidth.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Radius',
          value: '${sizeSpec.radius.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Label size',
          value: '${sizeSpec.fontSize.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Label style',
          value: '${sizeSpec.fontSize.toInt()}px / ${sizeSpec.fontWeightLabel}',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Padding',
          value:
              'V ${sizeSpec.verticalPadding.toInt()} / H ${sizeSpec.horizontalPadding.toInt()}',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Leading/Trailing frame',
          value: '${sizeSpec.iconFrameSize.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Icon glyph',
          value: '${sizeSpec.iconGlyphSize.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Internal gap',
          value: '${sizeSpec.iconLabelGap.toInt()}px',
        ),
        WidgetbookButtonSpecEntry(
          label: 'Background',
          value: '$backgroundToken (${_toHex(visualSpec.backgroundColor)})',
          swatchColor: visualSpec.backgroundColor,
        ),
        WidgetbookButtonSpecEntry(
          label: 'Foreground',
          value: '$foregroundToken (${_toHex(visualSpec.foregroundColor)})',
          swatchColor: visualSpec.foregroundColor,
        ),
        WidgetbookButtonSpecEntry(
          label: 'Border',
          value: borderToken == 'none'
              ? 'none'
              : '$borderToken (${_toHex(visualSpec.borderSide.color)}) '
                    '${visualSpec.borderSide.width}px',
          swatchColor: borderToken == 'none'
              ? null
              : visualSpec.borderSide.color,
        ),
        WidgetbookButtonSpecEntry(
          label: 'Pressed overlay',
          value:
              '$pressedOverlayToken '
              '(${_toHex(visualSpec.pressedOverlayColor)})',
          swatchColor: visualSpec.pressedOverlayColor,
        ),
      ],
    );
  }

  /// Filled 버튼 spec을 계산한다.
  static WidgetbookButtonResolvedSpec resolveFilled({
    required BuildContext context,
    required DefaultButtonVariant variant,
    required DefaultButtonStatus status,
    required DefaultFilledButtonTheme theme,
  }) {
    final colors = context.colors;
    final isDisabled = status == DefaultButtonStatus.disabled;

    return switch (theme) {
      DefaultFilledButtonTheme.primary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
          backgroundColor: isDisabled
              ? colors.componentPrimaryFilledButtonDisabled
              : colors.componentPrimaryFilledButtonEnabled,
          foregroundColor: isDisabled
              ? colors.textAssistive
              : colors.onPrimaryNormal,
          pressedOverlayColor: colors.overlayPressed,
        ),
        backgroundToken: isDisabled
            ? 'componentPrimaryFilledButtonDisabled'
            : 'componentPrimaryFilledButtonEnabled',
        foregroundToken: isDisabled ? 'textAssistive' : 'onPrimaryNormal',
        pressedOverlayToken: 'overlayPressed',
      ),
      DefaultFilledButtonTheme.secondary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
          backgroundColor: isDisabled
              ? colors.componentSecondaryFilledButtonDisabled
              : colors.componentSecondaryFilledButtonEnabled,
          foregroundColor: isDisabled
              ? colors.textAssistive
              : colors.onSecondaryNormal,
          pressedOverlayColor: colors.overlayPressed,
        ),
        backgroundToken: isDisabled
            ? 'componentSecondaryFilledButtonDisabled'
            : 'componentSecondaryFilledButtonEnabled',
        foregroundToken: isDisabled ? 'textAssistive' : 'onSecondaryNormal',
        pressedOverlayToken: 'overlayPressed',
      ),
      DefaultFilledButtonTheme.tertiary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
          backgroundColor: isDisabled
              ? colors.componentTertiaryFilledButtonDisabled
              : colors.componentTertiaryFilledButtonEnabled,
          foregroundColor: isDisabled
              ? colors.textAssistive
              : colors.textNormal,
          pressedOverlayColor: colors.overlayPressed,
        ),
        backgroundToken: isDisabled
            ? 'componentTertiaryFilledButtonDisabled'
            : 'componentTertiaryFilledButtonEnabled',
        foregroundToken: isDisabled ? 'textAssistive' : 'textNormal',
        pressedOverlayToken: 'overlayPressed',
      ),
    };
  }

  /// Outlined 버튼 spec을 계산한다.
  static WidgetbookButtonResolvedSpec resolveOutlined({
    required BuildContext context,
    required DefaultButtonVariant variant,
    required DefaultButtonStatus status,
    required DefaultOutlinedButtonTheme theme,
  }) {
    final colors = context.colors;
    final isDisabled = status == DefaultButtonStatus.disabled;

    return switch (theme) {
      DefaultOutlinedButtonTheme.primary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
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
        backgroundToken: 'backgroundNormal',
        foregroundToken: isDisabled
            ? 'componentPrimaryOutlinedButtonDisabled'
            : 'componentPrimaryOutlinedButtonEnabled',
        borderToken: isDisabled
            ? 'componentPrimaryOutlinedButtonDisabled'
            : 'componentPrimaryOutlinedButtonEnabled',
        pressedOverlayToken: 'overlayPressed',
      ),
      DefaultOutlinedButtonTheme.secondary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
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
        backgroundToken: 'backgroundNormal',
        foregroundToken: isDisabled
            ? 'componentSecondaryOutlinedButtonDisabled'
            : 'componentSecondaryOutlinedButtonEnabled',
        borderToken: isDisabled
            ? 'componentSecondaryOutlinedButtonDisabled'
            : 'componentSecondaryOutlinedButtonEnabled',
        pressedOverlayToken: 'overlayPressed',
      ),
      DefaultOutlinedButtonTheme.assistive => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
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
        backgroundToken: 'backgroundNormal',
        foregroundToken: isDisabled
            ? 'componentAssistiveOutlinedButtonDisabled'
            : 'componentAssistiveOutlinedButtonEnabled',
        borderToken: isDisabled
            ? 'componentAssistiveOutlinedButtonDisabled'
            : 'componentAssistiveOutlinedButtonEnabled',
        pressedOverlayToken: 'overlayPressed',
      ),
    };
  }

  /// Text 버튼 spec을 계산한다.
  static WidgetbookButtonResolvedSpec resolveText({
    required BuildContext context,
    required DefaultButtonVariant variant,
    required DefaultButtonStatus status,
    required DefaultTextButtonTheme theme,
  }) {
    final colors = context.colors;
    final isDisabled = status == DefaultButtonStatus.disabled;

    return switch (theme) {
      DefaultTextButtonTheme.primary => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
          backgroundColor: Colors.transparent,
          foregroundColor: isDisabled
              ? colors.componentPrimaryTextButtonDisabled
              : colors.componentPrimaryTextButtonEnabled,
          pressedOverlayColor: colors.overlayPressed,
        ),
        backgroundToken: 'transparent',
        foregroundToken: isDisabled
            ? 'componentPrimaryTextButtonDisabled'
            : 'componentPrimaryTextButtonEnabled',
        pressedOverlayToken: 'overlayPressed',
      ),
      DefaultTextButtonTheme.assistive => resolveBase(
        context: context,
        variant: variant,
        status: status,
        visualSpec: DefaultButtonVisualSpec(
          backgroundColor: Colors.transparent,
          foregroundColor: isDisabled
              ? colors.componentAssistiveTextButtonDisabled
              : colors.componentAssistiveTextButtonEnabled,
          pressedOverlayColor: colors.overlayPressed,
        ),
        backgroundToken: 'transparent',
        foregroundToken: isDisabled
            ? 'componentAssistiveTextButtonDisabled'
            : 'componentAssistiveTextButtonEnabled',
        pressedOverlayToken: 'overlayPressed',
      ),
    };
  }

  static String _toHex(Color color) {
    final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
    final alpha = value.substring(0, 2).toUpperCase();
    final rgb = value.substring(2).toUpperCase();

    if (alpha == 'FF') return '#$rgb';

    return '#$alpha$rgb';
  }
}

class _ButtonVariantLayoutSpec {
  final double height;
  final double minWidth;
  final double radius;
  final double fontSize;
  final String fontWeightLabel;
  final double verticalPadding;
  final double horizontalPadding;
  final double iconLabelGap;
  final double iconGlyphSize;
  final double iconFrameSize;

  const _ButtonVariantLayoutSpec({
    required this.height,
    required this.minWidth,
    required this.radius,
    required this.fontSize,
    required this.fontWeightLabel,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.iconLabelGap,
    required this.iconGlyphSize,
    required this.iconFrameSize,
  });

  factory _ButtonVariantLayoutSpec.from(DefaultButtonVariant variant) {
    return switch (variant) {
      DefaultButtonVariant.fullWidth => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonHeight,
        minWidth: AppContainerSize.buttonHeight,
        radius: AppRadius.iosStyle,
        fontSize: AppFontSize.button,
        fontWeightLabel: '600',
        verticalPadding: AppPadding.fullWidthButtonVertical,
        horizontalPadding: AppPadding.fullWidthButtonHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapRegular,
        iconGlyphSize: AppIconSize.sm,
        iconFrameSize: AppIconButtonFrameSize.md,
      ),
      DefaultButtonVariant.xs => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonChipHeight,
        minWidth: 0,
        radius: AppRadius.md,
        fontSize: AppFontSize.caption,
        fontWeightLabel: '500',
        verticalPadding: AppPadding.buttonSmallVertical,
        horizontalPadding: AppPadding.buttonChipHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconGlyphSize: AppIconSize.xxs,
        iconFrameSize: AppIconButtonFrameSize.xxs,
      ),
      DefaultButtonVariant.sm => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonSmallHeight,
        minWidth: 0,
        radius: AppRadius.md,
        fontSize: AppFontSize.sub,
        fontWeightLabel: '600',
        verticalPadding: AppPadding.buttonSmallVertical,
        horizontalPadding: AppPadding.buttonSmallHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconGlyphSize: AppIconSize.xs,
        iconFrameSize: AppIconButtonFrameSize.xs,
      ),
      DefaultButtonVariant.md => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonMediumHeight,
        minWidth: 0,
        radius: AppRadius.buttonMedium,
        fontSize: AppFontSize.button,
        fontWeightLabel: '600',
        verticalPadding: AppPadding.buttonVertical,
        horizontalPadding: AppPadding.buttonMediumHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconGlyphSize: AppIconSize.xs,
        iconFrameSize: AppIconButtonFrameSize.sm,
      ),
      DefaultButtonVariant.lg => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonHeight,
        minWidth: 0,
        radius: AppRadius.iosStyle,
        fontSize: AppFontSize.button,
        fontWeightLabel: '600',
        verticalPadding: AppPadding.buttonVertical,
        horizontalPadding: AppPadding.buttonHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapRegular,
        iconGlyphSize: AppIconSize.sm,
        iconFrameSize: AppIconButtonFrameSize.md,
      ),
      DefaultButtonVariant.xl => const _ButtonVariantLayoutSpec(
        height: AppContainerSize.buttonXLargeHeight,
        minWidth: 0,
        radius: AppRadius.iosStyle,
        fontSize: AppFontSize.subtitle,
        fontWeightLabel: '600',
        verticalPadding: AppPadding.buttonVertical,
        horizontalPadding: AppPadding.buttonHorizontal,
        iconLabelGap: AppSpacing.buttonLabelGapLarge,
        iconGlyphSize: AppIconSize.md,
        iconFrameSize: AppIconButtonFrameSize.lg,
      ),
    };
  }
}
