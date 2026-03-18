import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';

part 'pass_provider.g.dart';

/// PASS 인증 Repository Provider
@riverpod
PassRepository passRepository(Ref ref) {
  return MockPassRepository();
}

/// PASS 인증 Provider
@Riverpod(keepAlive: true)
class PassVerification extends _$PassVerification {
  @override
  FutureOr<PortoneConfirmResponseDto?> build() {
    return null;
  }

  /// PASS result 전처리
  String? preprocessResult(Map<String, String> result) {
    final impUid = result['imp_uid'];
    final isMock = EnvUtil.get(PortoneEnvFile.setting) == 'MOCK';

    if (isMock) {
      return 'MCOK_UID';
    } else if (impUid == null || impUid == "null") {
      return null;
    }
    return impUid;
  }

  /// PASS 인증 완료
  Future<void> completeVerification(String impUid) async {
    final repo = ref.read(passRepositoryProvider);

    state = const AsyncLoading();

    final result = await repo.fetchVerificationResult(impUid);

    state = AsyncData(result);
  }
}
