import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_filled_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/buttons/button_preview_parts.dart';
import 'package:wingle/widgetbook/components/buttons/button_spec_resolver.dart';

/// Filled 버튼 프리뷰
class FilledButtonPage extends StatefulWidget {
  /// 생성자
  const FilledButtonPage({super.key});

  @override
  State<FilledButtonPage> createState() => _FilledButtonPageState();
}

class _FilledButtonPageState extends State<FilledButtonPage> {
  static const double _panelWidth = 680;
  static const double _exampleWidth = 360;

  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final selectedVariant = context.knobs.object.dropdown<DefaultButtonVariant>(
      label: 'Variant',
      options: DefaultButtonVariant.values,
      labelBuilder: (variant) => variant.name,
      initialOption: DefaultButtonVariant.lg,
    );
    final selectedTheme = context.knobs.object
        .dropdown<DefaultFilledButtonTheme>(
          label: 'Theme',
          options: DefaultFilledButtonTheme.values,
          labelBuilder: (theme) => theme.name,
          initialOption: DefaultFilledButtonTheme.primary,
        );
    final selectedStatus = context.knobs.object.dropdown<DefaultButtonStatus>(
      label: 'Status',
      options: DefaultButtonStatus.values,
      labelBuilder: (status) => status.name,
      initialOption: DefaultButtonStatus.enabled,
    );
    final showLeading = context.knobs.object.dropdown<bool>(
      label: 'Leading Icon',
      options: const [true, false],
      initialOption: true,
    );
    final showTrailing = context.knobs.object.dropdown<bool>(
      label: 'Trailing Icon',
      options: const [true, false],
      initialOption: true,
    );
    final resolvedSpec = WidgetbookButtonSpecResolver.resolveFilled(
      context: context,
      variant: selectedVariant,
      status: selectedStatus,
      theme: selectedTheme,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Button / Filled', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'Filled 계열 버튼을 한 곳에서 비교하고, Theme knob로 Primary / Secondary / Tertiary를 전환합니다.',
              style: typography.body.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s40),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonSampleCard(
                    width: _exampleWidth,
                    child: Column(
                      children: [
                        for (final variant in DefaultButtonVariant.values) ...[
                          DefaultFilledButton(
                            label: '텍스트',
                            variant: variant,
                            theme: selectedTheme,
                            leadingWidget: const ButtonIconPlaceholder(),
                            trailingWidget: const ButtonIconPlaceholder(),
                            onPressed: () {},
                          ),
                          if (variant != DefaultButtonVariant.values.last)
                            const SizedBox(height: AppSpacing.s16),
                        ],
                        const SizedBox(height: AppSpacing.s24),
                        for (final variant in DefaultButtonVariant.values) ...[
                          DefaultFilledButton(
                            label: '텍스트',
                            variant: variant,
                            theme: selectedTheme,
                            leadingWidget: const ButtonIconPlaceholder(),
                            trailingWidget: const ButtonIconPlaceholder(),
                            isDisabled: true,
                            onPressed: () {},
                          ),
                          if (variant != DefaultButtonVariant.values.last)
                            const SizedBox(height: AppSpacing.s16),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s40),
                  Expanded(
                    child: Text(
                      'Theme\nVariant\nEnabled / Disabled\nLeading / Trailing Slot',
                      style: typography.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s40),
            const Divider(color: Colors.black),
            const SizedBox(height: AppSpacing.s32),
            Text('테스트', style: typography.subtitle),
            const SizedBox(height: AppSpacing.s24),
            ButtonSpecPanel(
              width: _panelWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultFilledButton(
                    label: '텍스트',
                    variant: selectedVariant,
                    theme: selectedTheme,
                    status: selectedStatus,
                    leadingWidget: showLeading
                        ? const ButtonIconPlaceholder()
                        : null,
                    trailingWidget: showTrailing
                        ? const ButtonIconPlaceholder()
                        : null,
                    onPressed: () => setState(() => _tapCount++),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text('클릭 횟수: $_tapCount', style: typography.body),
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    'theme: ${selectedTheme.name}, '
                    'variant: ${selectedVariant.name}, '
                    'status: ${selectedStatus.name}',
                    style: typography.bodySub.copyWith(
                      color: colors.textAlternative,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  ButtonResolvedSpecCard(spec: resolvedSpec),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
