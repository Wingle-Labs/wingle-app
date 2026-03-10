/// 서버에서 내려온 약관 응답을 표현하는 DTO.
///
/// - UI 상태를 포함하지 않는다.
/// - JSON 직렬화/역직렬화 전용 객체이다.
class TermDto {
  /// 약관 고유 식별자.
  final int id;

  /// 약관 제목.
  final String title;

  /// Markdown 형식의 약관 전문.
  final String content;

  /// 필수 동의 여부.
  final bool isRequire;

  /// 약관 버전.
  final String version;

  /// 생성자
  const TermDto({
    required this.id,
    required this.title,
    required this.content,
    required this.isRequire,
    required this.version,
  });

  /// JSON Map으로부터 [TermDto]를 생성한다.
  factory TermDto.fromJson(Map<String, dynamic> json) {
    /// JSON 직렬화를 수행한다.
    return TermDto(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      isRequire: json['isRequire'] as bool,
      version: json['version'] as String,
    );
  }
}
