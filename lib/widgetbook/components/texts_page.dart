import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 텍스트 컴포넌트 프리뷰
class TextsPage extends StatelessWidget {
  /// 생성자
  const TextsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final policy = context.knobs.object.dropdown<TextScalePolicy>(
      label: 'Text Scale Policy',
      options: TextScalePolicy.values,
      initialOption: TextScalePolicy.system,
      labelBuilder: (policy) => policy.name,
    );
    final centered = context.knobs.object.dropdown<bool>(
      label: 'Centered',
      options: const [false, true],
      initialOption: false,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Texts', style: typography.title),
            const SizedBox(height: 8),
            Text(
              'DefaultText, DefaultInstruction, DefaultPageHeader, '
              'TextScaleWrapper',
              style: typography.bodySub.copyWith(color: colors.textAlternative),
            ),
            const SizedBox(height: 24),
            _TextPreview(
              title: 'DefaultText',
              child: DefaultText(
                '텍스트 스케일 정책과 번역 여부를 확인합니다.',
                isTranslationKey: false,
                style: typography.body,
                policy: policy,
                textAlign: centered ? TextAlign.center : TextAlign.left,
              ),
            ),
            _TextPreview(
              title: 'DefaultInstruction',
              child: DefaultInstruction(
                'onboarding.basicProfile.bodyShape.title',
                policy: policy,
                textAlign: centered ? TextAlign.center : TextAlign.left,
              ),
            ),
            _TextPreview(
              title: 'DefaultPageHeader',
              child: DefaultPageHeader(
                title: 'onboarding.basicProfile.nickname.title',
                subtitle: 'onboarding.basicProfile.nickname.subtitle',
                titlePolicy: policy,
                subtitlePolicy: policy,
                titleTextAlign: centered ? TextAlign.center : TextAlign.left,
                subtitleTextAlign: centered ? TextAlign.center : TextAlign.left,
              ),
            ),
            _TextPreview(
              title: 'TextScaleWrapper',
              child: TextScaleWrapper(
                policy: policy,
                child: Text(
                  'MediaQuery textScaler를 정책별로 감싸는 래퍼입니다.',
                  style: typography.body,
                  textAlign: centered ? TextAlign.center : TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextPreview extends StatelessWidget {
  final String title;
  final Widget child;

  const _TextPreview({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.backgroundNormal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.strokeStructuralBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.main),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
