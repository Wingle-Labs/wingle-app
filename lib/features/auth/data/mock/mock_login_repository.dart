import 'dart:async';

import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
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

  /// 기본 프로필 진행 상태
  static const LoginProfileStatus defaultProfileStatus =
      LoginProfileStatus.beforeBasicProfile;

  /// 로그인 시 반환할 프로필 진행 상태
  final LoginProfileStatus profileStatus;

  /// 생성자
  const MockLoginRepository({this.profileStatus = defaultProfileStatus});

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

    return LoginResult(
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      profileStatus: profileStatus,
    );
  }
}
