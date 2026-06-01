const Object _undefined = Object();

/// 상세 프로필 입력 상태.
class ProfileDetailsModel {
  /// 첫 번째 MBTI 축: E/I.
  final String? energy;

  /// 두 번째 MBTI 축: N/S.
  final String? perception;

  /// 세 번째 MBTI 축: F/T.
  final String? decision;

  /// 네 번째 MBTI 축: P/J.
  final String? lifestyle;

  /// 자기소개.
  final String selfIntroduction;

  /// 제출/저장 중 여부.
  final bool isSubmitting;

  /// 제출/저장 실패 메시지.
  final String? submitErrorMessage;

  /// 생성자.
  const ProfileDetailsModel({
    this.energy,
    this.perception,
    this.decision,
    this.lifestyle,
    this.selfIntroduction = '',
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// MBTI 입력 단계 진행 가능 여부.
  bool get canContinueMbti =>
      energy != null &&
      perception != null &&
      decision != null &&
      lifestyle != null;

  /// 완성된 MBTI 문자열.
  String? get mbti {
    if (!canContinueMbti) return null;

    return '$energy$perception$decision$lifestyle';
  }

  /// 값 복사.
  ProfileDetailsModel copyWith({
    Object? energy = _undefined,
    Object? perception = _undefined,
    Object? decision = _undefined,
    Object? lifestyle = _undefined,
    String? selfIntroduction,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return ProfileDetailsModel(
      energy: energy == _undefined ? this.energy : energy as String?,
      perception: perception == _undefined
          ? this.perception
          : perception as String?,
      decision: decision == _undefined ? this.decision : decision as String?,
      lifestyle: lifestyle == _undefined
          ? this.lifestyle
          : lifestyle as String?,
      selfIntroduction: selfIntroduction ?? this.selfIntroduction,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
    );
  }
}
