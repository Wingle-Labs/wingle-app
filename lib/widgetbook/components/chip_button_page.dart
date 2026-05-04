import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/chips/default_chip_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Chip Button 컴포넌트 프리뷰
class ChipButtonPage extends StatelessWidget {
  /// 생성자
  const ChipButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final text = context.knobs.string(label: 'Text', initialValue: '임시 텍스트');
    final theme = context.knobs.object.dropdown<DefaultChipButtonTheme>(
      label: 'Theme',
      options: DefaultChipButtonTheme.values,
      initialOption: DefaultChipButtonTheme.primary,
      labelBuilder: (value) => switch (value) {
        DefaultChipButtonTheme.primary => 'Primary',
        DefaultChipButtonTheme.secondary => 'Secondary',
      },
    );
    final state = context.knobs.object.dropdown<DefaultChipButtonState>(
      label: 'State',
      options: DefaultChipButtonState.values,
      initialOption: DefaultChipButtonState.selected,
      labelBuilder: (value) => switch (value) {
        DefaultChipButtonState.defaultState => 'default',
        DefaultChipButtonState.selected => 'selected',
        DefaultChipButtonState.unselected => 'unselected',
        DefaultChipButtonState.disabled => 'disabled',
      },
    );
    final resolvedSpec = _buildResolvedSpec(context, theme, state);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chip Button', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text(
              '짧은 텍스트 기반 옵션을 빠르게 선택할 때 사용하는 선택형 컴포넌트입니다.',
              style: typography.body,
            ),
            const SizedBox(height: AppSpacing.s40),
            Container(
              width: 720,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpecRow(
                    title: 'theme',
                    chips: const ['Primary', 'Secondary'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        DefaultChipButton(
                          label: '임시 텍스트',
                          theme: DefaultChipButtonTheme.primary,
                          state: DefaultChipButtonState.selected,
                        ),
                        SizedBox(width: AppSpacing.s12),
                        DefaultChipButton(
                          label: '혼술을 좋아함',
                          theme: DefaultChipButtonTheme.secondary,
                          state: DefaultChipButtonState.defaultState,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'state',
                    chips: const ['selected', 'unselected', 'disabled'],
                    child: Wrap(
                      spacing: AppSpacing.s12,
                      runSpacing: AppSpacing.s12,
                      children: const [
                        DefaultChipButton(
                          label: '임시 텍스트',
                          theme: DefaultChipButtonTheme.primary,
                          state: DefaultChipButtonState.selected,
                        ),
                        DefaultChipButton(
                          label: '임시 텍스트',
                          theme: DefaultChipButtonTheme.primary,
                          state: DefaultChipButtonState.unselected,
                        ),
                        DefaultChipButton(
                          label: '임시 텍스트',
                          theme: DefaultChipButtonTheme.primary,
                          state: DefaultChipButtonState.disabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'test',
                    chips: const ['knob linked'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultChipButton(
                          label: text,
                          theme: theme,
                          state: state,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          '실제 미리보기: $theme / $state',
                          style: typography.body,
                        ),
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
    DefaultChipButtonTheme theme,
    DefaultChipButtonState state,
  ) {
    final colors = context.colors;
    final (
      backgroundToken,
      backgroundColor,
      foregroundToken,
      foregroundColor,
      borderToken,
      borderColor,
    ) = switch ((theme, state)) {
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.selected) => (
        'componentChipButtonPrimarySelectedBackground',
        colors.componentChipButtonPrimarySelectedBackground,
        'componentChipButtonPrimarySelectedForeground',
        colors.componentChipButtonPrimarySelectedForeground,
        'none',
        null,
      ),
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.unselected) ||
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.defaultState) => (
        'componentChipButtonPrimaryUnselectedBackground',
        colors.componentChipButtonPrimaryUnselectedBackground,
        'componentChipButtonPrimaryUnselectedForeground',
        colors.componentChipButtonPrimaryUnselectedForeground,
        'componentChipButtonPrimaryUnselectedBorder',
        colors.componentChipButtonPrimaryUnselectedBorder,
      ),
      (DefaultChipButtonTheme.primary, DefaultChipButtonState.disabled) => (
        'componentChipButtonPrimaryDisabledBackground',
        colors.componentChipButtonPrimaryDisabledBackground,
        'componentChipButtonPrimaryDisabledForeground',
        colors.componentChipButtonPrimaryDisabledForeground,
        'none',
        null,
      ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.defaultState) =>
        (
          'componentChipButtonSecondaryDefaultBackground',
          colors.componentChipButtonSecondaryDefaultBackground,
          'componentChipButtonSecondaryDefaultForeground',
          colors.componentChipButtonSecondaryDefaultForeground,
          'none',
          null,
        ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.selected) => (
        'componentChipButtonSecondarySelectedBackground',
        colors.componentChipButtonSecondarySelectedBackground,
        'componentChipButtonSecondarySelectedForeground',
        colors.componentChipButtonSecondarySelectedForeground,
        'none',
        null,
      ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.unselected) => (
        'componentChipButtonSecondaryUnselectedBackground',
        colors.componentChipButtonSecondaryUnselectedBackground,
        'componentChipButtonSecondaryUnselectedForeground',
        colors.componentChipButtonSecondaryUnselectedForeground,
        'componentChipButtonSecondaryUnselectedBorder',
        colors.componentChipButtonSecondaryUnselectedBorder,
      ),
      (DefaultChipButtonTheme.secondary, DefaultChipButtonState.disabled) => (
        'componentChipButtonSecondaryDisabledBackground',
        colors.componentChipButtonSecondaryDisabledBackground,
        'componentChipButtonSecondaryDisabledForeground',
        colors.componentChipButtonSecondaryDisabledForeground,
        'none',
        null,
      ),
    };

    return [
      WidgetbookResolvedSpecEntry(label: 'Size', value: 'md'),
      WidgetbookResolvedSpecEntry(label: 'Theme', value: theme.name),
      WidgetbookResolvedSpecEntry(label: 'State', value: state.name),
      const WidgetbookResolvedSpecEntry(label: 'Height', value: '32px'),
      const WidgetbookResolvedSpecEntry(label: 'Radius', value: '18px'),
      const WidgetbookResolvedSpecEntry(label: 'Padding', value: 'V 6 / H 14'),
      const WidgetbookResolvedSpecEntry(label: 'Gap', value: '4px'),
      const WidgetbookResolvedSpecEntry(
        label: 'Label style',
        value: '14px / 600',
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
      WidgetbookResolvedSpecEntry(
        label: 'Border',
        value: borderToken == 'none'
            ? 'none'
            : '$borderToken (${widgetbookColorToHex(borderColor!)})',
        swatchColor: borderColor,
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
