import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_list_state.dart';
import 'package:wingle/features/onboarding/presentation/providers/term_repository_provider.dart';

part 'agreement_list_provider.g.dart';

/// Riverpod Notifier
@riverpod
class AgreementList extends _$AgreementList {
  @override
  AgreementListState build() {
    loadTerms();
    return AgreementListState(items: []);
  }

  /// 약관 목록을 로드한다.
  Future<void> loadTerms() async {
    final repo = ref.read(termRepositoryProvider);
    final terms = await repo.fetchTerms();

    state = state.copyWith(items: terms);
  }

  /// 약관 동의 항목 리스트 설정
  void setItems(List<AgreementItemModel> items) {
    state = state.copyWith(items: items);
  }

  /// 모든 항목 체크 토글
  void toggleAll(bool value) {
    final updated = state.items
        .map((e) => e.copyWith(isChecked: value))
        .toList();

    state = state.copyWith(items: updated);
  }

  /// 특정 항목 체크 토글
  void toggleItem(int index, bool value) {
    final updated = [...state.items];
    updated[index] = updated[index].copyWith(isChecked: value);

    state = state.copyWith(items: updated);
  }
}
