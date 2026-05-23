import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_toggle_switch.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Toggle Switch 컴포넌트 프리뷰
class ToggleSwitchPage extends StatefulWidget {
  /// 생성자
  const ToggleSwitchPage({super.key});

  @override
  State<ToggleSwitchPage> createState() => _ToggleSwitchPageState();
}

class _ToggleSwitchPageState extends State<ToggleSwitchPage> {
  static const double _panelWidth = 640;

  bool _active = true;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final disabled = context.knobs.object.dropdown<bool>(
      label: 'Disabled',
      options: const [false, true],
      initialOption: false,
    );
    final resolvedSpec = <WidgetbookResolvedSpecEntry>[
      WidgetbookResolvedSpecEntry(label: 'Track size', value: _trackSizeLabel),
      WidgetbookResolvedSpecEntry(
        label: 'Thumb size',
        value: '${AppContainerSize.toggleSwitchThumb.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Inset',
        value: '${AppContainerSize.toggleSwitchInset.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Padding',
        value: 'all ${AppPadding.toggleSwitchPadding.toInt()}',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'State',
        value: disabled ? 'disabled' : (_active ? 'on' : 'off'),
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Active track',
        value: widgetbookTokenValue('primaryNormal', colors.primaryNormal),
        swatchColor: colors.primaryNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Inactive track',
        value: widgetbookTokenValue(
          'strokeStructuralBorder',
          colors.strokeStructuralBorder,
        ),
        swatchColor: colors.strokeStructuralBorder,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Disabled track',
        value: widgetbookTokenValue(
          'interactionDisable',
          colors.interactionDisable,
        ),
        swatchColor: colors.interactionDisable,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toggle Switch', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text('활성화 여부를 제어할 때 사용해요.', style: typography.body),
            const SizedBox(height: AppSpacing.s40),
            Container(
              width: _panelWidth,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SpecRow(
                    title: 'active',
                    chips: ['off', 'on'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultToggleSwitch(isActive: false),
                        SizedBox(width: AppSpacing.s32),
                        DefaultToggleSwitch(isActive: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  const _SpecRow(
                    title: 'disable',
                    chips: ['off', 'on'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultToggleSwitch(isActive: false, isDisabled: true),
                        SizedBox(width: AppSpacing.s32),
                        DefaultToggleSwitch(isActive: true, isDisabled: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  const _SpecRow(
                    title: 'size',
                    chips: ['medium'],
                    child: DefaultToggleSwitch(isActive: true),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'test',
                    chips: ['disabled knob'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultToggleSwitch(
                          isActive: _active,
                          isDisabled: disabled,
                          semanticLabel: 'Widgetbook toggle switch preview',
                          onChanged: (active) =>
                              setState(() => _active = active),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          '실제 클릭 테스트: ${_active ? 'on' : 'off'}',
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
}

String get _trackSizeLabel {
  return '${AppContainerSize.toggleSwitchWidth.toInt()}×'
      '${AppContainerSize.toggleSwitchHeight.toInt()}px';
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
                  borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
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
