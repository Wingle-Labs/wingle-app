import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

void main() {
  test('인증번호 확인 실패는 인증번호 입력 오류로 저장한다', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ConfirmFailingProfileRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(jobProfileProvider.notifier);
    notifier.updateEmail('name@samsung.com');
    notifier.updateVerificationCode('123456');

    final success = await notifier.confirmVerificationCode();
    final state = container.read(jobProfileProvider);

    expect(success, isFalse);
    expect(state.emailVerificationErrorMessage, isNull);
    expect(
      state.verificationCodeErrorMessage,
      ApiErrorMessages.verifyJobEmailFailed,
    );
  });
}

class _ConfirmFailingProfileRepository extends MockProfileRepository {
  const _ConfirmFailingProfileRepository();

  @override
  Future<void> confirmJobEmail({
    required String email,
    required int verificationCode,
  }) async {
    throw Exception('invalid code');
  }
}
