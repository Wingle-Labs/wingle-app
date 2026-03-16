import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/domain/model/pass_verification_result.dart';
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
  FutureOr<PassVerificationResult?> build() {
    return null;
  }

  /// PASS 인증 시작
  Future<String> startVerification() async {
    final repo = ref.read(passRepositoryProvider);

    final result = await repo.startVerification();

    return result.verificationUrl;
  }

  /// PASS 인증 완료
  Future<void> completeVerification() async {
    final repo = ref.read(passRepositoryProvider);

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      return await repo.fetchVerificationResult();
    });

    state = result;
  }
}
