import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/dividers/default_divider.dart';
import 'package:wingle/app/config/theme/components/states/pagination.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';
import 'package:wingle/widgetbook/components/component_resolved_spec.dart';

/// Pagination 컴포넌트 프리뷰
class PaginationPage extends StatefulWidget {
  /// 생성자
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final variant = context.knobs.object.dropdown<PaginationVariant>(
      label: 'Variant',
      options: PaginationVariant.values,
      initialOption: PaginationVariant.line,
      labelBuilder: (variant) => variant.name,
    );
    final length = context.knobs.object.dropdown<int>(
      label: 'Length',
      options: const [2, 3, 4, 5, 6],
      initialOption: 5,
    );
    final resolvedIndex = _currentIndex.clamp(0, length - 1);
    final colors = context.colors;
    final resolvedSpec = <WidgetbookResolvedSpecEntry>[
      WidgetbookResolvedSpecEntry(label: 'Variant', value: variant.name),
      WidgetbookResolvedSpecEntry(label: 'Length', value: '$length'),
      WidgetbookResolvedSpecEntry(
        label: 'Current index',
        value: '$resolvedIndex',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Item size',
        value: switch (variant) {
          PaginationVariant.dot =>
            '${AppContainerSize.paginationDot.toInt()}px',
          PaginationVariant.line => _lineSizeLabel,
        },
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Gap',
        value: '${AppSpacing.s8.toInt()}px',
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Active color',
        value: widgetbookTokenValue('primaryNormal', colors.primaryNormal),
        swatchColor: colors.primaryNormal,
      ),
      WidgetbookResolvedSpecEntry(
        label: 'Inactive color',
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
            Text('Pagination', style: typography.title),
            const SizedBox(height: AppSpacing.s24),
            Wrap(
              spacing: AppSpacing.s24,
              runSpacing: AppSpacing.s24,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                const _PrincipleCard(),
                _PreviewCard(
                  title: '사용 가능한 속성',
                  child: Row(
                    children: [
                      _PreviewFrame(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Pagination(
                              currentIndex: 0,
                              length: 6,
                              variant: PaginationVariant.line,
                            ),
                            SizedBox(height: AppSpacing.s32),
                            Pagination(currentIndex: 0, length: 5),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Variant', style: typography.body),
                          const SizedBox(height: AppSpacing.s12),
                          Text('하위 Instance', style: typography.body),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            _PreviewCard(
              title: 'Interactive',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PreviewFrame(
                    child: Pagination(
                      currentIndex: resolvedIndex,
                      length: length,
                      variant: variant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'currentIndex: $resolvedIndex / length: $length',
                    style: typography.body,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton(
                        onPressed: resolvedIndex > 0
                            ? () {
                                setState(() {
                                  _currentIndex = resolvedIndex - 1;
                                });
                              }
                            : null,
                        child: const Text('Previous'),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      FilledButton(
                        onPressed: resolvedIndex < length - 1
                            ? () {
                                setState(() {
                                  _currentIndex = resolvedIndex + 1;
                                });
                              }
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  WidgetbookResolvedSpecCard(entries: resolvedSpec),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            _PreviewCard(
              title: '대표 예시',
              child: Column(
                children: const [
                  _CarouselExample(),
                  SizedBox(height: AppSpacing.s24),
                  _ProgressExample(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String get _lineSizeLabel {
  return '${AppContainerSize.paginationLineWidth.toInt()}×'
      '${AppContainerSize.paginationLine.toInt()}px';
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: context.colors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.colors.strokeStructuralBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('원칙', style: context.typography.main),
          const SizedBox(height: AppSpacing.s16),
          Text('순서 및 단계를 표시할 때 사용합니다.', style: context.typography.body),
          const SizedBox(height: AppSpacing.s32),
          const DefaultDivider(length: 280),
          const SizedBox(height: AppSpacing.s32),
          Text('활용', style: context.typography.main),
          const SizedBox(height: AppSpacing.s16),
          Text('캐러셀이 쓰이는 다양한 곳에서 사용할 수 있습니다.', style: context.typography.body),
          const SizedBox(height: AppSpacing.s8),
          Text('진행 단계를 나타내야하는 곳에서 사용할 수 있습니다.', style: context.typography.body),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _PreviewCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      width: 820,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.main),
          const SizedBox(height: AppSpacing.s24),
          child,
        ],
      ),
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  final Widget child;

  const _PreviewFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 360,
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        borderRadius: BorderRadius.circular(AppRadius.standard),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      child: child,
    );
  }
}

class _CarouselExample extends StatelessWidget {
  const _CarouselExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      children: [
        Container(
          width: 240,
          height: 140,
          padding: const EdgeInsets.all(AppPadding.card),
          decoration: BoxDecoration(
            color: colors.backgroundNormal,
            borderRadius: BorderRadius.circular(AppRadius.standard),
            border: Border.all(color: colors.strokeStructuralBorder),
          ),
          child: Column(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.backgroundAlternative,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: AppSpacing.s12),
              const Pagination(currentIndex: 0, length: 5),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s32),
        Expanded(child: Text('캐러셀에서 위치를 나타낼 때 사용해요.', style: typography.body)),
      ],
    );
  }
}

class _ProgressExample extends StatelessWidget {
  const _ProgressExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      children: [
        Container(
          width: 320,
          height: 88,
          padding: const EdgeInsets.all(AppPadding.card),
          decoration: BoxDecoration(
            color: colors.backgroundNormal,
            borderRadius: BorderRadius.circular(AppRadius.standard),
            border: Border.all(color: colors.strokeStructuralBorder),
          ),
          child: const Center(
            child: Pagination(
              currentIndex: 0,
              length: 6,
              variant: PaginationVariant.line,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s32),
        Expanded(child: Text('진행 정도를 나타낼 때 사용해요.', style: typography.body)),
      ],
    );
  }
}
