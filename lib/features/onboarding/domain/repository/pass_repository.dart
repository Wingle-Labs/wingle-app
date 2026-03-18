import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';

/// PASS 인증 관련 Repository
abstract class PassRepository {
  /// PASS 인증 결과 조회
  Future<PortoneConfirmResponseDto> fetchVerificationResult(String impUid);
}
