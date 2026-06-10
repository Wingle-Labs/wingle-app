/// FCM 디바이스 토큰 등록 저장소.
abstract class FcmTokenRepository {
  /// 서버에 FCM 디바이스 토큰을 등록/갱신한다.
  Future<void> registerToken({required String token});
}
