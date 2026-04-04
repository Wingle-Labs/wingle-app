/// 거주지 코드 정보.
class ResidenceCode {
  /// 1레벨 코드
  final String level1;

  /// 2레벨 코드
  final String level2;

  /// 3레벨 코드
  final String level3;

  /// 생성자
  const ResidenceCode({
    required this.level1,
    required this.level2,
    required this.level3,
  });

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {'level1': level1, 'level2': level2, 'level3': level3};
  }

  /// JSON에서 생성한다.
  factory ResidenceCode.fromJson(Map<String, dynamic> json) {
    return ResidenceCode(
      level1: json['level1']?.toString() ?? '',
      level2: json['level2']?.toString() ?? '',
      level3: json['level3']?.toString() ?? '',
    );
  }
}
