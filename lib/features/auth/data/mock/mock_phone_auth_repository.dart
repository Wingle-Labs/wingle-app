import 'dart:async';

import 'package:wingle/features/auth/domain/repositories/phone_auth_repository.dart';

/// 휴대폰 인증 Mock Repository
class MockPhoneAuthRepository implements PhoneAuthRepository {
  @override
  Future<bool> requestCode(String number) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<bool> verifyCode(String smsCode) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return smsCode == '123456';
  }
}
