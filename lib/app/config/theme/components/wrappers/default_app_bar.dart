import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_icon_button.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/text/app_typography.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// AppBar 정렬 방식
///
/// - [basic] : 아이콘 액션 기반의 표준 AppBar
/// - [side] : 텍스트 버튼, 재화, 상태 등 복합 요소를 포함하는 AppBar
/// - [display] : 좌측에 title/subtitle을 강조하는 AppBar
enum DefaultAppBarLayout {
  /// 기본 구조
  basic,

  /// 좌/우 강조형
  side,

  /// 정보 강조형
  display,
}

/// 기본 AppBar 위젯
class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _actionSize = AppIconSize.xl;
  static const double _actionHitSize = AppIconPixelGrid.xl;
  static const double _actionGap = 4;
  static const double _titleHorizontalGap = 12;
  static const double _displayTextGap = 6;
  static const double _minimumToolbarHeight =
      AppPadding.vertical * 2 + _actionHitSize;

  /// 좌측 액션 버튼
  final List<Widget>? leadingActions;

  /// 액션 버튼 표시 여부
  final bool isActionVisible;

  /// 우측 액션 버튼
  final List<Widget>? actions;

  /// 액션 버튼 패딩
  final EdgeInsets? actionsPadding;

  /// 좌측 위젯
  final Widget? leading;

  /// 좌측 위젯 너비
  final double? leadingWidth;

  /// 우측 위젯
  ///
  /// [actions] 대신 단일 trailing 위젯이 필요한 경우 사용합니다.
  final Widget? trailing;

  /// 메인 타이틀
  final String? title;

  /// 제목이 번역 키인지 여부
  final bool isTitleTranslationKey;

  /// 서브 타이틀
  ///
  /// [DefaultAppBarLayout.display]에서만 표시됩니다.
  final String? subtitle;

  /// 서브 타이틀이 번역 키인지 여부
  final bool isSubtitleTranslationKey;

  /// 내부 레이아웃 방식
  final DefaultAppBarLayout layout;

  /// 하단 divider 표시 여부
  final bool showBottomBorder;

  /// 생성자
  const DefaultAppBar({
    super.key,
    Size preferredSize = const Size.fromHeight(_minimumToolbarHeight),
    this.leadingActions,
    this.isActionVisible = true,
    this.actions,
    this.actionsPadding,
    this.leading,
    this.leadingWidth,
    this.trailing,
    this.title,
    this.isTitleTranslationKey = true,
    this.subtitle,
    this.isSubtitleTranslationKey = true,
    this.layout = DefaultAppBarLayout.basic,
    this.showBottomBorder = false,
  }) : _preferredSize = preferredSize;

  final Size _preferredSize;

  @override
  Size get preferredSize {
    if (layout != DefaultAppBarLayout.display || subtitle == null) {
      return _preferredSize;
    }

    final contentHeight = math.max(_actionHitSize, _displayTextBlockHeight);
    return Size.fromHeight(AppPadding.vertical * 2 + contentHeight);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final typography = context.typography;

    return Material(
      color: colorScheme.backgroundNormal,
      child: SafeArea(
        bottom: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: showBottomBorder
                ? Border(bottom: BorderSide(color: colorScheme.strokeNeutral))
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.horizontal,
              vertical: AppPadding.vertical,
            ),
            child: switch (layout) {
              DefaultAppBarLayout.basic => _BasicAppBarContent(
                leading: _resolveLeadingGroup(),
                title: title == null
                    ? null
                    : DefaultText(
                        title as String,
                        style: typography.main,
                        isTranslationKey: isTitleTranslationKey,
                      ),
                trailing: _resolveTrailingGroup(),
              ),
              DefaultAppBarLayout.side => _SideAppBarContent(
                leading: _resolveLeadingGroup(),
                title: title == null
                    ? null
                    : DefaultText(
                        title as String,
                        style: typography.main,
                        isTranslationKey: isTitleTranslationKey,
                      ),
                trailing: _resolveTrailingGroup(),
              ),
              DefaultAppBarLayout.display => _DisplayAppBarContent(
                title: title == null
                    ? const SizedBox.shrink()
                    : DefaultText(
                        title as String,
                        style: typography.title,
                        isTranslationKey: isTitleTranslationKey,
                      ),
                subtitle: subtitle == null
                    ? null
                    : DefaultText(
                        subtitle as String,
                        style: typography.appBarSubtitle,
                        isTranslationKey: isSubtitleTranslationKey,
                        color: colorScheme.textAlternative,
                      ),
                trailing: _resolveTrailingGroup(),
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _resolveLeadingGroup() {
    if (leadingActions != null) {
      return _ActionGroup(
        useIconGrid: _shouldUseIconGrid(leadingActions as List<Widget>),
        children: leadingActions as List<Widget>,
      );
    }

    if (leading != null) {
      return SizedBox(width: leadingWidth, child: leading);
    }

    return const _ActionGroup(useIconGrid: true, children: []);
  }

  Widget _resolveTrailingGroup() {
    if (!isActionVisible) {
      return const _ActionGroup(useIconGrid: true, children: []);
    }

    if (actions != null) {
      return _ActionGroup(
        alignment: MainAxisAlignment.end,
        useIconGrid: _shouldUseIconGrid(actions as List<Widget>),
        children: actions as List<Widget>,
      );
    }

    if (trailing != null) {
      return trailing as Widget;
    }

    return const _ActionGroup(useIconGrid: true, children: []);
  }

  bool _shouldUseIconGrid(List<Widget> children) {
    if (children.isEmpty) {
      return true;
    }

    return children.every(
      (child) =>
          child is Icon || child is IconButton || child is DefaultIconButton,
    );
  }

  double get _displayTextBlockHeight {
    final titleHeight = _measureTextHeight(
      title ?? '',
      AppTypography.base.title,
      isTranslationKey: isTitleTranslationKey,
    );
    final subtitleHeight = _measureTextHeight(
      subtitle ?? '',
      AppTypography.base.body,
      isTranslationKey: isSubtitleTranslationKey,
    );

    return titleHeight + _displayTextGap + subtitleHeight;
  }

  double _measureTextHeight(
    String text,
    TextStyle style, {
    required bool isTranslationKey,
  }) {
    final resolvedText = isTranslationKey ? text.tr() : text;
    final view = WidgetsBinding.instance.platformDispatcher.views.isEmpty
        ? null
        : WidgetsBinding.instance.platformDispatcher.views.first;
    final textScaler = view == null
        ? TextScaler.noScaling
        : MediaQueryData.fromView(view).textScaler;

    final painter = TextPainter(
      text: TextSpan(text: resolvedText, style: style),
      textDirection: ui.TextDirection.ltr,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();

    return painter.height;
  }
}

class _BasicAppBarContent extends StatelessWidget {
  final Widget leading;
  final Widget? title;
  final Widget trailing;

  const _BasicAppBarContent({
    required this.leading,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: DefaultAppBar._actionHitSize,
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: DefaultAppBar._titleHorizontalGap),
          Expanded(child: Center(child: title ?? const SizedBox.shrink())),
          const SizedBox(width: DefaultAppBar._titleHorizontalGap),
          trailing,
        ],
      ),
    );
  }
}

class _SideAppBarContent extends StatelessWidget {
  final Widget leading;
  final Widget? title;
  final Widget trailing;

  const _SideAppBarContent({
    required this.leading,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: DefaultAppBar._actionHitSize,
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: DefaultAppBar._titleHorizontalGap),
          Expanded(child: Center(child: title ?? const SizedBox.shrink())),
          const SizedBox(width: DefaultAppBar._titleHorizontalGap),
          trailing,
        ],
      ),
    );
  }
}

class _DisplayAppBarContent extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget trailing;

  const _DisplayAppBarContent({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null) ...[
                subtitle as Widget,
                const SizedBox(height: DefaultAppBar._displayTextGap),
              ],
              title,
            ],
          ),
        ),
        const SizedBox(width: DefaultAppBar._titleHorizontalGap),
        trailing,
      ],
    );
  }
}

class _ActionGroup extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment alignment;
  final bool useIconGrid;

  const _ActionGroup({
    this.alignment = MainAxisAlignment.start,
    required this.useIconGrid,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (!useIconGrid) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildFlexibleChildren(),
      );
    }

    return SizedBox(
      width: _groupWidth,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  double get _groupWidth {
    final actionCount = children.isEmpty ? 1 : children.length;
    final actionTotal = actionCount * DefaultAppBar._actionHitSize;
    final gapTotal = (actionCount - 1) * DefaultAppBar._actionGap;

    return actionTotal + gapTotal;
  }

  List<Widget> _buildChildren() {
    if (children.isEmpty) {
      return const [];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        widgets.add(const SizedBox(width: DefaultAppBar._actionGap));
      }

      widgets.add(
        SizedBox.square(
          dimension: DefaultAppBar._actionHitSize,
          child: Center(
            child: SizedBox.square(
              dimension: DefaultAppBar._actionSize,
              child: Center(child: children[index]),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildFlexibleChildren() {
    if (children.isEmpty) {
      return const [];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        widgets.add(const SizedBox(width: DefaultAppBar._actionGap));
      }

      widgets.add(children[index]);
    }

    return widgets;
  }
}
