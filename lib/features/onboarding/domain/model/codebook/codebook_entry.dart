/// 코드북 엔트리.
class CodebookEntry {
  /// 코드
  final String code;

  /// 코드명
  final String codeName;

  /// 부모 코드
  final String? parentCode;

  /// 표시 순서
  final int displayOrder;

  /// 생성자
  const CodebookEntry({
    required this.code,
    required this.codeName,
    required this.parentCode,
    required this.displayOrder,
  });

  /// JSON에서 생성한다.
  factory CodebookEntry.fromJson(Map<String, dynamic> json) {
    final rawDisplayOrder = json['displayOrder'];
    return CodebookEntry(
      code: json['code']?.toString() ?? '',
      codeName: json['codeName']?.toString() ?? '',
      parentCode: json['parentCode']?.toString(),
      displayOrder: rawDisplayOrder is num
          ? rawDisplayOrder.toInt()
          : int.tryParse(rawDisplayOrder?.toString() ?? '') ?? 0,
    );
  }

  /// JSON으로 변환한다.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'codeName': codeName,
      'parentCode': parentCode,
      'displayOrder': displayOrder,
    };
  }
}
