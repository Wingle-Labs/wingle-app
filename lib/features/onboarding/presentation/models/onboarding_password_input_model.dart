/// 로그인 페이지 입력 모델
class OnboardingPasswordInputModel {
  /// UUID
  final String uuid;

  /// 비밀번호
  final String password;

  /// 비밀번호 표시 여부
  final bool isPasswordVisible;

  /// 재입력 비밀번호
  final String confirmPassword;

  /// 재입력 비밀번호 표시 여부
  final bool isConfirmPasswordVisible;

  /// 로딩 여부
  final bool isLoading;

  /// 생성자
  const OnboardingPasswordInputModel({
    required this.uuid,
    this.password = '',
    this.isPasswordVisible = false,
    this.confirmPassword = '',
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
  });

  /// 비밀번호가 유효한지 확인
  bool get isPasswordValid {
    if (password.length < 8) {
      return false;
    }
    return true;
  }

  /// 재입력된 비밀번호가 원본과 동일한 지 확인
  bool get isPasswordEqual => confirmPassword == password;

  /// 회원가입 가능한지 확인
  bool get canSignUp => isPasswordValid && isPasswordEqual;

  /// 복사
  OnboardingPasswordInputModel copyWith({
    String? uuid,
    String? password,
    bool? isPasswordVisible,
    String? confirmPassword,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
  }) {
    return OnboardingPasswordInputModel(
      uuid: this.uuid,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
