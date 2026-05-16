import 'package:flutter/material.dart';

/// Widgetbook에서 라우팅만 맞추기 위한 플레이스홀더 페이지
class WidgetbookPlaceholderPage extends StatelessWidget {
  /// 화면 제목
  final String title;

  /// 설명 텍스트
  final String description;

  /// 생성자
  const WidgetbookPlaceholderPage({
    super.key,
    required this.title,
    this.description = '이 화면은 Widgetbook 전용 플레이스홀더입니다.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(description, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
