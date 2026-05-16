import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 진행 단계 표시 바.
class StepIndicator extends StatelessWidget {
  /// 현재 단계(1부터 시작)
  final int currentStep;

  /// 총 단계 수
  final int totalSteps;

  /// 바 높이
  final double height;

  /// 바 사이 간격
  final double spacing;

  /// 전체 패딩
  final EdgeInsets padding;

  /// 활성 색상
  final Color? activeColor;

  /// 비활성 색상
  final Color? inactiveColor;

  /// 생성자
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = AppContainerSize.indicator,
    this.spacing = AppSpacing.s12,
    this.padding = const EdgeInsets.symmetric(horizontal: AppPadding.scaffold),
    this.activeColor,
    this.inactiveColor,
  }) : assert(totalSteps > 0, 'totalSteps는 1 이상이어야 합니다.');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedActiveColor = activeColor ?? colors.primaryNormal;
    final resolvedInactiveColor = inactiveColor ?? colors.interactionDisable;
    final int resolvedCurrentStep = currentStep.clamp(1, totalSteps).toInt();

    return Padding(
      padding: padding,
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isOdd) {
            return SizedBox(width: spacing);
          }

          final stepIndex = index ~/ 2 + 1;
          final isActive = stepIndex <= resolvedCurrentStep;

          return Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height),
              child: SizedBox(
                height: height,
                child: ColoredBox(
                  color: isActive ? resolvedActiveColor : resolvedInactiveColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
