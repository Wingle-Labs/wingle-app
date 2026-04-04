import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

/// 약관 동의 리스트 모델
class AgreementListState {
  /// 약관 동의 항목 리스트
  final List<AgreementItemModel> items;

  /// 제출 중인지 여부
  final bool isSubmitting;

  /// 생성자
  const AgreementListState({required this.items, this.isSubmitting = false});

  /// 모든 항목이 체크되어 있는지 확인
  bool get isAllChecked => items.every((e) => e.isChecked);

  /// 필수 항목이 모두 체크되어 있는지 확인
  bool get isRequiredChecked =>
      items.where((e) => e.isRequired).every((e) => e.isChecked);

  /// 복사 메서드
  AgreementListState copyWith({
    List<AgreementItemModel>? items,
    bool? isSubmitting,
  }) {
    return AgreementListState(
      items: items ?? this.items,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
