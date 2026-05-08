import 'package:wingle/features/onboarding/domain/repository/term_repository.dart';
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
  Future<List<AgreementItemModel>> fetchTerms() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AgreementItemModel(
        id: 1,
        type: 'PRIVACY',
        title: '개인정보 처리방침',
        content: '# 개인정보처리방침\n\n## 1조 ...',
        isRequired: true,
        version: '1.3',
        isChecked: false,
      ),
      AgreementItemModel(
        id: 2,
        type: 'TOS',
        title: '서비스 이용약관',
        content: '# 서비스 이용약관\n\n## 1조 ...',
        isRequired: true,
        version: '1.0',
        isChecked: false,
      ),
      AgreementItemModel(
        id: 3,
        type: 'ADS',
        title: '광고성 정보 수신 동의',
        content: '# 광고성 정보 수신 동의\n\n## 1조 ...',
        isRequired: false,
        version: '1.0',
        isChecked: false,
      ),
    ];
  }

  @override
  Future<Map<String, int>> fetchCurrentVersions() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return const {'TOS': 1, 'PRIVACY': 1, 'ADS': 1};
  }

  @override
  Future<bool> submitAgreements({
    required String uuid,
    required List<AgreementItemModel> agreements,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
