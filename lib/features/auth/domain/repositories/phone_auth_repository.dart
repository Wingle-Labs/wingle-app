/// 전화번호 인증 레포지토리
abstract class PhoneAuthRepository {
  /// 인증코드 요청
  Future<bool> requestCode(String number);

  /// 인증번호 확인
  Future<bool> verifyCode(String smsCode);
}
