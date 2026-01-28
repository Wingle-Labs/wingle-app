import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// 시스템 텍스트 크기 정책에 따른 UI 내 텍스트 크기 조정 Wrapper
class TextScaleWrapper extends StatelessWidget {
  /// 내부 UI
  final Widget child;

  /// 텍스트 크기 정책
  final TextScalePolicy policy;

  /// const 생성자
  const TextScaleWrapper({
    required this.child,
    this.policy = TextScalePolicy.system,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final scale = policy.getScaleFactor(mediaQuery.textScaler.scale(1.0));

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}
