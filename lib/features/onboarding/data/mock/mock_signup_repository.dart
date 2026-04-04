import 'dart:async';

import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/signup_repository.dart';

/// 회원가입 Repository Mock 구현
class MockSignupRepository implements SignupRepository {
  @override
  Future<void> submitPassword({
    required String uuid,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> submitIdentityVerification({
    required String uuid,
    required PortoneVerifiedCustomerDto user,
    required int age,
    required String impUid,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
