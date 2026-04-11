import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 AppBar 위젯
class DefaultAppBar extends PreferredSize {
  /// 액션 버튼 표시 여부
  final bool isActionVisible;

  /// 타이틀 가운데 정렬 여부
  final bool? centerTitle;

  /// 액션 버튼
  final List<Widget>? actions;

  /// 액션 버튼 패딩
  final EdgeInsets? actionsPadding;

  /// 생성자
  const DefaultAppBar({
    super.key,
    super.preferredSize = const Size.fromHeight(kToolbarHeight),
    super.child = const SizedBox.shrink(),
    this.isActionVisible = true,
    this.centerTitle,
    this.actions,
    this.actionsPadding = const EdgeInsets.only(right: AppSpacing.s12),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    return AppBar(
      backgroundColor: colorScheme.backgroundNormal,
      surfaceTintColor: colorScheme.backgroundNormal,
      centerTitle: centerTitle,
      actions: isActionVisible ? actions : null,
      title: child,
      actionsPadding: actionsPadding,
    );
  }
}
