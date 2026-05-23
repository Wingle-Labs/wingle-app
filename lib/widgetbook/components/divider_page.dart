import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/dividers/default_divider.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Divider 컴포넌트 프리뷰
class DividerPage extends StatelessWidget {
  /// 생성자
  const DividerPage({super.key});

  static const double _figmaWidth = 375;
  static const double _figmaVerticalHeight = 32;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final variant = context.knobs.object.dropdown<DefaultDividerVariant>(
      label: 'Variant',
      options: DefaultDividerVariant.values,
      labelBuilder: (value) => value.name,
      initialOption: DefaultDividerVariant.normal,
    );
    final vertical = context.knobs.object.dropdown<bool>(
      label: 'Vertical',
      options: const [false, true],
      initialOption: false,
    );
    final length = context.knobs.double.slider(
      label: 'Length',
      initialValue: vertical ? _figmaVerticalHeight : _figmaWidth,
      min: vertical ? 16 : 120,
      max: vertical ? 120 : 560,
    );
    final resolvedSpec = <WidgetbookResolvedSpecEntry>[
      WidgetbookResolvedSpecEntry(label: 'Variant', value: variant.name),
      WidgetbookResolvedSpecEntry(
        label: 'Axis',
        value: vertical ? 'vertical' : 'horizontal',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Length',
        value: '${length.toStringAsFixed(0)}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Thickness',
        value: '${_thicknessFor(variant).toStringAsFixed(0)}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Color',
        value: widgetbookTokenValue(
          'strokeStructuralDivider',
          colors.strokeStructuralDivider,
        ),
        swatchColor: colors.strokeStructuralDivider,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Preview frame radius',
        value: '${AppRadius.standard.toInt()}px',
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Divider', style: typography.title),
            const SizedBox(height: 8),
            Text(
              '화면 구성에서 정보를 분리하거나 묶어야 할 때 사용하는 '
              'Basic/Divider입니다.',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _DividerCard(
              title: 'Interactive',
              description:
                  'Variant: ${variant.name}, Vertical: $vertical, '
                  'Length: ${length.toStringAsFixed(0)}px',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DividerPreviewFrame(
                    child: DefaultDivider(
                      variant: variant,
                      vertical: vertical,
                      length: length,
                    ),
                  ),
                  const SizedBox(height: 24),
                  WidgetbookResolvedSpecCard(entries: resolvedSpec),
                ],
              ),
            ),
            _DividerCard(
              title: '사용 가능한 속성',
              description: 'Variant와 Vertical 축을 함께 확인합니다.',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                children: const [
                  _DividerSpecSample(
                    label: 'Normal / Horizontal',
                    child: DefaultDivider(length: _figmaWidth),
                  ),
                  _DividerSpecSample(
                    label: 'Thick / Horizontal',
                    child: DefaultDivider(
                      variant: DefaultDividerVariant.thick,
                      length: _figmaWidth,
                    ),
                  ),
                  _DividerSpecSample(
                    label: 'Normal / Vertical',
                    child: DefaultDivider(vertical: true),
                  ),
                ],
              ),
            ),
            _DividerCard(
              title: '대표 예시',
              description: '콘텐츠 그룹 구분과 목록 내부 구분에 사용합니다.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _InformationCard(),
                  const SizedBox(height: 24),
                  const _FaqCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _thicknessFor(DefaultDividerVariant variant) {
  return variant == DefaultDividerVariant.normal
      ? AppLineWidth.dividerNormal
      : AppLineWidth.dividerThick;
}

class _DividerCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _DividerCard({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.main),
            const SizedBox(height: 8),
            Text(
              description,
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _DividerPreviewFrame extends StatelessWidget {
  final Widget child;

  const _DividerPreviewFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 420,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _DividerSpecSample extends StatelessWidget {
  final String label;
  final Widget child;

  const _DividerSpecSample({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: typography.body),
          const SizedBox(height: 12),
          _DividerPreviewFrame(child: child),
          const SizedBox(height: 8),
          Text(
            'Color: Semantic/Stroke/Structural/Divider (#F2F2F2)',
            style: typography.caption.copyWith(color: colors.textAlternative),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: 375,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('정보를 찾고 계셨나요?', style: typography.main),
          ),
          const SizedBox(height: 16),
          const DefaultDivider(variant: DefaultDividerVariant.thick),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const _PlaceholderBlock(),
                const SizedBox(width: 12),
                const _PlaceholderBlock(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 375,
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      child: Column(
        children: [
          _FaqRow(title: '어떤 일을 요청할 수 있나요?'),
          const DefaultDivider(),
          _FaqRow(title: '로테이션 스케일이 뭔가요?'),
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  final String title;

  const _FaqRow({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(child: Text(title, style: typography.body)),
          Icon(Icons.keyboard_arrow_down, color: colors.textAlternative),
        ],
      ),
    );
  }
}

class _PlaceholderBlock extends StatelessWidget {
  const _PlaceholderBlock();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Expanded(
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: colors.backgroundAlternative,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
