import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 페이지 상단 제목/부제목 블록
///
/// 제목과 부제목을 하나의 padding으로 감싸고,
/// title/subtitle의 스타일과 정렬을 기본값으로 제공한다.
class DefaultPageHeader extends StatelessWidget {
  /// 제목 localization key
  final String title;

  /// 부제목 localization key
  final String? subtitle;

  /// 전체 padding
  final EdgeInsets padding;

  /// 제목과 부제목 사이 간격
  final double spacing;

  /// 제목 정렬
  final TextAlign titleTextAlign;

  /// 부제목 정렬
  final TextAlign? subtitleTextAlign;

  /// 제목 스타일
  final TextStyle? titleStyle;

  /// 부제목 스타일
  final TextStyle? subtitleStyle;

  /// 부제목 색상
  final Color? subtitleColor;

  /// 제목 텍스트 스케일 정책
  final TextScalePolicy titlePolicy;

  /// 부제목 텍스트 스케일 정책
  final TextScalePolicy subtitlePolicy;

  /// 제목이 번역 키인지 여부
  final bool isTitleTranslationKey;

  /// 부제목이 번역 키인지 여부
  final bool isSubtitleTranslationKey;

  /// 생성자
  const DefaultPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.padding = const EdgeInsets.symmetric(vertical: AppPadding.vertical),
    this.spacing = AppSpacing.xs,
    this.titleTextAlign = TextAlign.left,
    this.subtitleTextAlign,
    this.titleStyle,
    this.subtitleStyle,
    this.subtitleColor,
    this.titlePolicy = TextScalePolicy.cappedLarge,
    this.subtitlePolicy = TextScalePolicy.cappedLarge,
    this.isTitleTranslationKey = true,
    this.isSubtitleTranslationKey = true,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final resolvedSubtitleAlign = subtitleTextAlign ?? titleTextAlign;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultText(
            title,
            style: titleStyle ?? typography.title,
            textAlign: titleTextAlign,
            policy: titlePolicy,
            isTranslationKey: isTitleTranslationKey,
          ),
          if (subtitle != null) ...[
            SizedBox(height: spacing),
            DefaultText(
              subtitle!,
              style: subtitleStyle ?? typography.bodySub,
              textAlign: resolvedSubtitleAlign,
              color: subtitleColor,
              policy: subtitlePolicy,
              isTranslationKey: isSubtitleTranslationKey,
            ),
          ],
        ],
      ),
    );
  }
}
