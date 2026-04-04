/// 로그인 성공 결과
class LoginResult {
  /// 액세스 토큰
  final String accessToken;

  /// 리프레시 토큰
  final String refreshToken;

  /// 생성자
  const LoginResult({required this.accessToken, required this.refreshToken});
}
