import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/data/mock/mock_pass_repository.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';

void main() {
  test('MockPassRepository는 본인인증 API 요청 예시와 맞는 사용자 정보를 반환한다', () async {
    final repository = MockPassRepository();

    final response = await repository.fetchVerificationResult('MOCK_UID');
    final user = response.identityVerification.verifiedCustomer;

    expect(user.name, '홍길동');
    expect(user.isForeigner, isFalse);
    expect(user.phoneNumber, '010-1234-5678');
    expect(user.ci, 'dGVzdENJaGFzaFZhbHVlMTIzNDU2Nzg5MA==');
    expect(user.gender, PassGender.female);
    expect(user.birthDate, DateTime(2000, 1, 1));
  });
}
