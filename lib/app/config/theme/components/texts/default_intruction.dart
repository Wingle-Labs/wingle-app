import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 설명 텍스트
class DefaultInstruction extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = context.typography.title;
    return Padding(
      padding: padding,
      child: DefaultText(
        text,
        style: titleStyle,
        textAlign: textAlign,
        policy: policy,
      ),
    );
  }
}
