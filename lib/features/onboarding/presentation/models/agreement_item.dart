/// 약관 동의 UI 모델
///
/// - 서버에서 내려온 약관 정보를 기반으로 생성된다.
/// - UI 상태(isChecked)를 포함한다.
/// - 회원가입 시 version과 함께 서버로 재전송된다.
class AgreementItem {
  /// 약관 고유 식별자
  final int id;

  /// 약관 제목
  final String title;

  /// 약관 전문 (Markdown 형식)
  final String markdown;

  /// 필수 약관 여부
  final bool isRequired;

  /// 약관 버전
  final double version;

  /// 현재 체크 상태
  final bool isChecked;

  /// 생성자
  const AgreementItem({
    required this.id,
    required this.title,
    required this.markdown,
    required this.isRequired,
    required this.version,
    this.isChecked = false,
  });

  /// 체크 상태 변경용 복사 메서드
  AgreementItem copyWith({bool? isChecked}) {
    return AgreementItem(
      id: id,
      title: title,
      markdown: markdown,
      isRequired: isRequired,
      version: version,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  /// 서버 전송용 DTO 변환
  Map<String, dynamic> toRequest() {
    return {'id': id, 'version': version, 'isChecked': isChecked};
  }
}
