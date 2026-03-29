import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/features/onboarding/presentation/components/wrapper/agreement_item.dart';
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
        final requiredSuffix = 'onboarding.agreement.group.requiredSuffix'.tr();

        return Column(
          children: [
            AgreementItem(
              title: 'onboarding.agreement.group.all',
              content: null,
              isChecked: model.isAllChecked,
              isDisabled: false,
              onChanged: notifier.toggleAll,
            ),
            ...List.generate(items.length, (index) {
              final item = items[index];

              return AgreementItem(
                title: item.isRequired
                    ? '${item.title} $requiredSuffix'
                    : item.title,
                content: item.content,
                isChecked: item.isChecked,
                onChanged: (value) => notifier.toggleItem(index, value),
                isDisabled: model.isSubmitting,
              );
            }),
          ],
        );
      },
    );
  }
}
