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
    final model = ref.watch(agreementListProvider);
    final notifier = ref.read(agreementListProvider.notifier);

    final items = model.items;

    return Column(
      children: [
        AgreementItem(
          title: "전체 동의",
          content: null,
          isChecked: model.isAllChecked,
          isDisabled: false,
          onChanged: notifier.toggleAll,
        ),

        ...List.generate(items.length, (index) {
          final item = items[index];

          return AgreementItem(
            title: item.isRequired ? '${item.title} (필수)' : item.title,
            content: item.content,
            isChecked: item.isChecked,
            onChanged: (value) => notifier.toggleItem(index, value),
          );
        }),
      ],
    );
  }
}
