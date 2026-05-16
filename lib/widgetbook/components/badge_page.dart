import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/badges/default_badge.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Badge 컴포넌트 프리뷰
class BadgePage extends StatelessWidget {
  /// 생성자
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final text = context.knobs.string(label: 'Text', initialValue: '뱃지 내용');
    final size = context.knobs.object.dropdown<DefaultBadgeSize>(
      label: 'Size',
      options: DefaultBadgeSize.values,
      initialOption: DefaultBadgeSize.md,
    );
    final type = context.knobs.object.dropdown<DefaultBadgeType>(
      label: 'Type',
      options: DefaultBadgeType.values,
      initialOption: DefaultBadgeType.primary,
    );
    final resolvedSpec = _buildResolvedSpec(context, size, type);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Badge', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text('짧고 명확한 텍스트로 상태, 분류, 보조 정보를 전달합니다.', style: typography.body),
            const SizedBox(height: AppSpacing.s40),
            Container(
              width: 640,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpecRow(
                    title: 'size',
                    chips: const ['sm', 'md', 'lg'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        DefaultBadge(text: '뱃지 내용', size: DefaultBadgeSize.sm),
                        SizedBox(width: AppSpacing.s8),
                        DefaultBadge(text: '뱃지 내용', size: DefaultBadgeSize.md),
                        SizedBox(width: AppSpacing.s8),
                        DefaultBadge(text: '뱃지 내용', size: DefaultBadgeSize.lg),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'type',
                    chips: const ['Primary', 'Secondary', 'Tertiary', 'Gray'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        DefaultBadge(
                          text: '뱃지 내용',
                          type: DefaultBadgeType.primary,
                        ),
                        SizedBox(width: AppSpacing.s8),
                        DefaultBadge(
                          text: '뱃지 내용',
                          type: DefaultBadgeType.secondary,
                        ),
                        SizedBox(width: AppSpacing.s8),
                        DefaultBadge(
                          text: '뱃지 내용',
                          type: DefaultBadgeType.tertiary,
                        ),
                        SizedBox(width: AppSpacing.s8),
                        DefaultBadge(
                          text: '뱃지 내용',
                          type: DefaultBadgeType.gray,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'test',
                    chips: const ['knob enabled'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultBadge(text: text, size: size, type: type),
                        const SizedBox(width: AppSpacing.s12),
                        Text('실제 미리보기: $size / $type', style: typography.body),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  WidgetbookResolvedSpecCard(entries: resolvedSpec),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<WidgetbookResolvedSpecEntry> _buildResolvedSpec(
    BuildContext context,
    DefaultBadgeSize size,
    DefaultBadgeType type,
  ) {
    final colors = context.colors;

    final (
      height,
      radius,
      vertical,
      horizontal,
      labelSize,
      labelWeight,
    ) = switch (size) {
      DefaultBadgeSize.sm => ('18px', '6px', '4px', '6px', '12px', '500'),
      DefaultBadgeSize.md => ('24px', '8px', '6px', '8px', '16px', '600'),
      DefaultBadgeSize.lg => ('28px', '8px', '8px', '10px', '16px', '600'),
    };

    final (
      backgroundToken,
      backgroundColor,
      foregroundToken,
      foregroundColor,
    ) = switch (type) {
      DefaultBadgeType.primary => (
        'componentBadgePrimaryBackground',
        colors.componentBadgePrimaryBackground,
        'componentBadgePrimaryForeground',
        colors.componentBadgePrimaryForeground,
      ),
      DefaultBadgeType.secondary => (
        'componentBadgeSecondaryBackground',
        colors.componentBadgeSecondaryBackground,
        'componentBadgeSecondaryForeground',
        colors.componentBadgeSecondaryForeground,
      ),
      DefaultBadgeType.tertiary => (
        'componentBadgeTertiaryBackground',
        colors.componentBadgeTertiaryBackground,
        'componentBadgeTertiaryForeground',
        colors.componentBadgeTertiaryForeground,
      ),
      DefaultBadgeType.gray => (
        'componentBadgeGrayBackground',
        colors.componentBadgeGrayBackground,
        'componentBadgeGrayForeground',
        colors.componentBadgeGrayForeground,
      ),
    };

    return [
      WidgetbookResolvedSpecEntry(label: 'Size', value: size.name),
      WidgetbookResolvedSpecEntry(label: 'Type', value: type.name),
      WidgetbookResolvedSpecEntry(label: 'Height', value: height),
      WidgetbookResolvedSpecEntry(label: 'Radius', value: radius),
      WidgetbookResolvedSpecEntry(
        label: 'Padding',
        value: 'V $vertical / H $horizontal',
      ),
      WidgetbookResolvedSpecEntry(label: 'Label size', value: labelSize),
      WidgetbookResolvedSpecEntry(
        label: 'Label style',
        value: '$labelSize / $labelWeight',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Background',
        value: '$backgroundToken (${widgetbookColorToHex(backgroundColor)})',
        swatchColor: backgroundColor,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Foreground',
        value: '$foregroundToken (${widgetbookColorToHex(foregroundColor)})',
        swatchColor: foregroundColor,
      ),
    ];
  }
}

class _SpecRow extends StatelessWidget {
  final String title;
  final List<String> chips;
  final Widget child;

  const _SpecRow({
    required this.title,
    required this.chips,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('$title =', style: typography.main),
            for (final chip in chips)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.interactionDisable,
                  borderRadius: BorderRadius.circular(AppRadius.tagRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.tagHorizontal * 2,
                    vertical: AppPadding.tagVertical * 2,
                  ),
                  child: Text(chip, style: typography.body),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s20),
        child,
      ],
    );
  }
}
