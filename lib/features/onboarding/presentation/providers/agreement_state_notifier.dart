import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/domain/repositories/term_repository.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';
import 'package:wingle/features/onboarding/presentation/providers/term_repository_provider.dart';

part 'agreement_state_notifier.g.dart';

/// 약관 동의 화면의 상태를 관리하는 AsyncNotifier.
///
/// 책임:
/// - 서버에서 약관 목록을 로드한다.
/// - 개별 동의 상태를 제어한다.
/// - 전체 동의 상태를 제어한다.
/// - 필수 약관 충족 여부를 검증한다.
///
/// 상태 원칙:
/// - 단일 상태 소스는 [List<AgreementItem>]이다.
/// - "전체 동의"는 별도 bool로 저장하지 않는다.
/// - 파생 상태는 계산 기반으로 처리한다.
@riverpod
class AgreementStateNotifier extends _$AgreementStateNotifier {
  late final TermRepository _repository;

  @override
  Future<List<AgreementItem>> build() async {
    _repository = ref.read(termRepositoryProvider);
    return _repository.fetchTerms();
  }

  // ! 개별 동의 토글

  /// 특정 약관의 체크 상태를 반전시킨다.
  ///
  /// [id] : 변경할 약관의 식별자
  void toggleAgreement(int id) {
    final current = state.value;
    if (current == null) return;

    final updated = current.map((item) {
      if (item.id == id) {
        return item.copyWith(isChecked: !item.isChecked);
      }
      return item;
    }).toList();

    state = AsyncData(updated);
  }

  // ! 전체 동의 처리

  /// 모든 약관의 체크 상태를 일괄 변경한다.
  ///
  /// [isChecked] : 전체 적용할 상태
  void toggleAll(bool isChecked) {
    final current = state.value;
    if (current == null) return;

    final updated = current
        .map((item) => item.copyWith(isChecked: isChecked))
        .toList();

    state = AsyncData(updated);
  }

  //  ! 파생 상태

  /// 모든 약관이 체크되었는지 반환한다.
  bool isAllChecked() {
    return state.value?.every((item) => item.isChecked) ?? false;
  }

  // ! 필수 약관이 모두 체크되었는지 반환한다.

  /// 다음 버튼 활성 조건에 사용된다.
  bool isRequiredSatisfied() {
    final current = state.value;
    if (current == null) return false;

    return current
        .where((item) => item.isRequired)
        .every((item) => item.isChecked);
  }
}
