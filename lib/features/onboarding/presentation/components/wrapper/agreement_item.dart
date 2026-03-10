import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/buttons/default_checkbox.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 약관 동의 화면에서 사용하는 동의 항목 컴포넌트
class AgreementItem extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// 버튼 내부 텍스트
  final String title;

  /// 본문
  final String? content;

  /// 생성자
  const AgreementItem({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.isDisabled = false,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final disabledColor = colors.interactionDisable;
    return TextScaleWrapper(
      policy: .cappedMedium,
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: AppPadding.agreementItemLeft,
          right: AppPadding.agreementItemRight,
        ),
        leading: DefaultCheckbox(
          isChecked: isChecked,
          isDisabled: isDisabled,
          onChanged: onChanged,
        ),
        title: Text(title, style: typography.buttonMedium),
        trailing: content != null
            ? IconButton(
                padding: .zero,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: isDisabled ? disabledColor : colors.textNeutral,
                ),
                onPressed: () {},
              )
            : null,
        onTap: () {
          if (isDisabled) return;
          onChanged?.call(!isChecked);
        },
        shape: RoundedRectangleBorder(borderRadius: AppRadius.iosStyleRadius),
      ),
    );
  }
}
