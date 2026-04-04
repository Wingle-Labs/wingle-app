import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 텍스트 컴포넌트
class DefaultText extends StatelessWidget {
  /// 텍스트 내용
  final String text;

  /// 텍스트 스케일 정책
  final TextScalePolicy policy;

  /// 텍스트 스타일
  final TextStyle? style;

  /// 텍스트 정렬
  final TextAlign textAlign;

  /// 텍스트 색상
  final Color? color;

  /// 번역 키 여부
  final bool isTranslationKey;

  /// 생성자
  const DefaultText(
    this.text, {
    super.key,
    this.policy = TextScalePolicy.system,
    this.style,
    this.textAlign = TextAlign.left,
    this.color,
    this.isTranslationKey = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = context.typography.body;
    return TextScaleWrapper(
      policy: policy,
      child: Text(
        isTranslationKey ? text.tr() : text,
        style: (style ?? body).copyWith(color: color),
        textAlign: textAlign,
      ),
    );
  }
}
