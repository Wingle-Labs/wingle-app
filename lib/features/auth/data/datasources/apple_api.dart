import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wingle/features/auth/data/dtos/apple_login_info.dart';

/// Apple 로그인을 위한 API 관리자
class AppleApiManager {
  /// Apple 로그인 시도 및 사용자 정보 반환
  static Future<AppleLoginInfo> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      final authorizationCode = credential.authorizationCode;
      final userIdentifier = credential.userIdentifier;

      return AppleLoginInfo(
        identityToken: identityToken ?? '',
        authorizationCode: authorizationCode,
        userIdentifier: userIdentifier ?? '',
      );
    } catch (e) {
      throw Exception('Apple login failed: $e');
    }
  }
}
