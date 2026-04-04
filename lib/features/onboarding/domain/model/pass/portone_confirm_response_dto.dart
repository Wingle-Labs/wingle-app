import 'package:wingle/features/onboarding/domain/model/pass/portone_identity_verification_dto.dart';

/// Portone 확인 응답 최상위 DTO
class PortoneConfirmResponseDto {
  /// 인증 정보
  final PortoneIdentityVerificationDto identityVerification;

  /// 생성자
  PortoneConfirmResponseDto({required this.identityVerification});

  /// JSON에서 생성
  factory PortoneConfirmResponseDto.fromJson(Map<String, dynamic> json) {
    return PortoneConfirmResponseDto(
      identityVerification: PortoneIdentityVerificationDto.fromJson(
        json['identityVerification'],
      ),
    );
  }
}
