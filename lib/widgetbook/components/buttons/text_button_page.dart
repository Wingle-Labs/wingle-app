import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_button.dart';
import 'package:wingle/app/config/theme/components/buttons/default_text_button.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/buttons/button_preview_parts.dart';
import 'package:wingle/widgetbook/components/buttons/button_spec_resolver.dart';

/// Text 버튼 프리뷰
class TextButtonPage extends StatefulWidget {
  /// 생성자
  const TextButtonPage({super.key});

  @override
  State<TextButtonPage> createState() => _TextButtonPageState();
}

class _TextButtonPageState extends State<TextButtonPage> {
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
    final selectedTheme = context.knobs.object.dropdown<DefaultTextButtonTheme>(
      label: 'Theme',
      options: DefaultTextButtonTheme.values,
      labelBuilder: (theme) => theme.name,
      initialOption: DefaultTextButtonTheme.primary,
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
    final iconColor = _iconColor(colors, selectedTheme);
    final resolvedSpec = WidgetbookButtonSpecResolver.resolveText(
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
            Text('Button / Text', style: typography.title),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'Text 계열 버튼을 한 곳에서 비교하고, Theme knob로 Primary / Assistive를 전환합니다.',
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
                          DefaultTextButton(
                            label: '텍스트',
                            variant: variant,
                            theme: selectedTheme,
                            leadingWidget: ButtonIconPlaceholder(
                              color: iconColor,
                            ),
                            trailingWidget: ButtonIconPlaceholder(
                              color: iconColor,
                            ),
                            onPressed: () {},
                          ),
                          if (variant != DefaultButtonVariant.values.last)
                            const SizedBox(height: AppSpacing.s16),
                        ],
                        const SizedBox(height: AppSpacing.s24),
                        for (final variant in DefaultButtonVariant.values) ...[
                          DefaultTextButton(
                            label: '텍스트',
                            variant: variant,
                            theme: selectedTheme,
                            leadingWidget: ButtonIconPlaceholder(
                              color: iconColor,
                            ),
                            trailingWidget: ButtonIconPlaceholder(
                              color: iconColor,
                            ),
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
                  DefaultTextButton(
                    label: '텍스트',
                    variant: selectedVariant,
                    theme: selectedTheme,
                    status: selectedStatus,
                    leadingWidget: showLeading
                        ? ButtonIconPlaceholder(color: iconColor)
                        : null,
                    trailingWidget: showTrailing
                        ? ButtonIconPlaceholder(color: iconColor)
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

  Color _iconColor(dynamic colors, DefaultTextButtonTheme theme) {
    return switch (theme) {
      DefaultTextButtonTheme.primary =>
        colors.componentPrimaryTextButtonEnabled,
      DefaultTextButtonTheme.assistive =>
        colors.componentAssistiveTextButtonEnabled,
    };
  }
}
