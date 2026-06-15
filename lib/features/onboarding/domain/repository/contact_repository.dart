/// 연락처 Repository.
abstract class ContactRepository {
  /// 연락처 전화번호 목록을 업로드한다.
  Future<void> uploadContacts({required List<String> phoneNumbers});

  /// 연락처 차단을 건너뛰고 온보딩을 완료한다.
  Future<void> skipContacts();
}
