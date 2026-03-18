/// Portone API에 정의된 본인인증 통신사 열거
enum PassOperator {
  /// SKT
  skt,

  /// KT
  kt,

  /// LGU+
  lg,

  /// SKT 알뜰폰
  sktMvno,

  ///KT 알뜰폰
  ktMvno,

  ///LGU 알뜰폰
  lgMvno;

  /// JSON에서 Operator 생성
  static PassOperator? getValueOf(String? json) {
    if (json == null) return null;
    return PassOperator.values.firstWhere((e) => e.value == json);
  }
}

/// Operator 확장
extension OperatorUtil on PassOperator {
  /// 표시 이름
  String get displayName {
    switch (this) {
      case PassOperator.skt:
        return 'SKT';
      case PassOperator.kt:
        return 'KT';
      case PassOperator.lg:
        return 'LGU+';
      case PassOperator.sktMvno:
        return 'SKT 알뜰폰';
      case PassOperator.ktMvno:
        return 'KT 알뜰폰';
      case PassOperator.lgMvno:
        return 'LGU 알뜰폰';
    }
  }

  /// 값 (대문자)
  String get value {
    return name.toUpperCase();
  }
}
