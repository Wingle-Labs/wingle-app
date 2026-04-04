import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';

/// PASS 인증 Repository 실제 구현
class PassRepositoryImpl implements PassRepository {
  @override
  Future<PortoneConfirmResponseDto> fetchVerificationResult(String impUid) {
    throw UnimplementedError('PASS API는 아직 준비되지 않았습니다.');
  }
}
