import 'package:flutter/material.dart';
import 'package:wingle/widgetbook/foundations/color_palette.dart';
import 'package:wingle/widgetbook/foundations/color_semantic.dart';

/// 컬러 파운데이션을 확인할 수 있는 페이지
class ColorPage extends StatelessWidget {
  /// 생성자
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Color Foundation'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Palette'),
              Tab(text: 'Semantic'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ColorPalettePage(), ColorSemanticPage()],
        ),
      ),
    );
  }
}
