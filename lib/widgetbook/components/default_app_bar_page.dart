import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// DefaultAppBar를 확인할 수 있는 페이지
class DefaultAppBarPage extends StatelessWidget {
  /// 초기 레이아웃
  final DefaultAppBarLayout initialLayout;

  /// 초기 title 표시 여부
  final bool initialShowTitle;

  /// 초기 subtitle 표시 여부
  final bool initialShowSubtitle;

  /// 생성자
  const DefaultAppBarPage({
    super.key,
    this.initialLayout = DefaultAppBarLayout.basic,
    this.initialShowTitle = true,
    this.initialShowSubtitle = true,
  });

  static const double _previewWidth = 440;
  static const double _previewMinHeight = 84;
  static const double _variantCardWidth = 500;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    final layout = context.knobs.object.dropdown<DefaultAppBarLayout>(
      label: 'Layout',
      options: DefaultAppBarLayout.values,
      initialOption: initialLayout,
      labelBuilder: (layout) => switch (layout) {
        DefaultAppBarLayout.basic => 'Basic',
        DefaultAppBarLayout.side => 'Side',
        DefaultAppBarLayout.display => 'Display',
      },
    );

    final showBottomBorder = context.knobs.object.dropdown<bool>(
      label: 'Bottom Border',
      options: const [false, true],
      initialOption: false,
    );

    final leftActionCount = context.knobs.object.dropdown<int>(
      label: 'Left Actions',
      options: const [0, 1, 2],
      initialOption: 1,
    );

    final rightActionCount = context.knobs.object.dropdown<int>(
      label: 'Right Actions',
      options: const [0, 1, 2],
      initialOption: 1,
    );

    final showTitle = context.knobs.object.dropdown<bool>(
      label: 'Title',
      options: const [false, true],
      initialOption: initialShowTitle,
    );

    final showSubtitle = context.knobs.object.dropdown<bool>(
      label: 'Subtitle',
      options: const [false, true],
      initialOption: initialShowSubtitle,
    );

    final title = context.knobs.object.dropdown<String>(
      label: 'Title Text',
      options: const ['Default AppBar', '프로필 입력', '아주 긴 제목이 들어가는 경우'],
      initialOption: '프로필 입력',
    );

    final subtitle = context.knobs.object.dropdown<String>(
      label: 'Subtitle Text',
      options: const ['보조 설명', '상태 기반 UI 확인용', '긴 보조 문구가 들어가는 경우'],
      initialOption: '상태 기반 UI 확인용',
    );

    final resolvedTitle = layout == DefaultAppBarLayout.display
        ? title
        : (showTitle ? title : null);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Bar', style: typography.title),
            const SizedBox(height: AppSpacing.s8),
            Text(
              '사용자가 현재 위치를 인지하고, 주요 액션과 탐색을 빠르게 '
              '수행할 수 있도록 돕는 핵심 UI 컴포넌트입니다.',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: AppSpacing.s24),
            _SectionCard(
              title: 'Interactive',
              description: '선택한 layout과 액션 수, title/subtitle 상태를 확인합니다.',
              child: _AppBarPreview(
                child: DefaultAppBar(
                  layout: layout,
                  isActionVisible: rightActionCount > 0,
                  showBottomBorder: showBottomBorder,
                  leadingActions: _buildActionIcons(leftActionCount),
                  title: resolvedTitle,
                  isTitleTranslationKey: false,
                  subtitle: showSubtitle ? subtitle : null,
                  isSubtitleTranslationKey: false,
                  actions: _buildActionIcons(rightActionCount),
                ),
              ),
            ),
            Wrap(
              spacing: AppSpacing.s24,
              runSpacing: AppSpacing.s24,
              children: const [
                _VariantCard(
                  title: 'Basic',
                  description: '단순한 화면 / 기본 구조 정의',
                  usage: '아이콘 기반의 기본 액션으로 구성된 표준 App Bar',
                  samples: [
                    _BasicNoTitleSample(),
                    _BasicTitleSample(),
                    _BasicTwoSideSample(),
                  ],
                ),
                _VariantCard(
                  title: 'Side',
                  description: '좌/우 강조형',
                  usage: '텍스트 버튼, 재화/상태 정보 등 복합 요소를 포함',
                  samples: [_SideSkipSample(), _SideCurrencySample()],
                ),
                _VariantCard(
                  title: 'Display',
                  description: '정보 강조형 / 콘텐츠 중심',
                  usage: '타이틀과 보조 텍스트로 화면의 핵심 정보를 강조',
                  samples: [_DisplayTitleSample(), _DisplaySubtitleSample()],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget>? _buildActionIcons(int count) {
    if (count == 0) {
      return null;
    }

    const icons = [Icons.arrow_back_ios_new_rounded, Icons.close_rounded];

    return List<Widget>.generate(
      count,
      (index) => IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: AppIconPixelGrid.xl,
          height: AppIconPixelGrid.xl,
        ),
        iconSize: AppIconSize.xl,
        icon: Icon(icons[index]),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _SectionCard({
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
            const SizedBox(height: AppSpacing.s20),
            child,
          ],
        ),
      ),
    );
  }
}

class _VariantCard extends StatelessWidget {
  final String title;
  final String description;
  final String usage;
  final List<Widget> samples;

  const _VariantCard({
    required this.title,
    required this.description,
    required this.usage,
    required this.samples,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Container(
      width: DefaultAppBarPage._variantCardWidth,
      padding: const EdgeInsets.all(AppPadding.card),
      decoration: BoxDecoration(
        color: colors.backgroundAlternative,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.title),
          const SizedBox(height: AppSpacing.s8),
          Text(description, style: typography.body),
          const SizedBox(height: AppSpacing.s12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppPadding.cardHorizontal),
            decoration: BoxDecoration(
              color: colors.backgroundNormal,
              borderRadius: BorderRadius.circular(AppRadius.standard),
            ),
            child: Text('활용: $usage', style: typography.caption),
          ),
          const SizedBox(height: AppSpacing.s24),
          ...samples.expand(
            (sample) => [sample, const SizedBox(height: AppSpacing.s16)],
          ),
        ],
      ),
    );
  }
}

class _AppBarPreview extends StatelessWidget {
  final Widget child;

  const _AppBarPreview({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        width: DefaultAppBarPage._previewWidth,
        constraints: const BoxConstraints(
          minHeight: DefaultAppBarPage._previewMinHeight,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: child,
      ),
    );
  }
}

class _BasicNoTitleSample extends StatelessWidget {
  const _BasicNoTitleSample();

  @override
  Widget build(BuildContext context) {
    return _AppBarPreview(
      child: DefaultAppBar(
        title: null,
        leadingActions: DefaultAppBarPage._buildActionIcons(2),
        actions: DefaultAppBarPage._buildActionIcons(2),
      ),
    );
  }
}

class _BasicTitleSample extends StatelessWidget {
  const _BasicTitleSample();

  @override
  Widget build(BuildContext context) {
    return _AppBarPreview(
      child: DefaultAppBar(
        title: '타이틀',
        isTitleTranslationKey: false,
        leadingActions: DefaultAppBarPage._buildActionIcons(2),
      ),
    );
  }
}

class _BasicTwoSideSample extends StatelessWidget {
  const _BasicTwoSideSample();

  @override
  Widget build(BuildContext context) {
    return _AppBarPreview(
      child: DefaultAppBar(
        title: '타이틀',
        isTitleTranslationKey: false,
        leadingActions: DefaultAppBarPage._buildActionIcons(2),
        actions: DefaultAppBarPage._buildActionIcons(2),
      ),
    );
  }
}

class _SideSkipSample extends StatelessWidget {
  const _SideSkipSample();

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return _AppBarPreview(
      child: DefaultAppBar(
        layout: DefaultAppBarLayout.side,
        title: '타이틀',
        isTitleTranslationKey: false,
        leadingActions: DefaultAppBarPage._buildActionIcons(2),
        trailing: Text(
          '건너뛰기',
          style: typography.bodySub.copyWith(color: colors.textAlternative),
        ),
      ),
    );
  }
}

class _SideCurrencySample extends StatelessWidget {
  const _SideCurrencySample();

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return _AppBarPreview(
      child: DefaultAppBar(
        layout: DefaultAppBarLayout.side,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco_rounded,
              size: AppIconSize.sm,
              color: colors.statusPositive,
            ),
            const SizedBox(width: AppSpacing.s4),
            Text('20', style: typography.main),
          ],
        ),
        actions: DefaultAppBarPage._buildActionIcons(2),
      ),
    );
  }
}

class _DisplayTitleSample extends StatelessWidget {
  const _DisplayTitleSample();

  @override
  Widget build(BuildContext context) {
    return _AppBarPreview(
      child: DefaultAppBar(
        layout: DefaultAppBarLayout.display,
        title: '타이틀',
        isTitleTranslationKey: false,
        actions: DefaultAppBarPage._buildActionIcons(2),
      ),
    );
  }
}

class _DisplaySubtitleSample extends StatelessWidget {
  const _DisplaySubtitleSample();

  @override
  Widget build(BuildContext context) {
    return _AppBarPreview(
      child: const DefaultAppBar(
        layout: DefaultAppBarLayout.display,
        title: '타이틀',
        isTitleTranslationKey: false,
        subtitle: '서브텍스트',
        isSubtitleTranslationKey: false,
        isActionVisible: false,
      ),
    );
  }
}
