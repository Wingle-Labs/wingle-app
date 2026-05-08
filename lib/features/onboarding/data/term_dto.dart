/// 서버에서 내려온 약관 응답을 표현하는 DTO.
///
/// - UI 상태를 포함하지 않는다.
/// - JSON 직렬화/역직렬화 전용 객체이다.
class TermDto {
  /// 약관 타입.
  final String type;

  /// Markdown 형식의 약관 전문.
  final String content;

  /// 필수 동의 여부.
  final bool isRequired;

  /// 약관 버전.
  final int version;

  /// 생성자
  const TermDto({
    required this.type,
    required this.content,
    required this.isRequired,
    required this.version,
  });

  /// JSON Map으로부터 [TermDto]를 생성한다.
  factory TermDto.fromJson(Map<String, dynamic> json) {
    /// JSON 직렬화를 수행한다.
    return TermDto(
      type: json['type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isRequired: json['isRequired'] as bool? ?? false,
      version: (json['version'] as num?)?.toInt() ?? 0,
    );
  }
}
