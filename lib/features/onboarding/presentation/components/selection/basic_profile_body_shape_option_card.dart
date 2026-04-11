import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 기본 프로필 체형 선택 카드.
class BasicProfileBodyShapeOptionCard extends StatelessWidget {
  /// 선택된 상태인지 여부
  final bool selected;

  /// 라벨
  final String label;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 생성자
  const BasicProfileBodyShapeOptionCard({
    super.key,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final backgroundColor = selected
        ? colors.componentSecondaryFilledButtonEnabled
        : colors.strokeStructuralBorder;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.iosStyle),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.iosStyle),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: AppContainerSize.cardMinHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.cardHorizontal,
            vertical: AppPadding.vertical,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.iosStyle),
          ),
          child: Row(
            children: [
              _BodyShapeRadio(selected: selected),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DefaultText(
                  label,
                  style: typography.bodySub.copyWith(
                    color: selected
                        ? colors.textNormal
                        : colors.textAlternative,
                  ),
                  isTranslationKey: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyShapeRadio extends StatelessWidget {
  final bool selected;

  const _BodyShapeRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: AppIconSize.sm,
      height: AppIconSize.sm,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colors.textNormal : colors.interactionDisable,
            width: AppLineWidth.radioButtonBorder,
          ),
        ),
        child: Center(
          child: Container(
            width: selected ? AppIconSize.radioInner : 0,
            height: selected ? AppIconSize.radioInner : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? colors.textNormal : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
