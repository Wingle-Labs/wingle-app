/// 코드북 그룹.
enum CodebookGroup {
  /// 체형 코드북.
  bodyType,

  /// 지역 코드북.
  region,

  /// 직업 코드북.
  job,

  /// 학력 코드북.
  university,

  /// 선택형 질문 카테고리 코드북.
  questionCategory,
}

/// 코드북 그룹 확장.
extension CodebookGroupX on CodebookGroup {
  /// 서버/API에서 사용하는 그룹 코드.
  String get code => switch (this) {
    CodebookGroup.bodyType => 'BODY_TYPE',
    CodebookGroup.region => 'REGION',
    CodebookGroup.job => 'JOB',
    CodebookGroup.university => 'UNIVERSITY',
    CodebookGroup.questionCategory => 'QUESTION_CATEGORY',
  };
}
