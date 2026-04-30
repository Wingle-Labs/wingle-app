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
  final Widget child;

  const _IconCard({
    required this.title,
    required this.description,
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
            const SizedBox(height: AppSpacing.s24),
            child,
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
