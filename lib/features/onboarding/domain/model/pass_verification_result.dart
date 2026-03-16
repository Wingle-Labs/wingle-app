/// 페이스 인증 결과 모델
class PassVerificationResult {
  /// CI (Citizen Identification)
  final String ci;

  /// 이름
  final String name;

  /// 휴대폰 번호
  final String phoneNumber;

  /// 생년월일
  final DateTime birth;

  /// 성별
  final String gender;

  /// 생성자
  const PassVerificationResult({
    required this.ci,
    required this.name,
    required this.phoneNumber,
    required this.birth,
    required this.gender,
  });
}
