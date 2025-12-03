/// 전화번호 인증에 사용되는 상수 정의
class AuthConstrants {
  /// 전화번호 정규식
  static const String phoneRegex = r'^010[2-9]\d{7}$';

  /// 전화번호 길이
  static const int phoneMaxLength = 11;

  /// SMS 인증번호 길이
  static const int smsCodeLength = 6;
}
