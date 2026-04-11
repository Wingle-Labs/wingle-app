import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
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
      padding: .all(AppPadding.indicator),
      child: Row(
        mainAxisSize: .min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.s8,
        children: List.generate(length, (index) {
          return Container(
            width: AppContainerSize.indicator,
            height: AppContainerSize.indicator,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? colorScheme.primaryNormal
                  : colorScheme.interactionDisable,
            ),
          );
        }).toList(),
      ),
    );
  }
}
