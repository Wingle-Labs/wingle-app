import 'package:flutter/material.dart';
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

  /// 생성자
  const DefaultScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colors;

    return Scaffold(
      backgroundColor: color.backgroundNormal,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: .centerFloat,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
