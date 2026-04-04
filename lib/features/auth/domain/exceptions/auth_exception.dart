/// 인증 도메인 예외
class AuthException implements Exception {
  /// 사용자 노출용 메시지
  final String message;

  /// 생성자
  const AuthException(this.message);

  @override
  String toString() => message;
}
