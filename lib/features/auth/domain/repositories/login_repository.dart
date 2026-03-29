import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

/// 로그인 레포지토리
abstract class LoginRepository {
  /// 전화번호와 비밀번호로 로그인한다.
  Future<LoginResult> login({
    required PhoneNumber phoneNumber,
    required Password password,
  });
}
