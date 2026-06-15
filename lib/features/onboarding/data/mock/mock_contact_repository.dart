import 'package:wingle/features/onboarding/domain/repository/contact_repository.dart';

/// 연락처 Repository Mock 구현.
class MockContactRepository implements ContactRepository {
  /// 생성자
  const MockContactRepository();

  @override
  Future<void> uploadContacts({required List<String> phoneNumbers}) async {}

  @override
  Future<void> skipContacts() async {}
}
