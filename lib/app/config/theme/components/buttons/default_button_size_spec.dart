part of 'default_button.dart';

class _DefaultButtonSizeSpec {
  final double height;
  final double minWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconLabelGap;
  final double iconSlotSize;

  const _DefaultButtonSizeSpec({
    required this.height,
    required this.minWidth,
    required this.borderRadius,
    required this.padding,
    required this.textStyle,
    required this.iconLabelGap,
    required this.iconSlotSize,
  });

  factory _DefaultButtonSizeSpec.from(
    DefaultButtonVariant variant,
    BuildContext context,
  ) {
    final typography = context.typography;

    return switch (variant) {
      DefaultButtonVariant.fullWidth => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonHeight,
        minWidth: AppContainerSize.buttonHeight,
        borderRadius: AppRadius.iosStyleRadius,
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.fullWidthButtonVertical,
          horizontal: AppPadding.fullWidthButtonHorizontal,
        ),
        textStyle: typography.buttonLarge,
        iconLabelGap: AppSpacing.buttonLabelGapRegular,
        iconSlotSize: AppIconSize.sm,
      ),
      DefaultButtonVariant.xs => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonChipHeight,
        minWidth: 0,
        borderRadius: BorderRadius.circular(AppRadius.md),
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.buttonSmallVertical,
          horizontal: AppPadding.buttonChipHorizontal,
        ),
        textStyle: typography.buttonSmall,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconSlotSize: AppIconSize.xxs,
      ),
      DefaultButtonVariant.sm => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonSmallHeight,
        minWidth: 0,
        borderRadius: BorderRadius.circular(AppRadius.md),
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.buttonSmallVertical,
          horizontal: AppPadding.buttonSmallHorizontal,
        ),
        textStyle: typography.buttonMedium,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconSlotSize: AppIconSize.xs,
      ),
      DefaultButtonVariant.md => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonMediumHeight,
        minWidth: 0,
        borderRadius: BorderRadius.circular(AppRadius.buttonMedium),
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.buttonVertical,
          horizontal: AppPadding.buttonMediumHorizontal,
        ),
        textStyle: typography.buttonLarge,
        iconLabelGap: AppSpacing.buttonLabelGapCompact,
        iconSlotSize: AppIconSize.xs,
      ),
      DefaultButtonVariant.lg => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonHeight,
        minWidth: 0,
        borderRadius: AppRadius.iosStyleRadius,
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.buttonVertical,
          horizontal: AppPadding.buttonHorizontal,
        ),
        textStyle: typography.buttonLarge,
        iconLabelGap: AppSpacing.buttonLabelGapRegular,
        iconSlotSize: AppIconSize.sm,
      ),
      DefaultButtonVariant.xl => _DefaultButtonSizeSpec(
        height: AppContainerSize.buttonXLargeHeight,
        minWidth: 0,
        borderRadius: AppRadius.iosStyleRadius,
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.buttonVertical,
          horizontal: AppPadding.buttonHorizontal,
        ),
        textStyle: typography.subtitle,
        iconLabelGap: AppSpacing.buttonLabelGapLarge,
        iconSlotSize: AppIconSize.md,
      ),
    };
  }
}
