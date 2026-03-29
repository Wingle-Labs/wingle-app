/// API 에러 메시지를 정의하는 상수 클래스.
///
/// - 네트워크 계층에서 사용하는 에러 메시지를 중앙 관리한다.
/// - 문자열 하드코딩을 방지한다.
class ApiErrorMessages {
  /// 인스턴스 생성을 방지하기 위한 private 생성자.
  ApiErrorMessages._();

  /// 약관 조회 실패 메시지.
  static const String fetchTermsFailed = '약관 정보를 불러오는 데 실패했습니다.';

  /// 약관 동의 등록 실패 메시지
  static const String submitTermsFailed = '약관 동의 처리에 실패했습니다.';

  /// 로그인 실패 메시지
  static const String loginFailed = '로그인에 실패했습니다. 잠시 후 다시 시도해주세요.';

  /// 로그인 인증 실패 메시지
  static const String invalidLoginCredentials = '전화번호 또는 비밀번호를 확인해주세요.';
}
