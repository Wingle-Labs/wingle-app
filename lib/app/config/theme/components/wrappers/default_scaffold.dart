import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 Scaffold 위젯
class DefaultScaffold extends StatelessWidget {
  /// 앱바
  final PreferredSizeWidget? appBar;

  /// 바디
  final Widget? body;

  /// 플로팅 액션 버튼
  final Widget? floatingActionButton;

  /// 하단 네비게이션 바
  final Widget? bottomNavigationBar;

  /// CanPop
  final bool? canPop;

  /// onPop
  final Function(bool, dynamic)? onPop;

  /// Padding
  final EdgeInsets? padding;

  /// 생성자
  const DefaultScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.canPop,
    this.onPop,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colors;

    return PopScope(
      canPop: canPop ?? true,
      onPopInvokedWithResult: onPop,
      child: Scaffold(
        backgroundColor: color.backgroundNormal,
        appBar: appBar,
        body: Padding(
          padding: padding ?? EdgeInsets.all(AppPadding.scaffold),
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: .centerFloat,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
