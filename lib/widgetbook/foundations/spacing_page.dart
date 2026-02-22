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
      'xxs': AppSpacing.xxs,
      'textVerticalInternal': AppSpacing.textVerticalInternal,
      'xs': AppSpacing.xs,
      'sm': AppSpacing.sm,
      'md': AppSpacing.md,
      'lg': AppSpacing.lg,
      'xl': AppSpacing.xl,
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
            spacing: AppSpacing.md,
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
                    margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
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
