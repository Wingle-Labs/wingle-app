/// Portone API에 정의된 본인인증 성별 열거
enum PassGender {
  /// 남성
  male,

  /// 여성
  female,

  /// 그 외 성별
  other;

  /// JSON에서 PassGender 생성
  static PassGender? getValueOf(String? json) {
    if (json == null) return null;
    return PassGender.values.firstWhere((e) => e.value == json);
  }
}

/// PassGender 확장
extension PassGenderUtil on PassGender {
  /// 표시 이름
  String get displayName {
    switch (this) {
      case PassGender.male:
        return '남성';
      case PassGender.female:
        return '여성';
      case PassGender.other:
        return '기타';
    }
  }

  /// 값 (대문자)
  String get value {
    return name.toUpperCase();
  }
}
