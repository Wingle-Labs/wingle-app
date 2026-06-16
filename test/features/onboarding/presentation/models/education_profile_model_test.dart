import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/presentation/models/education_profile_model.dart';

void main() {
  test('대학교는 학교명 입력이 필요하다', () {
    const state = EducationProfileModel(
      educationLevel: EducationLevel.university,
    );

    expect(state.requiresSchoolName, isTrue);
    expect(state.canContinueSchool, isFalse);
    expect(state.copyWith(schoolName: '한국대학교').canContinueSchool, isTrue);
  });

  test('기타는 학교명 입력 후 다음 단계로 진행할 수 있다', () {
    const state = EducationProfileModel(educationLevel: EducationLevel.other);

    expect(state.requiresSchoolName, isTrue);
    expect(state.canContinueSchool, isFalse);
    expect(state.copyWith(schoolName: '기타 학교').canContinueSchool, isTrue);
    expect(state.educationLevel?.skipsEducationVerification, isTrue);
  });

  test('고등학교는 학교명 입력 후 학교 인증을 생략한다', () {
    const state = EducationProfileModel(
      educationLevel: EducationLevel.highSchool,
    );

    expect(state.requiresSchoolName, isTrue);
    expect(state.canContinueSchool, isFalse);
    expect(state.copyWith(schoolName: '서울고등학교').canContinueSchool, isTrue);
    expect(state.educationLevel?.skipsEducationVerification, isTrue);
  });

  test('학교 이메일은 개인 이메일 도메인을 허용하지 않는다', () {
    const state = EducationProfileModel();

    expect(
      state.copyWith(email: 'name@snu.ac.kr').canSendVerificationEmail,
      isTrue,
    );
    expect(
      state.copyWith(email: 'name@gmail.com').canSendVerificationEmail,
      isFalse,
    );
  });

  test('학적 증명서 파일이 있으면 제출할 수 있다', () {
    final state = EducationProfileModel(
      certificationFile: EducationCertificationFile(
        name: 'certification.png',
        contentType: 'image/png',
        bytes: const [1, 2, 3],
      ),
    );

    expect(state.canSubmitCertification, isTrue);
    expect(state.certificationFile?.sizeInBytes, 3);
  });
}
