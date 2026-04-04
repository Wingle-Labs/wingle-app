import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/data/pass_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/constants/age_constants.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/signup_repository_provider.dart';

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
    final passRepo = ref.read(passRepositoryProvider);
    final signupRepo = ref.read(signupRepositoryProvider);
    final uuid = ref.read(deviceUuidProvider);
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final response = await passRepo.fetchVerificationResult(impUid);
      final user = response.identityVerification.verifiedCustomer;

      if (!user.isValid || user.birthDate == null) {
        throw StateError('본인인증 정보가 유효하지 않습니다.');
      }

      await signupRepo.submitIdentityVerification(
        uuid: uuid,
        user: user,
        age: _calculateKoreanAge(user.birthDate!),
        impUid: impUid,
      );

      return response;
    });

    if (ref.mounted) {
      state = result;
    }

    if (result.hasError) {
      Error.throwWithStackTrace(
        result.error!,
        result.stackTrace ?? StackTrace.current,
      );
    }

    return result.requireValue;
  }

  int _calculateKoreanAge(DateTime birthDate) {
    final now = DateTime.now();
    return now.year - birthDate.year + AgeConstants.koreanAgeOffset;
  }
}
