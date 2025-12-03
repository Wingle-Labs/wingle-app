/// Firebase 휴대폰 인증 API
class FirebasePhoneAuthApi {
  /// 인증코드 요청
  Future<bool> requestCode(String phone) {
    return Future.delayed(const Duration(seconds: 1), () => true);
  }

  /// 인증코드 확인
  Future<bool> verifyCode(String smsCode) {
    return Future.delayed(const Duration(seconds: 1), () => true);
  }
}
