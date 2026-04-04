import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용하는 기본 세로 구분선 위젯
class DefaultVerticalDivider extends StatelessWidget {
  /// 높이
  final double height;

  /// 너비
  final double width;

  /// 색상
  final Color? color;

  /// 매칭되는 글자 크기
  final double? fontSize;

  ///  TextScalePolicy
  final TextScalePolicy textScalePolicy;

  /// 생성자
  const DefaultVerticalDivider({
    super.key,
    this.height = AppContainerSize.verticalDividerHeight,
    this.width = 1,
    this.color,
    this.fontSize,
    this.textScalePolicy = TextScalePolicy.fixed,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = context.colors.strokeStructuralDivider;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final cappedTextScale = textScalePolicy.getScaleFactor(textScale);

    return Container(
      width: width,
      height:
          (fontSize != null ? (fontSize! * 0.9).toInt() : height) *
          cappedTextScale,
      color: color ?? defaultColor,
    );
  }
}
