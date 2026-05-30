import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/data/dto/login_response_dto.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';

void main() {
  test('LoginResponseDto는 legacy profileStatus를 하위 호환 파싱한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'profileStatus': 'FIRST_APPROVAL_PENDING',
      'gender': 'female',
    });

    expect(dto.accessToken, 'access-token');
    expect(dto.refreshToken, 'refresh-token');
    expect(dto.profileStatus, LoginProfileStatus.awaitingApproval);
    expect(dto.gender, 'female');

    final result = dto.toDomain();
    expect(result.profileStatus, LoginProfileStatus.awaitingApproval);
    expect(result.gender, 'female');
  });

  test('LoginResponseDto는 BE onboardingStatus를 우선 파싱한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'profileStatus': 'FIRST_APPROVAL_REJECTED',
      'onboardingStatus': 'SIGNUP_COMPLETED',
    });

    expect(dto.profileStatus, LoginProfileStatus.signupCompleted);
  });

  test('LoginResponseDto는 profileStatus가 없으면 회원가입 완료로 처리한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
    });

    expect(dto.profileStatus, LoginProfileStatus.signupCompleted);
    expect(dto.toDomain().profileStatus, LoginProfileStatus.signupCompleted);
    expect(dto.gender, isNull);
  });

  test('LoginResponseDto는 실제 로그인 응답의 onboardingStatus를 파싱한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': '<redacted>',
      'refreshToken': '<redacted>',
      'name': '정민호',
      'phoneNumber': '010-9256-6504',
      'age': 26,
      'birth': '2000-01-01',
      'lastestTermVersion': 1,
      'role': 'USER',
      'onboardingStatus': 'SIGNUP_COMPLETED',
      'termAgreements': [
        {'type': 'TOS', 'version': 1, 'isAgreed': true, 'isRequired': true},
      ],
    });

    expect(dto.profileStatus, LoginProfileStatus.signupCompleted);
  });

  test('LoginResponseDto는 로그인 응답의 기본 프로필 정보를 파싱한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'onboardingStatus': 'BASIC_INFO_COMPLETED',
      'nickname': '반반한 라벤더',
      'residenceCode': 'R_31193620',
      'height': 175,
      'bodyTypeCode': 'BT_M_001',
    });

    expect(dto.basicProfile?.nickname, '반반한 라벤더');
    expect(dto.basicProfile?.residenceCode, 'R_31193620');
    expect(dto.basicProfile?.height, 175);
    expect(dto.basicProfile?.bodyTypeCode, 'BT_M_001');
    expect(dto.toDomain().basicProfile?.bodyTypeCode, 'BT_M_001');
  });

  test('LoginResponseDto는 nested profile 기본 프로필 정보도 파싱한다', () {
    final dto = LoginResponseDto.fromJson({
      'accessToken': 'access-token',
      'refreshToken': 'refresh-token',
      'profile': {
        'nickname': '설레는 크리스탈',
        'residence_code': 'R_11060840',
        'height': '168',
        'body_type_code': 'BT_F_002',
      },
    });

    expect(dto.basicProfile?.nickname, '설레는 크리스탈');
    expect(dto.basicProfile?.residenceCode, 'R_11060840');
    expect(dto.basicProfile?.height, 168);
    expect(dto.basicProfile?.bodyTypeCode, 'BT_F_002');
  });
}
