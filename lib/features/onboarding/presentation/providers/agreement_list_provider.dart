import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_list_state.dart';
import 'package:wingle/features/onboarding/presentation/providers/term_repository_provider.dart';

part 'agreement_list_provider.g.dart';

/// Riverpod Notifier
@Riverpod(keepAlive: true)
class AgreementList extends _$AgreementList {
  @override
  Future<AgreementListState> build() async {
    final repo = ref.read(termRepositoryProvider);
    final terms = await repo.fetchTerms();
    return AgreementListState(items: terms);
  }

  /// 약관 동의 항목 리스트 설정
  void setItems(List<AgreementItemModel> items) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(items: items));
  }

  /// 모든 항목 체크 토글
  void toggleAll(bool value) {
    final current = state.value;
    if (current == null) return;

    final updated = current.items
        .map((e) => e.copyWith(isChecked: value))
        .toList();

    state = AsyncData(current.copyWith(items: updated));
  }

  /// 특정 항목 체크 토글
  void toggleItem(int index, bool value) {
    final current = state.value;
    if (current == null) return;
    if (index < 0 || index >= current.items.length) return;

    final updated = [...current.items];
    updated[index] = updated[index].copyWith(isChecked: value);

    state = AsyncData(current.copyWith(items: updated));
  }

  /// 약관 동의 등록
  Future<bool> submitAgreements() async {
    final repo = ref.read(termRepositoryProvider);
    final uuid = ref.read(deviceUuidProvider);

    final current = state.value;
    if (current == null) return false;
    if (!current.isRequiredChecked) return false;

    state = AsyncData(current.copyWith(isSubmitting: true));

    final result = await AsyncValue.guard(() async {
      return await repo.submitAgreements(uuid: uuid, agreements: current.items);
    });

    final latest = state.value;
    if (latest != null) {
      state = AsyncData(latest.copyWith(isSubmitting: false));
    }

    return result.value ?? false;
  }
}
