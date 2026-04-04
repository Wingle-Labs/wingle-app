/// 앱 화면 경로 열거형
enum AppRoute {
  /// 홈 화면 경로
  home,

  /// 온보딩 전체 흐름의 루트 경로
  onboarding,

  /// 온보딩 내부의 로그인 화면 경로
  login,

  /// 온보딩 내부의 회원가입 화면 경로
  signup,

  /// 전화번호 입력 화면 경로
  phone,

  /// 인증번호(OTP) 입력 화면 경로
  otp,

  /// 나이 입력 화면 경로
  age,

  /// 필수 자기소개 입력 화면 경로
  requiredSelfIntro,

  /// 선택형 자기소개 입력 화면 경로
  selectiveSelfIntro,
}

/// AppRoute enum을 실제 문자열 경로로 변환하는 확장
extension AppRoutePath on AppRoute {
  /// 실제 문자열 경로
  String get path {
    switch (this) {
      case AppRoute.home:
        return '/home';
      case AppRoute.onboarding:
        return '/onboarding';
      case AppRoute.login:
        return 'login';
      case AppRoute.signup:
        return 'signup';
      case AppRoute.phone:
        return 'phone';
      case AppRoute.otp:
        return 'otp';
      case AppRoute.age:
        return 'age';
      case AppRoute.requiredSelfIntro:
        return 'required-self-intro';
      case AppRoute.selectiveSelfIntro:
        return 'selective-self-intro';
    }
  }
}
