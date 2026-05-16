import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_operator.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_identity_verification_dto.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/signup_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/pass_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/signup_repository_provider.dart';

class FakePassRepository implements PassRepository {
  final PortoneConfirmResponseDto response;

  FakePassRepository(this.response);

  @override
  Future<PortoneConfirmResponseDto> fetchVerificationResult(
    String impUid,
  ) async {
    return response;
  }
}

class CapturingSignupRepository implements SignupRepository {
  String? submittedUuid;
  PortoneVerifiedCustomerDto? submittedUser;
  int? submittedAge;
  String? submittedImpUid;

  @override
  Future<void> submitPassword({
    required String uuid,
    required String password,
  }) async {}

  @override
  Future<void> submitIdentityVerification({
    required String uuid,
    required PortoneVerifiedCustomerDto user,
    required int age,
    required String impUid,
  }) async {
    submittedUuid = uuid;
    submittedUser = user;
    submittedAge = age;
    submittedImpUid = impUid;
  }
}

void main() {
  test('본인인증 완료 시 PASS 결과를 저장하고 signup repository를 호출한다', () async {
    final response = PortoneConfirmResponseDto(
      identityVerification: PortoneIdentityVerificationDto(
        id: 'mock-id',
        status: 'confirmed',
        verifiedCustomer: PortoneVerifiedCustomerDto(
          name: '김민수',
          phoneNumber: '010-9256-6504',
          operator: PassOperator.skt,
          birthDate: DateTime(2001, 1, 1),
          gender: PassGender.male,
          isForeigner: false,
          ci: 'CI123',
          di: 'DI123',
        ),
      ),
    );

    final signupRepository = CapturingSignupRepository();
    final container = ProviderContainer(
      overrides: [
        deviceUuidProvider.overrideWithValue('device-uuid'),
        passRepositoryProvider.overrideWithValue(FakePassRepository(response)),
        signupRepositoryProvider.overrideWithValue(signupRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(passVerificationProvider.notifier);
    final result = await notifier.completeVerification('imp_123');
    final state = container.read(passVerificationProvider);

    expect(result.identityVerification.verifiedCustomer.name, '김민수');
    expect(state.hasValue, isTrue);
    expect(state.value?.identityVerification.verifiedCustomer.ci, 'CI123');
    expect(signupRepository.submittedUuid, 'device-uuid');
    expect(signupRepository.submittedImpUid, 'imp_123');
    expect(signupRepository.submittedUser?.name, '김민수');
    expect(signupRepository.submittedAge, _calculateAge(DateTime(2001, 1, 1)));
  });
}

int _calculateAge(DateTime birthDate) {
  final now = DateTime.now();
  final hasHadBirthday =
      now.month > birthDate.month ||
      (now.month == birthDate.month && now.day >= birthDate.day);
  final age = now.year - birthDate.year;
  return hasHadBirthday ? age : age - 1;
}
