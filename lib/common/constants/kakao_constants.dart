/// 카카오 API URL
class KakaoApiUrl {
  /// 카카오 API 호스트
  static const String host = "https://kapi.kakao.com";

  /// 사용자 정보 조회
  static const String userMe = "$host/v2/user/me";

  /// 로그아웃
  static const String logout = "$host/v1/user/logout";

  /// 회원 연결 끊기
  static const String unlink = "$host/v1/user/unlink";
}
