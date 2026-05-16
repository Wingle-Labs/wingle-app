/// JWT 토큰 쌍.
class AuthToken {
  /// 액세스 토큰
  final String accessToken;

  /// 리프레시 토큰
  final String refreshToken;

  /// 생성자
  const AuthToken({required this.accessToken, required this.refreshToken});

  /// JSON에서 생성한다.
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }
}
