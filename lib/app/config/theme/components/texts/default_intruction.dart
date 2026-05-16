import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_page_header.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';

/// 기본 설명 텍스트
class DefaultInstruction extends StatelessWidget {
  /// localization 키
  final String text;

  /// 텍스트 정렬
  final TextAlign textAlign;

  /// padding
  final EdgeInsets padding;

  /// 텍스트 정책
  final TextScalePolicy policy;

  /// 생성자
  const DefaultInstruction(
    this.text, {
    super.key,
    this.textAlign = .left,
    this.padding = const EdgeInsets.symmetric(vertical: AppPadding.vertical),
    this.policy = .cappedLarge,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultPageHeader(
      title: text,
      padding: padding,
      titleTextAlign: textAlign,
      titlePolicy: policy,
    );
  }
}
