import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';

/// Portone 인증 정보 DTO
class PortoneIdentityVerificationDto {
  /// ID
  final String id;

  /// 상태
  final String status;

  /// 인증된 고객 정보
  final PortoneVerifiedCustomerDto verifiedCustomer;

  /// 생성자
  PortoneIdentityVerificationDto({
    required this.id,
    required this.status,
    required this.verifiedCustomer,
  });

  /// JSON에서 생성
  factory PortoneIdentityVerificationDto.fromJson(Map<String, dynamic> json) {
    return PortoneIdentityVerificationDto(
      id: json['id'],
      status: json['status'],
      verifiedCustomer: PortoneVerifiedCustomerDto.fromJson(
        json['verifiedCustomer'],
      ),
    );
  }
}
