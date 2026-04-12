import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// AppBar 정렬 방식
///
/// - [center] : 타이틀 중앙 정렬
/// - [start] : 타이틀 시작 정렬
/// - [spaceBetween] : leading / title / trailing 영역을 균형 있게 배치
enum DefaultAppBarLayout {
  /// 타이틀 중앙 정렬
  center,

  /// 타이틀 시작 정렬
  start,

  /// 좌/우 액션과 타이틀을 균형 있게 배치
  spaceBetween,
}

/// 기본 AppBar 위젯
class DefaultAppBar extends PreferredSize {
  /// 액션 버튼 표시 여부
  final bool isActionVisible;

  /// 액션 버튼
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
  final Widget? title;

  /// 서브 타이틀
  ///
  /// display 형태처럼 정보 강조형 AppBar에서 사용합니다.
  final Widget? subtitle;

  /// 내부 레이아웃 방식
  final DefaultAppBarLayout layout;

  /// 하단 divider 표시 여부
  final bool showBottomBorder;

  /// 생성자
  const DefaultAppBar({
    super.key,
    super.preferredSize = const Size.fromHeight(kToolbarHeight),
    super.child = const SizedBox.shrink(),
    this.isActionVisible = true,
    this.actions,
    this.actionsPadding = const EdgeInsets.only(right: AppSpacing.s12),
    this.leading,
    this.leadingWidth,
    this.trailing,
    this.title,
    this.subtitle,
    this.layout = DefaultAppBarLayout.center,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    final resolvedActions = _buildActions();
    final resolvedTitleWidget = _buildTitleContent();
    final resolvedCenterTitle = layout == DefaultAppBarLayout.center;

    return AppBar(
      backgroundColor: colorScheme.backgroundNormal,
      surfaceTintColor: colorScheme.backgroundNormal,
      elevation: 0,
      leading: leading,
      leadingWidth: leadingWidth,
      centerTitle: resolvedCenterTitle,
      titleSpacing: layout == DefaultAppBarLayout.start ? 0 : null,
      title: layout == DefaultAppBarLayout.spaceBetween
          ? _BalancedHeader(
              leading: leading,
              title: resolvedTitleWidget,
              trailing: trailing ?? _buildActionsRow(resolvedActions),
            )
          : resolvedTitleWidget,
      actions: layout == DefaultAppBarLayout.spaceBetween
          ? null
          : (isActionVisible ? resolvedActions : null),
      actionsPadding: actionsPadding,
      bottom: showBottomBorder
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.strokeNeutral,
              ),
            )
          : null,
    );
  }

  List<Widget>? _buildActions() {
    if (!isActionVisible) {
      return null;
    }

    if (actions != null) {
      return actions;
    }

    if (trailing != null) {
      return [trailing!];
    }

    return null;
  }

  Widget _buildTitleContent() {
    final resolvedTitle = title ?? child;

    if (subtitle == null) {
      return resolvedTitle;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: layout == DefaultAppBarLayout.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [subtitle!, resolvedTitle],
    );
  }

  Widget? _buildActionsRow(List<Widget>? resolvedActions) {
    if (resolvedActions == null || resolvedActions.isEmpty) {
      return null;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: resolvedActions);
  }
}

class _BalancedHeader extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;

  const _BalancedHeader({
    required this.leading,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderSlot(alignment: Alignment.centerLeft, child: leading),
        Expanded(child: Center(child: title)),
        _HeaderSlot(alignment: Alignment.centerRight, child: trailing),
      ],
    );
  }
}

class _HeaderSlot extends StatelessWidget {
  final Widget? child;
  final Alignment alignment;

  const _HeaderSlot({required this.child, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kToolbarHeight,
      child: Align(alignment: alignment, child: child),
    );
  }
}
