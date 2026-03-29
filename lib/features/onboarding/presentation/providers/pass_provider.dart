import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/data/pass_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';

part 'pass_provider.g.dart';

/// PASS 인증 Repository Provider
@riverpod
PassRepository passRepository(Ref ref) {
  const isApiReady = false;

  if (RepositorySelector.shouldUseMock(isApiReady: isApiReady)) {
    return MockPassRepository();
  }

  return PassRepositoryImpl();
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
    const isApiReady = false;
    final isMock = RepositorySelector.shouldUseMock(isApiReady: isApiReady);

    if (isMock) {
      return 'MOCK_UID';
    } else if (impUid == null || impUid == "null") {
      return null;
    }
    return impUid;
  }

  /// PASS 인증 완료
  Future<PortoneConfirmResponseDto> completeVerification(String impUid) async {
    final repo = ref.read(passRepositoryProvider);

    state = const AsyncLoading();

    final result = await repo.fetchVerificationResult(impUid);

    state = AsyncData(result);

    return result;
  }
}
