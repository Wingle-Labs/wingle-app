import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/weight.dart';
import 'package:wingle/common/extensions/context_colors.dart';

/// 앱 전역에서 사용하는 기본 체크박스 컴포넌트
class DefaultCheckbox extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// semantic label
  final String? semanticLabel;

  /// 텍스트 스케일 정책
  final TextScalePolicy scalePolicy;

  /// 생성자
  const DefaultCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.isDisabled = false,
    this.semanticLabel,
    this.scalePolicy = TextScalePolicy.cappedMedium,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final clampedScale = scalePolicy.getScaleFactor(textScale);
    final size = AppIconSize.large * clampedScale;
    return InkWell(
      onTap: isDisabled ? null : () => onChanged?.call(!isChecked),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
          color: isChecked ? colors.primaryNormal : colors.interactionDisable,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            color: isChecked
                ? colors.componentCheckboxIconEnabled
                : colors.componentCheckboxIconDisabled,
            size: size,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
    );
  }
}
