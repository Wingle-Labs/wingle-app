import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';

/// 회원가입 관련 Repository 인터페이스.
abstract class SignupRepository {
  /// 회원가입 비밀번호를 등록한다.
  Future<void> submitPassword({required String uuid, required String password});

  /// 본인인증 결과를 등록한다.
  Future<void> submitIdentityVerification({
    required String uuid,
    required PortoneVerifiedCustomerDto user,
    required int age,
    required String impUid,
  });
}
