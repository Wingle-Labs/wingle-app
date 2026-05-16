/// 코드북 그룹.
enum CodebookGroup { bodyType, region }

/// 코드북 그룹 확장.
extension CodebookGroupX on CodebookGroup {
  /// 서버/API에서 사용하는 그룹 코드.
  String get code => switch (this) {
    CodebookGroup.bodyType => 'BODY_TYPE',
    CodebookGroup.region => 'REGION',
  };
}
