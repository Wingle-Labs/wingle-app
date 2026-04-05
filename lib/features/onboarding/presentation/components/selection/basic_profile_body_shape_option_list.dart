import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/basic_profile_body_shape_option_card.dart';

/// 기본 프로필 체형 선택 카드 목록.
class BasicProfileBodyShapeOptionList extends StatelessWidget {
  /// 옵션 목록
  final List<BodyShapeOption> options;

  /// 선택된 코드
  final String? selectedCode;

  /// 선택 콜백
  final ValueChanged<String> onSelected;

  /// 목록 상단 여백
  final EdgeInsetsGeometry padding;

  /// 카드 간 간격
  final double spacing;

  /// 생성자
  const BasicProfileBodyShapeOptionList({
    super.key,
    required this.options,
    required this.selectedCode,
    required this.onSelected,
    this.padding = const EdgeInsets.only(top: AppSpacing.md),
    this.spacing = AppSpacing.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing,
        children: [
          for (var index = 0; index < options.length; index++) ...[
            BasicProfileBodyShapeOptionCard(
              selected: selectedCode == options[index].code,
              label: options[index].label,
              onTap: () => onSelected(options[index].code),
            ),
          ],
        ],
      ),
    );
  }
}
