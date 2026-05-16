/// 기본 프로필 닉네임 입력 화면 상태 모델
class BasicProfileNicknameModel {
  static const Object _unset = Object();

  /// 랜덤 닉네임
  final String nickname;

  /// 로딩 여부
  final bool isLoading;

  /// 에러 메시지
  final String? errorMessage;

  /// 생성자
  const BasicProfileNicknameModel({
    this.nickname = '',
    this.isLoading = false,
    this.errorMessage,
  });

  /// 닉네임을 사용할 수 있는지 확인한다.
  bool get canContinue => nickname.isNotEmpty && !isLoading;

  /// 닉네임을 아직 불러오지 못한 상태인지 확인한다.
  bool get shouldShowLoading => isLoading && nickname.isEmpty;

  /// 복사
  BasicProfileNicknameModel copyWith({
    String? nickname,
    bool? isLoading,
    Object? errorMessage = _unset,
  }) {
    return BasicProfileNicknameModel(
      nickname: nickname ?? this.nickname,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
