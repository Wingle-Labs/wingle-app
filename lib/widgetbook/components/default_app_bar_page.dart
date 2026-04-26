import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
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

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

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
      options: const ['Default AppBar', '프로필 입력', '아주 긴 제목이 들어가는 경우를 확인합니다'],
      initialOption: '프로필 입력',
    );

    final subtitle = context.knobs.object.dropdown<String>(
      label: 'Subtitle Text',
      options: const [
        '보조 설명',
        '상태 기반 UI 확인용',
        '아주 긴 보조 문구가 들어갈 때도 레이아웃이 유지되는지 확인합니다',
      ],
      initialOption: '상태 기반 UI 확인용',
    );

    final resolvedLeadingActions = _buildActionIcons(leftActionCount);
    final resolvedActions = _buildActionIcons(rightActionCount);

    return Scaffold(
      appBar: DefaultAppBar(
        layout: layout,
        isActionVisible: rightActionCount > 0,
        showBottomBorder: showBottomBorder,
        leadingActions: resolvedLeadingActions,
        title: showTitle ? title : null,
        isTitleTranslationKey: false,
        subtitle: showSubtitle ? subtitle : null,
        isSubtitleTranslationKey: false,
        actions: resolvedActions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Layout: ${layout.name}', style: typography.main),
            const SizedBox(height: 8),
            Text('Bottom border: $showBottomBorder', style: typography.body),
            Text('Left actions: $leftActionCount', style: typography.body),
            Text('Right actions: $rightActionCount', style: typography.body),
            Text('Title: $showTitle', style: typography.body),
            Text('Subtitle: $showSubtitle', style: typography.body),
            const SizedBox(height: 24),
            Text(
              'DefaultAppBar를 다양한 상태에서 확인하는 프리뷰입니다.',
              style: typography.mainSub,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget>? _buildActionIcons(int count) {
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
