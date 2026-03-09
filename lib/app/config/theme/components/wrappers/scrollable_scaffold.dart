import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 스크롤 가능한 Scaffold
class ScrollableScaffold extends ConsumerStatefulWidget {
  /// 제목
  final String title;

  /// 바디
  final List<Widget> body;

  /// 바디 간격
  final double? spacing;

  /// FloatingActionButton
  final Widget? floatingActionButton;

  /// 바디 마지막 여유 공간 추가 여부
  final bool? addBottomSpacing;

  /// 바디 정렬 방식
  final CrossAxisAlignment crossAxisAlignment;

  /// 생성자
  const ScrollableScaffold({
    super.key,
    required this.title,
    this.spacing,
    required this.body,
    this.floatingActionButton,
    this.addBottomSpacing,
    this.crossAxisAlignment = .start,
  });

  @override
  ConsumerState<ScrollableScaffold> createState() => _ScrollableScaffoldState();
}

class _ScrollableScaffoldState extends ConsumerState<ScrollableScaffold> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title.tr())),
      backgroundColor: colorScheme.backgroundNormal,
      body: SingleChildScrollView(
        padding: .all(AppPadding.scaffold),
        child: Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          spacing: widget.spacing ?? AppSpacing.md,
          children: [
            ...widget.body,
            widget.addBottomSpacing ?? true
                ? Padding(padding: .only(bottom: AppSpacing.bottom))
                : const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: widget.floatingActionButton != null
          ? SmoothRectWrapper(child: widget.floatingActionButton as Widget)
          : null,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
    );
  }
}
