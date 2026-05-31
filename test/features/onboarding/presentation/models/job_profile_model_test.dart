import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/presentation/models/job_profile_model.dart';

void main() {
  group('JobProfileModel', () {
    test('회사 이메일 형식이면 인증번호 전송이 가능하다', () {
      const model = JobProfileModel(email: 'name@samsung.com');

      expect(model.canSendVerificationEmail, isTrue);
    });

    test('개인 이메일 도메인은 회사 이메일 인증에 사용할 수 없다', () {
      const gmail = JobProfileModel(email: 'name@gmail.com');
      const naver = JobProfileModel(email: 'name@naver.com');

      expect(gmail.canSendVerificationEmail, isFalse);
      expect(naver.canSendVerificationEmail, isFalse);
    });

    test('인증번호 확인은 회사 이메일과 인증번호가 모두 있어야 가능하다', () {
      const ready = JobProfileModel(
        email: 'name@samsung.com',
        verificationCode: '482910',
      );
      const missingCode = JobProfileModel(email: 'name@samsung.com');
      const personalEmail = JobProfileModel(
        email: 'name@gmail.com',
        verificationCode: '482910',
      );

      expect(ready.canConfirmVerificationCode, isTrue);
      expect(missingCode.canConfirmVerificationCode, isFalse);
      expect(personalEmail.canConfirmVerificationCode, isFalse);
    });
  });
}
