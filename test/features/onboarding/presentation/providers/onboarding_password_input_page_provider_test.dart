import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/signup_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_password_input_page_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/signup_repository_provider.dart';

class CapturingSignupRepository implements SignupRepository {
  String? submittedUuid;
  String? submittedPassword;

  @override
  Future<void> submitPassword({
    required String uuid,
    required String password,
  }) async {
    submittedUuid = uuid;
    submittedPassword = password;
  }

  @override
  Future<void> submitIdentityVerification({
    required String uuid,
    required PortoneVerifiedCustomerDto user,
    required int age,
    required String impUid,
  }) async {}
}

void main() {
  test('submit 성공 시 signup repository를 호출하고 loading 상태를 해제한다', () async {
    final signupRepository = CapturingSignupRepository();
    final container = ProviderContainer(
      overrides: [
        deviceUuidProvider.overrideWithValue('device-uuid'),
        signupRepositoryProvider.overrideWithValue(signupRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(
      onboardingPasswordInputPageProvider.notifier,
    );

    notifier.updatePassword('!abc1234');
    notifier.updateConfirmPassword('!abc1234');

    final result = await notifier.submit();
    final state = container.read(onboardingPasswordInputPageProvider);

    expect(result, isTrue);
    expect(signupRepository.submittedUuid, 'device-uuid');
    expect(signupRepository.submittedPassword, '!abc1234');
    expect(state.isLoading, isFalse);
  });

  test('유효하지 않은 입력은 repository를 호출하지 않는다', () async {
    final signupRepository = CapturingSignupRepository();
    final container = ProviderContainer(
      overrides: [
        deviceUuidProvider.overrideWithValue('device-uuid'),
        signupRepositoryProvider.overrideWithValue(signupRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(
      onboardingPasswordInputPageProvider.notifier,
    );

    notifier.updatePassword('abc');
    notifier.updateConfirmPassword('abc');

    final result = await notifier.submit();

    expect(result, isFalse);
    expect(signupRepository.submittedUuid, isNull);
    expect(signupRepository.submittedPassword, isNull);
  });
}
