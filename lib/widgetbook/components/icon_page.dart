import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/icons/default_icon.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// Icon 컴포넌트 프리뷰
class IconPage extends StatelessWidget {
  /// 생성자
  const IconPage({super.key});

  static const double _samplePanelWidth = 720;
  static const double _iconSlotHeight = 72;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final state = context.knobs.object.dropdown<DefaultIconState>(
      label: 'State',
      options: DefaultIconState.values,
      labelBuilder: (value) => value.name,
      initialOption: DefaultIconState.selected,
    );
    final icon = context.knobs.object.dropdown<IconData>(
      label: 'Icon',
      options: const [
        Icons.chat_bubble_rounded,
        Icons.home_rounded,
        Icons.groups_rounded,
        Icons.search_rounded,
      ],
      labelBuilder: _iconLabel,
      initialOption: Icons.groups_rounded,
    );
    final selectedSpecLayer = context.knobs.object.dropdown<_IconSpecLayerKind>(
      label: 'Spec Overlay',
      options: _IconSpecLayerKind.values,
      labelBuilder: (value) => value.label,
      initialOption: _IconSpecLayerKind.pixelGrid,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Icon', style: typography.title),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '아이콘은 기호를 통해 특정 개념을 빠르게 전달하기 위한 '
              '최소 단위입니다.',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s24),
            _IconCard(
              title: 'Interactive',
              description:
                  'State: ${state.name}, '
                  'Size: ${AppIconSize.md.toStringAsFixed(0)}px',
              child: _IconPreviewFrame(
                child: DefaultIcon(icon: icon, state: state),
              ),
            ),
            const _IconCard(
              title: 'Navigation',
              description: '탭/내비게이션에서 선택/비활성 상태를 구분합니다.',
              child: _NavigationIconSamples(),
            ),
            const _IconCard(
              title: 'Assets',
              description: '일반 콘텐츠 아이콘은 Normal 상태를 기본으로 사용합니다.',
              child: _AssetIconSamples(),
            ),
            _IconCard(
              title: 'Specs',
              description:
                  'DefaultIcon이 사용하는 슬롯, 픽셀 그리드, 터치 영역, '
                  '제작 가이드 도형 크기를 확인합니다.',
              supporting: const _IconSpecGlossary(),
              child: _IconSpecSamples(selectedLayer: selectedSpecLayer),
            ),
          ],
        ),
      ),
    );
  }

  static String _iconLabel(IconData icon) {
    return switch (icon) {
      Icons.chat_bubble_rounded => 'chat',
      Icons.home_rounded => 'home',
      Icons.groups_rounded => 'groups',
      Icons.search_rounded => 'search',
      _ => icon.codePoint.toString(),
    };
  }
}

class _IconCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? supporting;
  final Widget child;

  const _IconCard({
    required this.title,
    required this.description,
    this.supporting,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.card),
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.main),
            const SizedBox(height: AppSpacing.s8),
            Text(
              description,
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            if (supporting != null) ...[
              const SizedBox(height: AppSpacing.s12),
              supporting!,
            ],
            const SizedBox(height: AppSpacing.s24),
            child,
          ],
        ),
      ),
    );
  }
}

class _IconSpecGlossary extends StatelessWidget {
  const _IconSpecGlossary();

  static const _items = [
    ('Slot', 'DefaultIcon이 레이아웃에서 차지하는 기준 크기'),
    ('Touch', '터치 요소로 사용할 때 확보해야 하는 최소 조작 영역'),
    ('Pixel grid', '아이콘을 그릴 때 정렬 기준이 되는 제작 그리드'),
    ('Circle', '원형 아이콘 제작 기준 keyline'),
    ('Square', '정사각형 아이콘 제작 기준 keyline'),
    ('Rect H', '가로형 직사각형 아이콘 제작 기준 keyline'),
    ('Rect V', '세로형 직사각형 아이콘 제작 기준 keyline'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        for (final item in _items)
          _GlossaryChip(label: item.$1, description: item.$2),
      ],
    );
  }
}

class _GlossaryChip extends StatelessWidget {
  final String label;
  final String description;

  const _GlossaryChip({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: typography.caption.copyWith(color: colors.textNormal),
            ),
            TextSpan(
              text: description,
              style: typography.caption.copyWith(color: colors.textAlternative),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPreviewFrame extends StatelessWidget {
  final Widget child;

  const _IconPreviewFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: IconPage._samplePanelWidth,
      height: IconPage._iconSlotHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.standard),
      ),
      child: child,
    );
  }
}

class _NavigationIconSamples extends StatelessWidget {
  const _NavigationIconSamples();

  @override
  Widget build(BuildContext context) {
    return _IconPreviewFrame(
      child: Wrap(
        spacing: AppSpacing.s24,
        runSpacing: AppSpacing.s16,
        alignment: WrapAlignment.center,
        children: const [
          _StackedStateIcon(icon: Icons.chat_bubble_rounded),
          _StackedStateIcon(icon: Icons.home_rounded),
          _StackedStateIcon(icon: Icons.groups_rounded),
        ],
      ),
    );
  }
}

class _AssetIconSamples extends StatelessWidget {
  const _AssetIconSamples();

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return _IconPreviewFrame(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DefaultIcon(icon: Icons.search_rounded),
          const SizedBox(width: AppSpacing.s12),
          Text(
            'Normal',
            style: typography.body.copyWith(color: colors.textNormal),
          ),
        ],
      ),
    );
  }
}

class _StackedStateIcon extends StatelessWidget {
  final IconData icon;

  const _StackedStateIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: AppIconTouchSize.xl,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        border: Border.all(color: colors.primaryNormal),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultIcon(icon: icon, state: DefaultIconState.disabled),
          const SizedBox(height: AppSpacing.s8),
          DefaultIcon(icon: icon, state: DefaultIconState.selected),
        ],
      ),
    );
  }
}

class _IconSpecSamples extends StatelessWidget {
  final _IconSpecLayerKind selectedLayer;

  const _IconSpecSamples({required this.selectedLayer});

  static const _items = [
    ('xxs', AppIconSpec.xxs),
    ('xs', AppIconSpec.xs),
    ('sm', AppIconSpec.sm),
    ('md', AppIconSpec.md),
    ('lg', AppIconSpec.lg),
    ('xl', AppIconSpec.xl),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s16,
      children: [
        for (final item in _items)
          _IconSpecTile(
            name: item.$1,
            spec: item.$2,
            selectedLayer: selectedLayer,
          ),
      ],
    );
  }
}

class _IconSpecTile extends StatelessWidget {
  final String name;
  final AppIconSpec spec;
  final _IconSpecLayerKind selectedLayer;

  const _IconSpecTile({
    required this.name,
    required this.spec,
    required this.selectedLayer,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.standard),
        border: Border.all(color: colors.strokeStructuralBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name (${spec.icon.toStringAsFixed(0)}×'
            '${spec.icon.toStringAsFixed(0)})',
            style: typography.main,
          ),
          const SizedBox(height: AppSpacing.s16),
          SizedBox(
            height: 136,
            child: Center(
              child: _IconSpecPreview(spec: spec, selectedLayer: selectedLayer),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          _SpecLine(
            label: 'Slot',
            value: _square(spec.icon),
            isSelected: selectedLayer == _IconSpecLayerKind.slot,
          ),
          _SpecLine(
            label: 'Touch',
            value: _square(spec.touch),
            isSelected: selectedLayer == _IconSpecLayerKind.touch,
          ),
          _SpecLine(
            label: 'Pixel grid',
            value: _square(spec.pixelGrid),
            isSelected: selectedLayer == _IconSpecLayerKind.pixelGrid,
          ),
          _SpecLine(
            label: 'Circle',
            value: '${spec.circleKeyline.toStringAsFixed(0)}px',
            isSelected: selectedLayer == _IconSpecLayerKind.circle,
          ),
          _SpecLine(
            label: 'Square',
            value: _square(spec.squareKeyline),
            isSelected: selectedLayer == _IconSpecLayerKind.square,
          ),
          _SpecLine(
            label: 'Rect H',
            value: _rect(
              spec.horizontalRectKeylineWidth,
              spec.horizontalRectKeylineHeight,
            ),
            isSelected: selectedLayer == _IconSpecLayerKind.rectH,
          ),
          _SpecLine(
            label: 'Rect V',
            value: _rect(
              spec.verticalRectKeylineWidth,
              spec.verticalRectKeylineHeight,
            ),
            isSelected: selectedLayer == _IconSpecLayerKind.rectV,
          ),
        ],
      ),
    );
  }

  static String _square(double size) {
    final value = size.toStringAsFixed(0);
    return '$value×$value';
  }

  static String _rect(double width, double height) {
    return '${width.toStringAsFixed(0)}×${height.toStringAsFixed(0)}';
  }
}

class _IconSpecPreview extends StatelessWidget {
  final AppIconSpec spec;
  final _IconSpecLayerKind selectedLayer;

  const _IconSpecPreview({required this.spec, required this.selectedLayer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedInfo = _buildLayer(selectedLayer);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 96,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _IconSpecLayerBorder(layer: selectedInfo),
              DefaultIcon(
                icon: Icons.favorite_rounded,
                state: DefaultIconState.selected,
                size: spec.icon,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        SizedBox(
          height: 32,
          child: _IconSpecInfoText(
            text:
                '${selectedInfo.label} ${selectedInfo.value} · '
                '${selectedInfo.description}',
            color: colors.statusNegative,
          ),
        ),
      ],
    );
  }

  _IconSpecLayerInfo _buildLayer(_IconSpecLayerKind kind) {
    return switch (kind) {
      _IconSpecLayerKind.slot => _IconSpecLayerInfo(
        label: kind.label,
        value: _square(spec.icon),
        description: '레이아웃 기준 슬롯',
        width: spec.icon,
        height: spec.icon,
      ),
      _IconSpecLayerKind.touch => _IconSpecLayerInfo(
        label: kind.label,
        value: _square(spec.touch),
        description: '터치 조작 영역',
        width: spec.touch,
        height: spec.touch,
      ),
      _IconSpecLayerKind.pixelGrid => _IconSpecLayerInfo(
        label: kind.label,
        value: _square(spec.pixelGrid),
        description: '제작 그리드',
        width: spec.pixelGrid,
        height: spec.pixelGrid,
      ),
      _IconSpecLayerKind.circle => _IconSpecLayerInfo(
        label: kind.label,
        value: '${spec.circleKeyline.toStringAsFixed(0)}px',
        description: '원형 keyline',
        width: spec.circleKeyline,
        height: spec.circleKeyline,
        shape: BoxShape.circle,
      ),
      _IconSpecLayerKind.square => _IconSpecLayerInfo(
        label: kind.label,
        value: _square(spec.squareKeyline),
        description: '정사각형 keyline',
        width: spec.squareKeyline,
        height: spec.squareKeyline,
      ),
      _IconSpecLayerKind.rectH => _IconSpecLayerInfo(
        label: kind.label,
        value: _rect(
          spec.horizontalRectKeylineWidth,
          spec.horizontalRectKeylineHeight,
        ),
        description: '가로형 keyline',
        width: spec.horizontalRectKeylineWidth,
        height: spec.horizontalRectKeylineHeight,
      ),
      _IconSpecLayerKind.rectV => _IconSpecLayerInfo(
        label: kind.label,
        value: _rect(
          spec.verticalRectKeylineWidth,
          spec.verticalRectKeylineHeight,
        ),
        description: '세로형 keyline',
        width: spec.verticalRectKeylineWidth,
        height: spec.verticalRectKeylineHeight,
      ),
    };
  }

  static String _square(double size) {
    final value = size.toStringAsFixed(0);
    return '$value×$value';
  }

  static String _rect(double width, double height) {
    return '${width.toStringAsFixed(0)}×${height.toStringAsFixed(0)}';
  }
}

class _IconSpecLayerBorder extends StatelessWidget {
  final _IconSpecLayerInfo layer;

  const _IconSpecLayerBorder({required this.layer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: layer.width,
      height: layer.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: layer.shape,
          border: Border.all(
            color: colors.statusNegative,
            width: AppLineWidth.inputFieldOutline,
          ),
        ),
      ),
    );
  }
}

class _IconSpecInfoText extends StatelessWidget {
  final String text;
  final Color color;

  const _IconSpecInfoText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Center(
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: typography.caption.copyWith(color: color),
      ),
    );
  }
}

class _IconSpecLayerInfo {
  final String label;
  final String value;
  final String description;
  final double width;
  final double height;
  final BoxShape shape;

  const _IconSpecLayerInfo({
    required this.label,
    required this.value,
    required this.description,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });
}

enum _IconSpecLayerKind {
  slot('Slot'),
  touch('Touch'),
  pixelGrid('Pixel grid'),
  circle('Circle'),
  square('Square'),
  rectH('Rect H'),
  rectV('Rect V');

  final String label;

  const _IconSpecLayerKind(this.label);
}

class _SpecLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;

  const _SpecLine({
    required this.label,
    required this.value,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final color = isSelected ? colors.statusNegative : colors.textAlternative;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: typography.bodySub.copyWith(color: color),
            ),
          ),
          Text(value, style: typography.bodySub.copyWith(color: color)),
        ],
      ),
    );
  }
}
