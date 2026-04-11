import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';

import '../../app/config/theme/constants/spacing.dart';

/// Widgetbook에서 Spacing을 확인할 수 있는 페이지
class SpacingPage extends StatelessWidget {
  /// 생성자
  const SpacingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacingValues = <String, double>{
      'buttonInternal': AppSpacing.buttonInternal,
      's8': AppSpacing.s8,
      's12': AppSpacing.s12,
      's16': AppSpacing.s16,
      's24': AppSpacing.s24,
      's32': AppSpacing.s32,
      's48': AppSpacing.s48,
      's52': AppSpacing.s52,
      's56': AppSpacing.s56,
      's60': AppSpacing.s60,
      's64': AppSpacing.s64,
      'textVerticalInternal': AppSpacing.textVerticalInternal,
      'bottom': AppSpacing.bottom,
      'inputFieldLabelInternal': AppSpacing.inputFieldLabelInternal,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('AppSpacing Visualization')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.scaffold),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s24,
            children: spacingValues.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key}: ${entry.value.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: AppFontSize.title,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    width: double.infinity,
                    height: entry.value,
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
