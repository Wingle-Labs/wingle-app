import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/wrappers/default_app_bar.dart';
import 'package:wingle/app/config/theme/components/wrappers/smooth_rect.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 스크롤 가능한 Scaffold
class ScrollableScaffold extends ConsumerStatefulWidget {
  /// 제목
  final String? title;

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

  /// 뒤로가기 방지 여부
  final bool? canPop;

  /// 뒤로가기 시 호출할 콜백
  final VoidCallback? onPop;

  /// 생성자
  const ScrollableScaffold({
    super.key,
    this.title,
    this.spacing,
    required this.body,
    this.floatingActionButton,
    this.addBottomSpacing,
    this.crossAxisAlignment = .start,
    this.canPop,
    this.onPop,
  });

  @override
  ConsumerState<ScrollableScaffold> createState() => _ScrollableScaffoldState();
}

class _ScrollableScaffoldState extends ConsumerState<ScrollableScaffold> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    return PopScope(
      canPop: widget.canPop ?? true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.onPop?.call();
        }
      },
      child: Scaffold(
        appBar: DefaultAppBar(title: widget.title),
        backgroundColor: colorScheme.backgroundNormal,
        body: SingleChildScrollView(
          padding: .all(AppPadding.scaffold),
          child: Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            spacing: widget.spacing ?? AppSpacing.s24,
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
      ),
    );
  }
}
