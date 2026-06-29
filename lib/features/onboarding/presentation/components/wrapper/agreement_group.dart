import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/constants/padding.dart';
import 'package:wingle/app/config/theme/constants/spacing.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/agreement_item.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_term_labels.dart';
import 'package:wingle/features/onboarding/presentation/providers/agreement_list_provider.dart';

/// 동의 체크박스 및 텍스트
class AgreementGroup extends ConsumerWidget {
  /// 생성자
  const AgreementGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncModel = ref.watch(agreementListProvider);
    final notifier = ref.read(agreementListProvider.notifier);

    return asyncModel.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (model) {
        final items = model.items;
        final requiredBadge = 'onboarding.agreement.group.requiredBadge'.tr();
        final optionalBadge = 'onboarding.agreement.group.optionalBadge'.tr();
        final sortedIndexes = List<int>.generate(items.length, (index) => index)
          ..sort((a, b) {
            final left = AgreementTermLabels.sortWeight(items[a].type);
            final right = AgreementTermLabels.sortWeight(items[b].type);
            if (left != right) return left.compareTo(right);
            return a.compareTo(b);
          });

        final termWidgets = <Widget>[];
        for (final index in sortedIndexes) {
          if (termWidgets.isNotEmpty) {
            termWidgets.add(const SizedBox(height: AppSpacing.s12));
          }

          final item = items[index];
          termWidgets.add(
            AgreementItem(
              title: item.title,
              badgeLabel: item.isRequired ? requiredBadge : optionalBadge,
              isChecked: item.isChecked,
              onChanged: (value) => notifier.toggleItem(index, value),
              isDisabled: model.isSubmitting,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppPadding.agreementControlSectionTop,
                bottom: AppPadding.agreementControlSectionBottom,
              ),
              child: AgreementItem(
                title: 'onboarding.agreement.group.all',
                isChecked: model.isAllChecked,
                isPartial: !model.isAllChecked && items.any((e) => e.isChecked),
                isDisabled: false,
                variant: AgreementItemVariant.contained,
                onChanged: notifier.toggleAll,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: AppPadding.agreementLineSectionTop,
                bottom: AppPadding.agreementLineSectionBottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: termWidgets,
              ),
            ),
          ],
        );
      },
    );
  }
}
