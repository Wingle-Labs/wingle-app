import 'package:wingle/features/onboarding/domain/repositories/term_repository.dart';
import 'package:wingle/features/onboarding/presentation/models/agreement_item.dart';

/// 약관 Repository의 Mock 구현체.
///
/// - 실제 네트워크 요청을 수행하지 않는다.
/// - 개발 및 테스트 환경에서 사용한다.
/// - 고정된 더미 데이터를 반환한다.
class MockTermRepository implements TermRepository {
  /// 생성자.
  const MockTermRepository();

  @override
  Future<List<AgreementItem>> fetchTerms() async {
    return const [
      AgreementItem(
        id: 1,
        title: '개인정보 처리방침',
        markdown: '# 개인정보처리방침\n\n## 1조 ...',
        isRequired: true,
        version: 1.3,
        isChecked: false,
      ),
      AgreementItem(
        id: 2,
        title: '서비스 이용약관',
        markdown: '# 서비스 이용약관\n\n## 1조 ...',
        isRequired: true,
        version: 1.0,
        isChecked: false,
      ),
      AgreementItem(
        id: 3,
        title: '광고성 정보 수신 동의',
        markdown: '# 광고성 정보 수신 동의\n\n## 1조 ...',
        isRequired: false,
        version: 1.0,
        isChecked: false,
      ),
    ];
  }
}
