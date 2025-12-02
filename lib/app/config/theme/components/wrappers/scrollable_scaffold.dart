import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 스크롤 가능한 Scaffold
class ScrollableScaffold extends ConsumerStatefulWidget {
  /// 제목
  final String title;

  /// 바디
  final List<Widget> body;

  /// FloatingActionButton
  final Widget? floatingActionButton;

  /// 생성자
  const ScrollableScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  ConsumerState<ScrollableScaffold> createState() => _ScrollableScaffoldState();
}

class _ScrollableScaffoldState extends ConsumerState<ScrollableScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title.tr())),
      body: SingleChildScrollView(
        padding: .all(AppPadding.scaffold),
        child: Column(crossAxisAlignment: .start, children: widget.body),
      ),
      floatingActionButtonLocation: .centerFloat,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
