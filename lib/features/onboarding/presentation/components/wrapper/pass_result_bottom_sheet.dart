import 'package:flutter/material.dart';
import 'package:wingle/app/config/theme/components/texts/default_text.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/radius.dart';
import 'package:wingle/app/config/theme/constants/size.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/common/extensions/context_colors.dart';
import 'package:wingle/common/extensions/context_typography.dart';

/// 본인인증 결과 BottomSheet
class PassResultBottomSheet extends StatelessWidget {
  /// 이름
  final String name;

  /// 성별
  final String gender;

  /// 생년월일
  final String birth;

  /// 연락처
  final String phone;

  ///
  const PassResultBottomSheet({
    super.key,
    required this.name,
    required this.gender,
    required this.birth,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final typo = context.typography;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .start,
      children: [
        /// title
        DefaultText(
          '본인 정보가 맞는 지 확인해주세요',
          style: typo.subtitle,
          textAlign: .left,
        ),

        const SizedBox(height: AppPadding.bottomSheet),

        /// info card
        _InfoCard(name: name, gender: gender, birth: birth, phone: phone),

        const SizedBox(height: AppPadding.bottomSheet),
      ],
    );
  }
}

/// 정보 카드
class _InfoCard extends StatelessWidget {
  final String name;
  final String gender;
  final String birth;
  final String phone;

  const _InfoCard({
    required this.name,
    required this.gender,
    required this.birth,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppPadding.infoCard),
      decoration: BoxDecoration(
        color: color.componentInfoCardBackground,
        borderRadius: AppRadius.iosStyleRadius,
      ),
      child: Column(
        spacing: AppSpacing.xs,
        children: [
          _InfoRow(label: '이름', value: name),
          _InfoRow(label: '성별', value: gender),
          _InfoRow(label: '생년월일', value: birth),
          _InfoRow(label: '연락처', value: phone),
        ],
      ),
    );
  }
}

/// 한 줄 row
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = context.colors;
    final typo = context.typography;
    return Row(
      spacing: AppSpacing.xxs,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: AppContainerSize.tagMinWidth,
            minHeight: AppContainerSize.tagMinHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.tagHorizontal,
            vertical: AppPadding.tagVertical,
          ),
          decoration: BoxDecoration(
            color: color.interactionDisable,
            borderRadius: BorderRadius.circular(AppRadius.tagRadius),
          ),
          alignment: .center,
          child: DefaultText(label, style: typo.tag),
        ),
        Expanded(child: DefaultText(value, style: typo.bodySub)),
      ],
    );
  }
}
