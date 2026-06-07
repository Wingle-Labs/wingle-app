/// 프로필 거절 사유.
class RejectionReason {
  /// 거절 사유 목록.
  final List<RejectionReasonItem> reasons;

  /// 거절 일시.
  final String reviewedAt;

  /// 생성자.
  const RejectionReason({required this.reasons, required this.reviewedAt});

  /// 표시 가능한 사유가 있는지 여부.
  bool get hasReasons => reasons.isNotEmpty;

  /// JSON에서 생성한다.
  factory RejectionReason.fromJson(Map<String, dynamic> json) {
    final reasonsJson = json['reasons'];
    final parsedReasons = reasonsJson is List
        ? reasonsJson
              .whereType<Map>()
              .map(
                (item) => RejectionReasonItem.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .where((item) => item.hasDisplayText)
              .toList(growable: false)
        : <RejectionReasonItem>[];

    final legacyReason = json['reason']?.toString() ?? '';
    final reasons = parsedReasons.isNotEmpty
        ? parsedReasons
        : legacyReason.isEmpty
        ? <RejectionReasonItem>[]
        : [
            RejectionReasonItem(
              code: 'LEGACY_REASON',
              categoryDisplayName: '',
              description: legacyReason,
            ),
          ];

    return RejectionReason(
      reasons: reasons,
      reviewedAt:
          json['reviewedAt']?.toString() ??
          json['rejectedAt']?.toString() ??
          '',
    );
  }
}

/// 프로필 거절 사유 항목.
class RejectionReasonItem {
  /// 거절 사유 코드.
  final String code;

  /// 거절 사유 카테고리 표시명.
  final String categoryDisplayName;

  /// 거절 사유 설명.
  final String description;

  /// 생성자.
  const RejectionReasonItem({
    required this.code,
    required this.categoryDisplayName,
    required this.description,
  });

  /// 표시 가능한 문구가 있는지 여부.
  bool get hasDisplayText =>
      categoryDisplayName.trim().isNotEmpty || description.trim().isNotEmpty;

  /// JSON에서 생성한다.
  factory RejectionReasonItem.fromJson(Map<String, dynamic> json) {
    return RejectionReasonItem(
      code: json['code']?.toString() ?? '',
      categoryDisplayName: json['categoryDisplayName']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
