/// 기본 프로필 업로드 진행 상태 모델.
class BasicProfileCompletionModel {
  static const Object _unset = Object();

  /// 업로드 로딩 여부
  final bool isLoading;

  /// 에러 메시지 키
  final String? errorMessage;

  /// 생성자
  const BasicProfileCompletionModel({
    this.isLoading = false,
    this.errorMessage,
  });

  /// 복사
  BasicProfileCompletionModel copyWith({
    bool? isLoading,
    Object? errorMessage = _unset,
  }) {
    return BasicProfileCompletionModel(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
