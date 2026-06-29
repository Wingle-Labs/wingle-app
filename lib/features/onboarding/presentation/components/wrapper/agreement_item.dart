import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/badges/default_badge.dart';
import 'package:wingle/app/config/theme/components/texts/text_scale_wrapper.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 약관 항목 표시 타입.
enum AgreementItemVariant {
  /// 일반 라인형 항목.
  line,

  /// 전체 동의처럼 외곽선이 있는 항목.
  contained,
}

/// 약관 동의 화면에서 사용하는 동의 항목 컴포넌트
class AgreementItem extends StatelessWidget {
  /// 체크 여부
  final bool isChecked;

  /// 부분 체크 여부
  final bool isPartial;

  /// 체크 변경 콜백
  final Function(bool)? onChanged;

  /// 비활성화 여부
  final bool isDisabled;

  /// 버튼 내부 텍스트
  final String title;

  /// 항목 우측 배지 텍스트.
  final String? badgeLabel;

  /// 표시 타입.
  final AgreementItemVariant variant;

  /// 생성자
  const AgreementItem({
    super.key,
    required this.isChecked,
    this.isPartial = false,
    this.onChanged,
    this.isDisabled = false,
    required this.title,
    this.badgeLabel,
    this.variant = AgreementItemVariant.line,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final isTitleTranslationKey = title.contains('.');
    final content = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _AgreementCheckbox(
          isChecked: isChecked,
          isPartial: isPartial,
          isDisabled: isDisabled,
        ),
        const SizedBox(width: AppSpacing.s8),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            isTitleTranslationKey ? title.tr() : title,
            style: typography.main.copyWith(
              color: isDisabled
                  ? colors.textDisable
                  : isChecked
                  ? colors.primaryNormal
                  : colors.textNormal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (badgeLabel != null) ...[
          const SizedBox(width: AppSpacing.s8),
          DefaultBadge(
            text: badgeLabel!,
            size: DefaultBadgeSize.sm,
            type: DefaultBadgeType.gray,
          ),
        ],
      ],
    );

    return TextScaleWrapper(
      policy: .cappedMedium,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.iosStyleRadius,
          side: variant == AgreementItemVariant.contained
              ? BorderSide(
                  color: colors.strokeStructuralBorder,
                  width: AppLineWidth.dividerNormal,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(!isChecked),
          borderRadius: AppRadius.iosStyleRadius,
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (isDisabled) return null;
            if (states.contains(WidgetState.pressed)) {
              return colors.overlayPressed;
            }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.hovered)) {
              return colors.overlayInactive;
            }
            return null;
          }),
          child: SizedBox(
            height: variant == AgreementItemVariant.contained
                ? AppContainerSize.agreementControlHeight
                : AppContainerSize.agreementLineHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: variant == AgreementItemVariant.contained
                    ? AppPadding.agreementControlHorizontal
                    : AppPadding.agreementLineHorizontal,
              ),
              child: Align(alignment: Alignment.centerLeft, child: content),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  final bool isChecked;
  final bool isPartial;
  final bool isDisabled;

  const _AgreementCheckbox({
    required this.isChecked,
    required this.isPartial,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = isChecked || isPartial;
    final borderColor = isDisabled
        ? colors.strokeStructuralBorder
        : selected
        ? colors.primaryNormal
        : colors.textNormal;
    final fillColor = isDisabled
        ? colors.interactionDisable
        : selected
        ? colors.primaryNormal
        : colors.backgroundElevatedNormal;
    final iconData = isPartial ? Icons.remove_rounded : Icons.check_rounded;

    return SizedBox.square(
      dimension: AppIconSize.sm,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppRadius.checkboxRadius),
          border: Border.all(color: borderColor, width: AppLineWidth.outline),
        ),
        child: selected
            ? Icon(
                iconData,
                size: AppIconSize.sm,
                color: isDisabled
                    ? colors.componentCheckboxIconDisabled
                    : colors.componentCheckboxIconEnabled,
              )
            : null,
      ),
    );
  }
}
