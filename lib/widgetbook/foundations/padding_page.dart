import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 위젯북에서 AppPadding을 확인할 수 있는 페이지
class PaddingPage extends StatelessWidget {
  /// 생성자
  const PaddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paddings = <_PaddingExample>[
      _PaddingExample(
        name: 'horizontal',
        padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      ),
      _PaddingExample(
        name: 'vertical',
        padding: EdgeInsets.symmetric(vertical: AppPadding.vertical),
      ),
      _PaddingExample(
        name: 'btnVertical',
        padding: EdgeInsets.symmetric(vertical: AppPadding.btnVertical),
      ),
      _PaddingExample(
        name: 'btnHorizontal',
        padding: EdgeInsets.symmetric(horizontal: AppPadding.btnHorizontal),
      ),
      _PaddingExample(
        name: 'scaffold',
        padding: EdgeInsets.all(AppPadding.scaffold),
      ),
      _PaddingExample(name: 'card', padding: EdgeInsets.all(AppPadding.card)),
      _PaddingExample(
        name: 'textfield',
        padding: EdgeInsets.all(AppPadding.textfield),
      ),
      _PaddingExample(
        name: 'textfieldSuffix',
        padding: EdgeInsets.only(right: AppPadding.textfieldSuffix),
      ),
      _PaddingExample(
        name: 'listTop',
        padding: EdgeInsets.only(top: AppPadding.listTop),
      ),
      _PaddingExample(
        name: 'listBottom',
        padding: EdgeInsets.only(bottom: AppPadding.listBottom),
      ),
      _PaddingExample(
        name: 'agreementItemLeft',
        padding: EdgeInsets.all(AppPadding.agreementItemLeft),
      ),
      _PaddingExample(
        name: 'agreementItemRight',
        padding: EdgeInsets.all(AppPadding.agreementItemRight),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('AppPadding Widgetbook Page')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: paddings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final ex = paddings[index];
          return _buildPaddingExample(ex.name, ex.padding);
        },
      ),
    );
  }

  /// Builds a visual example for a given padding.
  Widget _buildPaddingExample(String name, EdgeInsets padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AppPadding.$name',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: padding,
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.blue.shade200,
              alignment: Alignment.centerLeft,
              child: Text(
                'padding: $padding',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaddingExample {
  final String name;
  final EdgeInsets padding;
  const _PaddingExample({required this.name, required this.padding});
}
