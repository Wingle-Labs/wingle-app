/// 프로필 거절 사유.
class RejectionReason {
  /// 거절 사유
  final String reason;

  /// 거절 일시
  final String reviewedAt;

  /// 생성자
  const RejectionReason({required this.reason, required this.reviewedAt});

  /// JSON에서 생성한다.
  factory RejectionReason.fromJson(Map<String, dynamic> json) {
    return RejectionReason(
      reason: json['reason']?.toString() ?? '',
      reviewedAt: json['reviewedAt']?.toString() ?? '',
    );
  }
}
