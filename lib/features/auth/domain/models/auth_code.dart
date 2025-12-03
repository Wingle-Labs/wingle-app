import 'package:wingle/features/auth/common/constrants/auth_constrants.dart';

/// 전화번호 인증 코드
class AuthCode {
  /// 인증코드
  final String value;

  /// 생성자
  const AuthCode(this.value);

  /// 인증코드가 유효한지 확인
  bool get isValid {
    if (value.isEmpty) return false;
    return value.length == AuthConstrants.smsCodeLength;
  }
}
