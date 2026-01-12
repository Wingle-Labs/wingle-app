import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Carousel, ListView 등에서 현재 인덱스를 표시하는 컴포넌트
class Indicator extends StatelessWidget {
  /// 현재 인덱스
  final int currentIndex;

  /// 전체 길이
  final int length;

  /// const 생성자
  const Indicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.xs,
        children: List.generate(length, (index) {
          return Container(
            width: AppContainerSize.indicator,
            height: AppContainerSize.indicator,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // TODO: 정확한 컬러 토큰 적용
              color: colorScheme.primary.withValues(
                alpha: currentIndex == index ? 1 : 0.3,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
