import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_policy.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 앱 전역에서 사용하는 체크박스가 포함된 리스트 버튼 컴포넌트
class DefaultListButton extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// 버튼 내부 텍스트
  final String label;

  /// 화살표 아이콘 여부
  final bool hasArrow;

  /// 생성자
  const DefaultListButton({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.isDisabled = false,
    required this.label,
    this.hasArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final disabledColor = colors.textDisabled;
    final surfaceDisabled = colors.surfaceDisabled;
    return TextScaleWrapper(
      policy: .cappedMedium,
      child: Theme(
        data: Theme.of(context).copyWith(
          disabledColor: disabledColor,
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
            ),
            fillColor: WidgetStatePropertyAll(
              isChecked ? colors.primary : surfaceDisabled,
            ),
          ),
        ),
        child: CheckboxListTile(
          checkboxScaleFactor:
              TextScalePolicy.cappedMedium.getScaleFactor(textScale) * 1.2,
          checkboxSemanticLabel: label,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppPadding.listButton,
            vertical: AppPadding.listButton,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
          activeColor: colors.primary,
          enabled: !isDisabled,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashRadius: 0,
          visualDensity: VisualDensity.compact,
          value: isChecked,
          onChanged: (value) {
            if (value == null) return;
            onChanged?.call(value);
          },
          secondary: hasArrow
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: isDisabled ? disabledColor : colors.primaryScale70,
                  applyTextScaling: true,
                )
              : null,
          title: DefaultText(
            label,
            style: typography.button,
            color: isDisabled ? disabledColor : colors.primary,
          ),
        ),
      ),
    );
  }
}
