import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// Pagination 표시 방식
enum PaginationVariant {
  /// 캐러셀 위치 표시용 원형 페이지네이션
  dot,

  /// 진행 단계 표시용 라인 페이지네이션
  line,
}

/// 순서와 단계를 표시하는 Pagination 컴포넌트
class Pagination extends StatelessWidget {
  /// 현재 인덱스. 0부터 시작합니다.
  final int currentIndex;

  /// 전체 개수
  final int length;

  /// 표시 방식
  final PaginationVariant variant;

  /// 요소 사이 간격
  final double spacing;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 생성자
  const Pagination({
    super.key,
    required this.currentIndex,
    required this.length,
    this.variant = PaginationVariant.dot,
    this.spacing = AppSpacing.s8,
    this.activeColor,
    this.inactiveColor,
  }) : assert(length > 0, 'length는 1 이상이어야 합니다.');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedCurrentIndex = currentIndex.clamp(0, length - 1).toInt();
    final resolvedActiveColor = activeColor ?? colors.primaryNormal;
    final resolvedInactiveColor = inactiveColor ?? colors.interactionDisable;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacing,
      children: List.generate(length, (index) {
        final isActive = index == resolvedCurrentIndex;

        return switch (variant) {
          PaginationVariant.dot => _DotPageIndicator(
            color: isActive ? resolvedActiveColor : resolvedInactiveColor,
          ),
          PaginationVariant.line => _LinePageIndicator(
            color: isActive ? resolvedActiveColor : resolvedInactiveColor,
          ),
        };
      }),
    );
  }
}

class _DotPageIndicator extends StatelessWidget {
  final Color color;

  const _DotPageIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppContainerSize.paginationDot,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _LinePageIndicator extends StatelessWidget {
  final Color color;

  const _LinePageIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppContainerSize.paginationLine),
      child: SizedBox(
        width: AppContainerSize.paginationLineWidth,
        height: AppContainerSize.paginationLine,
        child: ColoredBox(color: color),
      ),
    );
  }
}
