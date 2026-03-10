import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

/// 약관 데이터를 제공하는 Repository 인터페이스.
///
/// - 외부 데이터 소스(API 등)에 대한 추상화 계층.
/// - Presentation 레이어는 구현체가 아닌 이 인터페이스에 의존한다.
abstract class TermRepository {
  /// 약관 목록을 조회한다.
  ///
  /// 반환값:
  /// - [AgreementItemModel] 리스트
  /// 예외:
  /// - 네트워크 실패 시 예외 발생
  Future<List<AgreementItemModel>> fetchTerms();
}
