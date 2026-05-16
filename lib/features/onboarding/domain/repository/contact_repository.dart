/// 연락처 Repository.
abstract class ContactRepository {
  /// 연락처 전화번호 목록을 업로드한다.
  Future<void> uploadContacts({required List<String> phoneNumbers});
}
