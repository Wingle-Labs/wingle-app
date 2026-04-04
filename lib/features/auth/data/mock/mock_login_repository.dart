import 'dart:async';

import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/domain/repositories/login_repository.dart';

/// 로그인 Repository Mock 구현
class MockLoginRepository implements LoginRepository {
  /// 테스트용 계정
  static const String mockPhoneNumber = '010-1234-5678';

  /// 테스트용 비밀번호
  static const String mockPassword = '!abc1010';

  @override
  Future<LoginResult> login({
    required PhoneNumber phoneNumber,
    required Password password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (phoneNumber.apiValue != mockPhoneNumber ||
        password.value != mockPassword) {
      throw const AuthException(ApiErrorMessages.invalidLoginCredentials);
    }

    return const LoginResult(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
    );
  }
}
