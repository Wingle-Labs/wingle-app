import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/profile/job_occupation_policy.dart';

void main() {
  group('JobOccupationPolicy', () {
    test('무직과 학생은 회사 입력과 이메일 인증을 건너뛴다', () {
      expect(JobOccupationPolicy.skipsCompanyAndEmail('J101'), isTrue);
      expect(JobOccupationPolicy.skipsCompanyAndEmail('J102'), isTrue);
      expect(JobOccupationPolicy.requiresCompany('J101'), isFalse);
      expect(JobOccupationPolicy.requiresCompany('J102'), isFalse);
    });

    test('자영업과 프리랜서는 회사 정보 입력 대상이다', () {
      expect(JobOccupationPolicy.skipsCompanyAndEmail('J601'), isFalse);
      expect(JobOccupationPolicy.skipsCompanyAndEmail('J602'), isFalse);
      expect(JobOccupationPolicy.requiresCompany('J601'), isTrue);
      expect(JobOccupationPolicy.requiresCompany('J602'), isTrue);
    });
  });
}
