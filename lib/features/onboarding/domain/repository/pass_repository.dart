import 'package:wingle/features/onboarding/domain/model/pass_start_response.dart';
import 'package:wingle/features/onboarding/domain/model/pass_verification_result.dart';

/// PASS 인증 관련 Repository
abstract class PassRepository {
  /// PASS 인증 시작
  Future<PassStartResponse> startVerification();

  /// PASS 인증 결과 조회
  Future<PassVerificationResult> fetchVerificationResult();
}
