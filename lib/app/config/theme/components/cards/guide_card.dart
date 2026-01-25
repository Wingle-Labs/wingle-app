import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_intruction.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';

/// 현재 페이지의 안내 문구를 표시하는 카드
class GuideCard extends StatelessWidget {
  /// 안내 문구 제목
  final String title;

  /// 안내 문구
  final String message;

  /// 요소 정렬
  final CrossAxisAlignment crossAxisAlignment;

  /// 글자 정렬
  final TextAlign textAlign;

  /// 요소 간 간격
  final double spacing;

  /// 제목 텍스트 정책
  final TextScalePolicy titlePolicy;

  /// 메시지 텍스트 정책
  final TextScalePolicy messagePolicy;

  /// 생성자
  const GuideCard({
    super.key,
    required this.title,
    required this.message,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign = TextAlign.start,
    this.spacing = AppSpacing.textVerticalInternal,
    this.titlePolicy = .cappedMedium,
    this.messagePolicy = .cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: AppPadding.vertical, bottom: AppPadding.card),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: crossAxisAlignment,
        spacing: AppSpacing.textVerticalInternal,
        children: [
          DefaultInstruction(
            title,
            padding: .zero,
            textAlign: textAlign,
            policy: titlePolicy,
          ),
          DefaultText(message, policy: messagePolicy, textAlign: textAlign),
        ],
      ),
    );
  }
}
