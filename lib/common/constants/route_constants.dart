/// Go route에서 사용되는 Path 경로 정의
class AppRoutes {
  /// 루트 경로
  static const String root = '/';

  /// 홈 화면 경로
  static const String home = '/home';

  /// 온보딩 화면 경로
  static const String onboarding = '/onboarding';

  /// 전화번호 인증 화면 경로
  static const String phone = 'phone';

  /// 인증번호 입력 화면 경로
  static const String otp = 'otp';

  /// 나이 입력 화면 경로
  static const String age = 'age';

  /// 필수 자기소개 입력 화면
  static const String requiredSelfIntro = 'required-self-intro';

  /// 선택형 자기소개 입력 화면
  static const String selectiveSelfIntro = 'selective-self-intro';

  /// 경로를 포함하여 출력하는 함수
  static String fullPath(List<String> path) => path.join('/');
}
