import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:wingle/common/constants/kakao_constants.dart';
import 'package:wingle/common/utils/http_util.dart';

/// 카카오 API 관리자
class KakaoApiManager {
  KakaoApiManager._();

  /// 싱글톤
  static final KakaoApiManager instance = KakaoApiManager._();

  /// 공통 헤더 생성
  Map<String, String> _authHeader(String accessToken) {
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
    };
  }

  /// 카카오 로그인 시도
  Future<OAuthToken> getTokenWithLogin() async {
    try {
      if (await isKakaoTalkInstalled()) {
        final result = await UserApi.instance.loginWithKakaoTalk();
        return result;
      } else {
        final result = await UserApi.instance.loginWithKakaoAccount();
        return result;
      }
    } catch (e) {
      throw Exception('[KakaoApiManager.loginWithKakaoTalk] failed: $e');
    }
  }

  /// 카카오 사용자 정보 반환 (TokenManager 사용)
  Future<Map<String, String>> getUserInfoWithTokenManager() async {
    try {
      final user = await UserApi.instance.me();
      final nickname = user.kakaoAccount?.profile?.nickname ?? '';
      final email = user.kakaoAccount?.email ?? '';

      return {'nickname': nickname, 'email': email};
    } catch (e) {
      throw Exception(
        '[KakaoApiManager.getUserInfoWithTokenManager] failed: $e',
      );
    }
  }

  /// accessToken 으로 사용자 정보 조회
  Future<Map<String, dynamic>> getUserInfoWithAccessToken(
    String accessToken,
  ) async {
    final res = await HttpUtil.instance.get(
      KakaoApiUrl.userMe,
      headers: _authHeader(accessToken),
    );

    if (res.statusCode != 200) {
      throw Exception(
        // ignore: lines_longer_than_80_chars
        '[KakaoApiManager.getUserInfoWithAccessToken] failed: ${res.statusCode}',
      );
    }

    return res.data as Map<String, dynamic>;
  }

  /// 토큰 유효성 검증
  Future<bool> verifyToken(String accessToken) async {
    try {
      final res = await HttpUtil.instance.get(
        KakaoApiUrl.userMe,
        headers: _authHeader(accessToken),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// 로그아웃 (카카오 서버 기준)
  Future<bool> logout(String accessToken) async {
    final res = await HttpUtil.instance.post(
      KakaoApiUrl.logout,
      headers: _authHeader(accessToken),
    );

    return res.statusCode == 200;
  }

  /// 연결 끊기 (선택 – 유저 탈퇴 시)
  Future<bool> unlink(String accessToken) async {
    final res = await HttpUtil.instance.post(
      KakaoApiUrl.unlink,
      headers: _authHeader(accessToken),
    );

    return res.statusCode == 200;
  }
}
