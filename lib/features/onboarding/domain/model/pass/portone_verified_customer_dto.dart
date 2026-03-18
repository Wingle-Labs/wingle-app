import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_operator.dart';

/// Portone 인증된 고객 정보 DTO
class PortoneVerifiedCustomerDto {
  /// 이름
  final String name;

  /// 전화번호
  final String? phoneNumber;

  /// 통신사
  final PassOperator? operator;

  /// 생년월일(yyyy-MM-dd)
  final DateTime? birthDate;

  /// 성별
  final PassGender? gender;

  /// 외국인 여부
  final bool? isForeigner;

  /// 개인 고유 식별키
  final String? ci;

  /// 사이트별 개인 고유 식별키
  final String? di;

  /// 생성자
  PortoneVerifiedCustomerDto({
    required this.name,
    this.phoneNumber,
    this.operator,
    this.birthDate,
    this.gender,
    this.isForeigner,
    this.ci,
    this.di,
  });

  /// JSON에서 생성
  factory PortoneVerifiedCustomerDto.fromJson(Map<String, dynamic> json) {
    return PortoneVerifiedCustomerDto(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      operator: PassOperator.getValueOf(json['operator']),
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      gender: PassGender.getValueOf(json['gender']),
      isForeigner: json['isForeigner'],
      ci: json['ci'],
      di: json['di'],
    );
  }
}
