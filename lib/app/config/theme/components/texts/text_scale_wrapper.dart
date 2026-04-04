import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';

/// 시스템 텍스트 크기 정책에 따른 UI 내 텍스트 크기 조정 Wrapper
class TextScaleWrapper extends StatelessWidget {
  /// 내부 UI
  final Widget child;

  /// 텍스트 크기 정책
  final TextScalePolicy policy;

  /// 스케일 레벨
  final double scale;

  /// const 생성자
  const TextScaleWrapper({
    required this.child,
    this.policy = TextScalePolicy.system,
    super.key,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final scale = policy.getScaleFactor(
      mediaQuery.textScaler.scale(this.scale),
    );

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}
