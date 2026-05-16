import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 기본 구분선 굵기 종류
enum DefaultDividerVariant {
  /// 1px 구분선
  normal,

  /// 12px 구분 영역
  thick,
}

/// 앱 전역에서 사용하는 기본 구분선 위젯
class DefaultDivider extends StatelessWidget {
  /// 굵기 종류
  final DefaultDividerVariant variant;

  /// 세로 여부
  final bool vertical;

  /// 주축 길이
  final double? length;

  /// 굵기 직접 지정
  final double? thickness;

  /// 색상
  final Color? color;

  /// 생성자
  const DefaultDivider({
    super.key,
    this.variant = DefaultDividerVariant.normal,
    this.vertical = false,
    this.length,
    this.thickness,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? context.colors.strokeStructuralDivider;
    final resolvedThickness = thickness ?? _resolveThickness();
    final resolvedLength =
        length ??
        (vertical
            ? AppContainerSize.dividerVerticalLength
            : AppContainerSize.dividerHorizontalLength);

    return SizedBox(
      width: vertical ? resolvedThickness : resolvedLength,
      height: vertical ? resolvedLength : resolvedThickness,
      child: ColoredBox(color: dividerColor),
    );
  }

  double _resolveThickness() {
    return switch (variant) {
      .normal => AppLineWidth.dividerNormal,
      .thick => AppLineWidth.dividerThick,
    };
  }
}
