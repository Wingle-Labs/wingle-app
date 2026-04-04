import 'dart:async';

import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_operator.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_confirm_response_dto.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_identity_verification_dto.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';
import 'package:wingle/features/onboarding/domain/repository/pass_repository.dart';

/// Mock PASS 인증 Repository
class MockPassRepository implements PassRepository {
  @override
  Future<PortoneConfirmResponseDto> fetchVerificationResult(
    String impUid,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    if (impUid.contains('fail')) {
      throw Exception('Mock 인증 실패');
    }

    final dto = PortoneConfirmResponseDto(
      identityVerification: PortoneIdentityVerificationDto(
        id: "mock_id",
        status: "confirmed",
        verifiedCustomer: PortoneVerifiedCustomerDto(
          name: "정민호",
          phoneNumber: "01092566504",
          operator: PassOperator.skt,
          birthDate: DateTime(2000, 11, 26),
          gender: PassGender.male,
          isForeigner: false,
          ci: "MOCK_CI",
          di: "MOCK_DI",
        ),
      ),
    );

    return dto;
  }
}
