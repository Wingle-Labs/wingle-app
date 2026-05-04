import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_checkbox.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Checkbox 컴포넌트 프리뷰
class CheckboxPage extends StatefulWidget {
  /// 생성자
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  static const double _panelWidth = 640;

  DefaultCheckboxState _testState = DefaultCheckboxState.selected;

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
      WidgetbookResolvedSpecEntry(
        label: 'Size',
        value: '${AppIconSize.sm.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Touch size',
        value: '${AppIconTouchSize.sm.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Radius',
        value: '${AppRadius.checkboxRadius.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'State',
        value: disabled ? 'disabled' : _testState.name,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Background',
        value:
            'backgroundElevatedNormal (${widgetbookColorToHex(colors.backgroundElevatedNormal)})',
        swatchColor: colors.backgroundElevatedNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Border',
        value:
            'strokeStructuralBorder (${widgetbookColorToHex(colors.strokeStructuralBorder)})',
        swatchColor: colors.strokeStructuralBorder,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Active fill',
        value: 'primaryNormal (${widgetbookColorToHex(colors.primaryNormal)})',
        swatchColor: colors.primaryNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Disabled icon',
        value:
            'componentCheckboxIconDisabled (${widgetbookColorToHex(colors.componentCheckboxIconDisabled)})',
        swatchColor: colors.componentCheckboxIconDisabled,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Checkbox', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text('상위 위계로 활성화 여부를 제어할 때 사용해요.', style: typography.body),
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
                    title: 'size',
                    chips: ['md'],
                    child: DefaultCheckbox(isChecked: true),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  const _SpecRow(
                    title: 'state',
                    chips: ['unselected', 'selected', 'partial'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultCheckbox(isChecked: false),
                        SizedBox(width: AppSpacing.s24),
                        DefaultCheckbox(isChecked: true),
                        SizedBox(width: AppSpacing.s24),
                        DefaultCheckbox(isChecked: false, isPartial: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  const _SpecRow(
                    title: 'disable',
                    chips: ['false', 'true'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultCheckbox(isChecked: false),
                        SizedBox(width: AppSpacing.s24),
                        DefaultCheckbox(isChecked: true, isDisabled: true),
                        SizedBox(width: AppSpacing.s24),
                        DefaultCheckbox(
                          isChecked: false,
                          isPartial: true,
                          isDisabled: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'interaction',
                    chips: ['default', 'hovered', 'focused', 'pressed'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DefaultCheckbox(isChecked: true),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultCheckbox(isChecked: true),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultCheckbox(isChecked: true),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayPressed,
                          child: const DefaultCheckbox(isChecked: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'test',
                    chips: ['disabled knob'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultCheckbox(
                          isChecked:
                              _testState == DefaultCheckboxState.selected,
                          isPartial: _testState == DefaultCheckboxState.partial,
                          isDisabled: disabled,
                          semanticLabel: 'Widgetbook checkbox preview',
                          onChanged: (_) => setState(_rotateTestState),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          '실제 클릭 테스트: ${_testState.name}',
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

  void _rotateTestState() {
    _testState = switch (_testState) {
      DefaultCheckboxState.unselected => DefaultCheckboxState.selected,
      DefaultCheckboxState.selected => DefaultCheckboxState.partial,
      DefaultCheckboxState.partial => DefaultCheckboxState.unselected,
    };
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

class _InteractionPreview extends StatelessWidget {
  final Color overlayColor;
  final Widget child;

  const _InteractionPreview({required this.overlayColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: overlayColor, shape: BoxShape.circle),
      child: SizedBox.square(dimension: AppIconTouchSize.sm, child: child),
    );
  }
}
