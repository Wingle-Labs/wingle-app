import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/layout/app_breakpoints.dart';
import 'package:wingle/app/config/theme/layout/app_grid_spec.dart';
import 'package:wingle/app/config/theme/layout/grid_metrics.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Grid foundation을 확인할 수 있는 페이지
class GridPage extends StatelessWidget {
  /// 생성자
  const GridPage({super.key});

  static const _breakpoints = [
    _BreakpointSpec(
      token: 'mobile-sm',
      minWidth: 360,
      target: 'Galaxy 기본',
      layoutChange: '기본 1-column',
      preset: AppLayoutPreset.mobileSm,
    ),
    _BreakpointSpec(
      token: 'mobile-md',
      minWidth: 390,
      target: 'iPhone 표준',
      layoutChange: '여백/폰트 확장',
      preset: AppLayoutPreset.mobileMd,
    ),
    _BreakpointSpec(
      token: 'mobile-lg',
      minWidth: 430,
      target: 'Pro Max, Ultra',
      layoutChange: '콘텐츠 영역 확장',
      preset: AppLayoutPreset.mobileLg,
    ),
    _BreakpointSpec(
      token: 'tablet-sm',
      minWidth: 744,
      target: 'iPad Mini, Tab S9',
      layoutChange: '2-column 전환',
      preset: AppLayoutPreset.tabletSm,
    ),
    _BreakpointSpec(
      token: 'tablet-md',
      minWidth: 882,
      target: 'Fold 펼침, iPad Air',
      layoutChange: '사이드바 고정',
      preset: AppLayoutPreset.tabletMd,
    ),
    _BreakpointSpec(
      token: 'tablet-lg',
      minWidth: 1024,
      target: 'iPad Pro 13"',
      layoutChange: '풀 레이아웃',
      preset: AppLayoutPreset.tabletLg,
    ),
    _BreakpointSpec(
      token: 'desktop',
      minWidth: 1280,
      target: 'Tab Ultra, 웹',
      layoutChange: '최대 레이아웃',
      preset: AppLayoutPreset.desktop,
    ),
  ];

  static const _spacingScale = [
    2.0,
    4.0,
    6.0,
    8.0,
    12.0,
    16.0,
    24.0,
    32.0,
    40.0,
    48.0,
    56.0,
    64.0,
  ];

  @override
  Widget build(BuildContext context) {
    final selectedWidth = context.knobs.double.slider(
      label: 'Viewport Width',
      initialValue: 390,
      min: 320,
      max: 1440,
      divisions: 112,
    );
    final showSafeArea = context.knobs.object.dropdown<bool>(
      label: 'Safe Area',
      options: const [true, false],
      initialOption: true,
    );
    final showColumnLabels = context.knobs.object.dropdown<bool>(
      label: 'Column Labels',
      options: const [true, false],
      initialOption: true,
    );
    final breakpoint = _resolveBreakpointSpec(selectedWidth);
    final spec = AppLayoutResolver.resolvePreset(breakpoint.preset);
    final metrics = _buildMetrics(selectedWidth, spec);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GridTitle(),
            const SizedBox(height: 48),
            _ScreenSection(
              selectedWidth: selectedWidth,
              breakpoint: breakpoint,
              metrics: metrics,
              showSafeArea: showSafeArea,
            ),
            const SizedBox(height: 56),
            const _SpacingSection(),
            const SizedBox(height: 56),
            const _BreakpointSection(breakpoints: _breakpoints),
            const SizedBox(height: 56),
            _GridPreviewSection(
              selectedWidth: selectedWidth,
              breakpoint: breakpoint,
              metrics: metrics,
              showColumnLabels: showColumnLabels,
            ),
          ],
        ),
      ),
    );
  }

  static _BreakpointSpec _resolveBreakpointSpec(double width) {
    final resolved = AppLayoutResolver.resolveBreakpoint(width);

    return switch (resolved) {
      AppBreakpoint.mobileSm => _breakpoints[0],
      AppBreakpoint.mobileMd => _breakpoints[1],
      AppBreakpoint.mobileLg => _breakpoints[2],
      AppBreakpoint.tabletSm => _breakpoints[3],
      AppBreakpoint.tabletMd => _breakpoints[4],
      AppBreakpoint.tabletLg => _breakpoints[5],
      AppBreakpoint.desktop => _breakpoints[6],
      AppBreakpoint.xs => _breakpoints[0],
      AppBreakpoint.md => _breakpoints[3],
      AppBreakpoint.xl => _breakpoints[6],
    };
  }

  static GridMetrics _buildMetrics(double width, AppGridSpec spec) {
    final ratioSum = spec.columnRatios.fold<int>(
      0,
      (sum, value) => sum + value,
    );
    final gutterCount = spec.columnRatios.length - 1;
    final totalGutterWidth = spec.gutter * gutterCount;
    final contentWidth = width - (spec.horizontalPadding * 2);
    final unitWidth = (contentWidth - totalGutterWidth) / ratioSum;

    return GridMetrics(
      spec: spec,
      screenWidth: width,
      contentWidth: contentWidth,
      unitWidth: unitWidth,
    );
  }
}

class _GridTitle extends StatelessWidget {
  const _GridTitle();

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grid', style: typography.title),
        const SizedBox(height: 56),
        Divider(color: colors.strokeNeutral),
        const SizedBox(height: 40),
        Text(
          '화면, 간격, breakpoint, column grid를 한 흐름에서 확인합니다.',
          style: typography.body.copyWith(color: colors.textAlternative),
        ),
      ],
    );
  }
}

class _ScreenSection extends StatelessWidget {
  final double selectedWidth;
  final _BreakpointSpec breakpoint;
  final GridMetrics metrics;
  final bool showSafeArea;

  const _ScreenSection({
    required this.selectedWidth,
    required this.breakpoint,
    required this.metrics,
    required this.showSafeArea,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return _FoundationSection(
      title: '화면',
      description:
          '${selectedWidth.toStringAsFixed(0)}px / ${breakpoint.token} / '
          'content ${metrics.contentWidth.toStringAsFixed(0)}px',
      footer: Text(
        '선택한 화면 폭에 맞춰 safe area, content width, navigation 영역을 보여줍니다.',
        style: typography.caption,
      ),
      child: _DefinitionPanel(
        child: Center(
          child: _DeviceFrame(
            width: selectedWidth,
            metrics: metrics,
            showSafeArea: showSafeArea,
          ),
        ),
      ),
    );
  }
}

class _SpacingSection extends StatelessWidget {
  const _SpacingSection();

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return _FoundationSection(
      title: '간격',
      description: '여백은 4의 배수를 기본으로 하되, 예외적으로 2의 배수를 사용합니다.',
      footer: Text(
        'Spacing token scale: 2, 4, 6, 8, 12 ... 64',
        style: typography.caption,
      ),
      child: Column(
        children: [
          _DefinitionPanel(
            child: Column(
              children: GridPage._spacingScale
                  .map((value) => _SpacingScaleRow(value: value))
                  .toList(),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: const [
              _SpacingExampleCard(
                title: '텍스트와 아이콘',
                description: '기본적으로는 4px을 기준으로 간격을 잡습니다.',
                kind: _SpacingExampleKind.iconText,
              ),
              _SpacingExampleCard(
                title: '시각 보정',
                description: '필요한 경우 2px씩 조정하고, 더 섬세하면 1px씩 조정합니다.',
                kind: _SpacingExampleKind.visualCorrection,
              ),
              _SpacingExampleCard(
                title: '요소 높이',
                description: '특정 높이가 되어야 하는 경우 의도를 설명할 수 있게 표시합니다.',
                kind: _SpacingExampleKind.fixedHeight,
              ),
              _SpacingExampleCard(
                title: 'Navigation',
                description: '56px 높이에 1px separator를 더하는 식으로 안내합니다.',
                kind: _SpacingExampleKind.navigation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakpointSection extends StatelessWidget {
  final List<_BreakpointSpec> breakpoints;

  const _BreakpointSection({required this.breakpoints});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return _FoundationSection(
      title: 'Breakpoint',
      description: '최종 breakpoint 설계 기준입니다.',
      footer: Text(
        '기존 xs/md/xl enum은 호환을 위해 남기고, resolver는 새 7단계를 반환합니다.',
        style: typography.caption,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DefinitionPanel(
            child: Wrap(
              spacing: 44,
              runSpacing: 24,
              children: breakpoints
                  .map((item) => _BreakpointMarker(item: item))
                  .toList(),
            ),
          ),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.7),
                3: FlexColumnWidth(1.8),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: colors.backgroundAlternative,
                  ),
                  children: const [
                    _TableHeader('Token'),
                    _TableHeader('min-width'),
                    _TableHeader('주요 대상'),
                    _TableHeader('레이아웃 변화'),
                  ],
                ),
                ...breakpoints.map(
                  (item) => TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: colors.strokeNeutral),
                      ),
                    ),
                    children: [
                      _TableCell(item.token, monospace: true),
                      _TableCell('${item.minWidth}px'),
                      _TableCell(item.target),
                      _TableCell(item.layoutChange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPreviewSection extends StatelessWidget {
  final double selectedWidth;
  final _BreakpointSpec breakpoint;
  final GridMetrics metrics;
  final bool showColumnLabels;

  const _GridPreviewSection({
    required this.selectedWidth,
    required this.breakpoint,
    required this.metrics,
    required this.showColumnLabels,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final spec = metrics.spec;

    return _FoundationSection(
      title: 'Grid Preview',
      description:
          '${breakpoint.token} · padding ${spec.horizontalPadding}px · '
          'gutter ${spec.gutter}px · ${spec.columnCount} columns',
      footer: Text(
        'unit width ${metrics.unitWidth.toStringAsFixed(1)}px, '
        'content ${metrics.contentWidth.toStringAsFixed(1)}px',
        style: typography.caption,
      ),
      child: _DefinitionPanel(
        child: Center(
          child: _GridCanvas(
            width: selectedWidth,
            metrics: metrics,
            showColumnLabels: showColumnLabels,
          ),
        ),
      ),
    );
  }
}

class _FoundationSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final Widget footer;

  const _FoundationSection({
    required this.title,
    required this.description,
    required this.child,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: colors.strokeNeutral),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 220, child: Text(title, style: typography.main)),
            Expanded(
              child: Text(
                description,
                style: typography.body.copyWith(color: colors.textNormal),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        child,
        const SizedBox(height: 16),
        footer,
      ],
    );
  }
}

class _DefinitionPanel extends StatelessWidget {
  final Widget child;

  const _DefinitionPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  final double width;
  final GridMetrics metrics;
  final bool showSafeArea;

  const _DeviceFrame({
    required this.width,
    required this.metrics,
    required this.showSafeArea,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scaledWidth = width.clamp(240, 520).toDouble();
    final height = scaledWidth * 1.9;
    final horizontalPadding = metrics.spec.horizontalPadding;

    return Container(
      width: scaledWidth,
      height: height,
      decoration: BoxDecoration(
        color: colors.backgroundNormal,
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      child: Stack(
        children: [
          if (showSafeArea)
            Positioned.fill(
              left: horizontalPadding,
              right: horizontalPadding,
              top: 36,
              bottom: 64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primaryNormal.withValues(alpha: 0.08),
                  border: Border.all(
                    color: colors.primaryNormal.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 56,
            child: ColoredBox(
              color: colors.backgroundNormal,
              child: Border(
                top: BorderSide(color: colors.strokeNeutral),
              ).toWidget(),
            ),
          ),
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 18,
            child: _MeasurementLine(
              label: '${metrics.contentWidth.toStringAsFixed(0)}px',
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCanvas extends StatelessWidget {
  final double width;
  final GridMetrics metrics;
  final bool showColumnLabels;

  const _GridCanvas({
    required this.width,
    required this.metrics,
    required this.showColumnLabels,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scaledWidth = width.clamp(260, 920).toDouble();
    final spec = metrics.spec;

    return Container(
      width: scaledWidth,
      height: 320,
      color: colors.backgroundNormal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spec.horizontalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < spec.columnRatios.length; i++) ...[
              Expanded(
                flex: spec.columnRatios[i],
                child: _GridColumn(label: showColumnLabels ? '${i + 1}' : null),
              ),
              if (i != spec.columnRatios.length - 1)
                SizedBox(
                  width: spec.gutter,
                  child: ColoredBox(
                    color: colors.statusNegative.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GridColumn extends StatelessWidget {
  final String? label;

  const _GridColumn({this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ColoredBox(
      color: colors.primaryNormal.withValues(alpha: 0.16),
      child: Center(
        child: label == null
            ? const SizedBox.shrink()
            : Text(label!, style: typography.caption),
      ),
    );
  }
}

class _SpacingScaleRow extends StatelessWidget {
  final double value;

  const _SpacingScaleRow({required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCorrection = value == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: value,
            width: double.infinity,
            color: isCorrection
                ? colors.statusNegative.withValues(alpha: 0.28)
                : colors.primaryNormal.withValues(alpha: 0.18),
          ),
          _ValueChip(
            label: value.toStringAsFixed(0),
            color: isCorrection ? colors.statusNegative : colors.primaryNormal,
          ),
        ],
      ),
    );
  }
}

enum _SpacingExampleKind { iconText, visualCorrection, fixedHeight, navigation }

class _SpacingExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final _SpacingExampleKind kind;

  const _SpacingExampleCard({
    required this.title,
    required this.description,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return SizedBox(
      width: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.backgroundAlternative,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildExample(context),
          ),
          const SizedBox(height: 12),
          Text(title, style: typography.mainSub),
          const SizedBox(height: 8),
          Text(
            description,
            style: typography.caption.copyWith(color: colors.textAlternative),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return switch (kind) {
      _SpacingExampleKind.iconText => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.radio_button_checked, size: 24),
          Container(
            width: AppSpacing.s8,
            height: 52,
            color: colors.statusNegative.withValues(alpha: 0.36),
            alignment: Alignment.center,
            child: const _ValueChip(label: '8'),
          ),
          Text('텍스트', style: typography.title),
        ],
      ),
      _SpacingExampleKind.visualCorrection => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 96,
            height: 64,
            color: colors.statusNegative.withValues(alpha: 0.24),
          ),
          Text('라벨', style: typography.title),
          const Positioned(top: 76, child: _ValueChip(label: '2')),
          const Positioned(left: 96, child: _ValueChip(label: '5')),
          const Positioned(right: 96, child: _ValueChip(label: '5')),
          const Positioned(bottom: 76, child: _ValueChip(label: '2')),
        ],
      ),
      _SpacingExampleKind.fixedHeight => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: AppSpacing.s56,
            width: double.infinity,
            color: colors.primaryNormal.withValues(alpha: 0.14),
          ),
          Text('제목', style: typography.title),
          const Positioned(child: _VerticalMeasure(label: '56')),
        ],
      ),
      _SpacingExampleKind.navigation => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: AppSpacing.s56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.primaryNormal.withValues(alpha: 0.14),
              border: Border(
                bottom: BorderSide(color: colors.primaryNormal, width: 1),
              ),
            ),
          ),
          Text('제목', style: typography.title),
          const Positioned(child: _VerticalMeasure(label: '56')),
          const Positioned(bottom: 86, child: _ValueChip(label: '1')),
        ],
      ),
    };
  }
}

class _BreakpointMarker extends StatelessWidget {
  final _BreakpointSpec item;

  const _BreakpointMarker({required this.item});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${item.minWidth}', style: typography.mainSub),
        const SizedBox(height: 6),
        Container(width: 1, height: 24, color: Colors.black),
        const SizedBox(height: 6),
        Text(item.token, style: typography.caption),
        const SizedBox(height: 4),
        Text(item.target, style: typography.caption),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Text(text, style: typography.mainSub),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool monospace;

  const _TableCell(this.text, {this.monospace = false});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Text(
        text,
        style: typography.body.copyWith(
          color: monospace ? colors.statusNegative : colors.textNormal,
          fontFamily: monospace ? 'monospace' : null,
        ),
      ),
    );
  }
}

class _MeasurementLine extends StatelessWidget {
  final String label;

  const _MeasurementLine({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: colors.statusNegative)),
        _ValueChip(label: label, color: colors.statusNegative),
        Expanded(child: Container(height: 1, color: colors.statusNegative)),
      ],
    );
  }
}

class _VerticalMeasure extends StatelessWidget {
  final String label;

  const _VerticalMeasure({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: AppSpacing.s56,
      child: Column(
        children: [
          Expanded(child: Container(width: 1, color: colors.statusNegative)),
          _ValueChip(label: label, color: colors.statusNegative),
          Expanded(child: Container(width: 1, color: colors.statusNegative)),
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _ValueChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedColor = color ?? colors.statusNegative;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.typography.caption.copyWith(
          color: colors.staticWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BreakpointSpec {
  final String token;
  final int minWidth;
  final String target;
  final String layoutChange;
  final AppLayoutPreset preset;

  const _BreakpointSpec({
    required this.token,
    required this.minWidth,
    required this.target,
    required this.layoutChange,
    required this.preset,
  });
}

extension on Border {
  Widget toWidget() {
    return DecoratedBox(decoration: BoxDecoration(border: this));
  }
}
