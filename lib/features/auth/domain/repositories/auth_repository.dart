import 'package:wingle/features/auth/domain/models/auth_token.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

/// 인증 Repository.
abstract class AuthRepository {
  /// 전화번호와 비밀번호로 로그인한다.
  Future<LoginResult> login({
    required PhoneNumber phoneNumber,
    required Password password,
  });

  /// 로그아웃한다.
  Future<void> logout();

  /// 리프레시 토큰으로 토큰을 재발급한다.
  Future<AuthToken> reissue({required String refreshToken});
}
