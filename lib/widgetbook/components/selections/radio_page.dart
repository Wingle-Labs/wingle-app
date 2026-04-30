import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/buttons/default_radio.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Radio 컴포넌트 프리뷰
class RadioPage extends StatefulWidget {
  /// 생성자
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  static const double _panelWidth = 640;

  bool _selected = true;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final disabled = context.knobs.object.dropdown<bool>(
      label: 'Disabled',
      options: const [false, true],
      initialOption: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radio', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text('여러 항목 중 하나를 선택해야 할 때 사용해요.', style: typography.body),
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
                    chips: ['normal', 'small'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultRadio(isSelected: true),
                        SizedBox(width: AppSpacing.s24),
                        DefaultRadio(
                          isSelected: true,
                          size: DefaultRadioSize.small,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  const _SpecRow(
                    title: 'state',
                    chips: ['unchecked', 'checked'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultRadio(isSelected: false),
                        SizedBox(width: AppSpacing.s24),
                        DefaultRadio(isSelected: true),
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
                        DefaultRadio(isSelected: false, isDisabled: true),
                        SizedBox(width: AppSpacing.s24),
                        DefaultRadio(isSelected: true, isDisabled: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s32),
                  _SpecRow(
                    title: 'interaction',
                    chips: ['normal', 'hovered', 'focused', 'pressed'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const DefaultRadio(isSelected: true),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultRadio(isSelected: true),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultRadio(isSelected: true),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayPressed,
                          child: const DefaultRadio(isSelected: true),
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
                        DefaultRadio(
                          isSelected: _selected,
                          isDisabled: disabled,
                          semanticLabel: 'Widgetbook radio preview',
                          onChanged: (_) =>
                              setState(() => _selected = !_selected),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          '실제 클릭 테스트: ${_selected ? 'checked' : 'unchecked'}',
                          style: typography.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
