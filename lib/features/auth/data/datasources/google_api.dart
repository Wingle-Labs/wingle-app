import 'package:google_sign_in/google_sign_in.dart';

/// Google 로그인 API 관리자
class GoogleApiManager {
  GoogleApiManager._();

  /// 싱글톤 인스턴스
  static final GoogleApiManager instance = GoogleApiManager._();

  /// 초기화
  Future<void> init({required String googleClientId}) async {
    await GoogleSignIn.instance.initialize(clientId: googleClientId);
  }

  /// 로그인 시도
  Future<GoogleSignInAuthentication> signIn() async {
    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication auth = account.authentication;
      return auth;
    } catch (e) {
      throw Exception('[GoogleApiManager.signIn] failed: $e');
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    await GoogleSignIn.instance.signOut();
  }

  /// 계정 연결 해제
  Future<void> disconnect() async {
    await GoogleSignIn.instance.disconnect();
  }
}
