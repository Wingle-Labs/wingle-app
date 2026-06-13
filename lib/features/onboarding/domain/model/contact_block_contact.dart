/// 연락처 지인 제외 화면에서 선택 가능한 연락처.
class ContactBlockContact {
  /// 연락처 식별자.
  final String id;

  /// 화면에 표시할 이름.
  final String displayName;

  /// API로 전송 가능한 정규화된 전화번호 목록.
  final List<String> phoneNumbers;

  /// 생성자.
  const ContactBlockContact({
    required this.id,
    required this.displayName,
    required this.phoneNumbers,
  });
}
