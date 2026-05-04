import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_toggle_icon.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Toggle Icon 컴포넌트 프리뷰
class ToggleIconPage extends StatefulWidget {
  /// 생성자
  const ToggleIconPage({super.key});

  @override
  State<ToggleIconPage> createState() => _ToggleIconPageState();
}

class _ToggleIconPageState extends State<ToggleIconPage> {
  static const double _panelWidth = 640;

  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final resolvedSpec = <WidgetbookResolvedSpecEntry>[
      WidgetbookResolvedSpecEntry(
        label: 'Icon frame',
        value: '${AppContainerSize.toggleIcon.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Touch size',
        value: '${AppIconTouchSize.sm.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Radius',
        value: '${AppRadius.xs.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Border width',
        value: '${AppLineWidth.toggleIconBorder}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Dash / gap',
        value:
            '${AppContainerSize.toggleIconDash.toInt()} / ${AppContainerSize.toggleIconDashGap.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'State',
        value: _active ? 'active' : 'inactive',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Active stroke',
        value: 'primaryNormal (${widgetbookColorToHex(colors.primaryNormal)})',
        swatchColor: colors.primaryNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Inactive stroke',
        value: 'textDisable (${widgetbookColorToHex(colors.textDisable)})',
        swatchColor: colors.textDisable,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toggle Icon', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Text(
              '켜고 끄는 Control 개념으로 Icon을 쓰고자 할 때 사용해요.',
              style: typography.body,
            ),
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
                    chips: ['false', 'true'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultToggleIcon(isActive: false),
                        SizedBox(width: AppSpacing.s24),
                        DefaultToggleIcon(isActive: true),
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
                        const DefaultToggleIcon(isActive: false),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultToggleIcon(isActive: false),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayInactive,
                          child: const DefaultToggleIcon(isActive: false),
                        ),
                        const SizedBox(width: AppSpacing.s24),
                        _InteractionPreview(
                          overlayColor: colors.overlayPressed,
                          child: const DefaultToggleIcon(isActive: false),
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
                        DefaultToggleIcon(
                          isActive: _active,
                          semanticLabel: 'Widgetbook toggle icon preview',
                          onChanged: (active) =>
                              setState(() => _active = active),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Text(
                          '실제 클릭 테스트: ${_active ? 'active' : 'inactive'}',
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
            const SizedBox(height: AppSpacing.s40),
            const Divider(color: Colors.black),
            const SizedBox(height: AppSpacing.s32),
            Text('대표 예시', style: typography.subtitle),
            const SizedBox(height: AppSpacing.s24),
            Container(
              width: 360,
              padding: const EdgeInsets.all(AppPadding.card),
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                border: Border.all(color: colors.strokeStructuralDivider),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ExampleRow(
                    iconColor: colors.interactionInactive,
                    heartColor: colors.interactionInactive,
                    textColor: colors.textAlternative,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  _ExampleRow(
                    iconColor: colors.primaryNormal,
                    heartColor: colors.primaryNormal,
                    textColor: colors.textAlternative,
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

class _ExampleRow extends StatelessWidget {
  final Color iconColor;
  final Color heartColor;
  final Color textColor;

  const _ExampleRow({
    required this.iconColor,
    required this.heartColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite, size: AppIconSize.sm, color: heartColor),
        const SizedBox(width: AppSpacing.s8),
        Text('2', style: typography.body.copyWith(color: textColor)),
        const SizedBox(width: AppSpacing.s20),
        Icon(Icons.chat_bubble_outline, size: AppIconSize.sm, color: iconColor),
        const SizedBox(width: AppSpacing.s8),
        Text('13', style: typography.body.copyWith(color: textColor)),
      ],
    );
  }
}
