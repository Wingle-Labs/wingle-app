import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 텍스트 스타일을 확인할 수 있는 페이지
class TypographyPage extends StatelessWidget {
  /// 생성자
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    final systemScale = context.knobs.double.slider(
      label: 'System Text Scale',
      min: 1.0,
      max: 2.0,
      divisions: 10,
      initialValue: 1.0,
    );

    final policy = context.knobs.object.dropdown<TextScalePolicy>(
      label: 'TextScalePolicy',
      options: TextScalePolicy.values,
      initialOption: TextScalePolicy.system,
    );

    return TextScaleWrapper(
      policy: policy,
      scale: systemScale,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(AppPadding.card),
          children: [
            _TypographySection(name: 'display', style: typography.display),
            _TypographySection(name: 'title', style: typography.title),
            _TypographySection(name: 'subTitle', style: typography.subtitle),
            _TypographySection(name: 'main', style: typography.main),
            _TypographySection(name: 'mainSub', style: typography.mainSub),
            _TypographySection(name: 'body', style: typography.body),
            _TypographySection(name: 'button', style: typography.buttonLarge),
            _TypographySection(
              name: 'buttonSmall',
              style: typography.buttonSmall,
            ),
            _TypographySection(
              name: 'chipButton',
              style: typography.chipButton,
            ),
            _TypographySection(name: 'chip', style: typography.chip),
          ],
        ),
      ),
    );
  }
}

class _TypographySection extends StatelessWidget {
  final String name;
  final TextStyle style;

  const _TypographySection({required this.name, required this.style});

  @override
  Widget build(BuildContext context) {
    final maxLines = context.knobs.int.slider(
      label: 'Max Lines',
      min: 1,
      max: 3,
      divisions: 2,
      initialValue: 2,
    );

    final overflow = context.knobs.object.dropdown(
      label: 'Overflow',
      options: TextOverflow.values,
    );

    final textAlign = context.knobs.object.dropdown(
      label: 'Text Align',
      options: TextAlign.values,
    );

    return Container(
      padding: const EdgeInsets.only(bottom: AppPadding.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: AppFontSize.caption,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'size: ${style.fontSize} | weight: ${style.fontWeight}',
                style: const TextStyle(fontSize: AppFontSize.caption),
              ),
              Text(
                'height: ${style.height} | letterSpacing: ${style.letterSpacing}',
                style: const TextStyle(fontSize: AppFontSize.caption),
              ),
              Text(
                'font: ${style.fontFamily}',
                style: const TextStyle(fontSize: AppFontSize.caption),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'The quick brown fox jumps over the lazy dog.',
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          ),
          Text(
            '가나다라마바사 1234567890',
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          ),
          const SizedBox(height: AppPadding.card),
          const Divider(),
        ],
      ),
    );
  }
}
