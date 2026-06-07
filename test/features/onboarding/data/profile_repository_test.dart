import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_education_profile.dart';
import 'package:wingle/features/auth/domain/models/login_job_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/data/profile_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('MockProfileRepository', () {
    test('랜덤 닉네임을 반환한다', () async {
      final repository = MockProfileRepository();

      final nickname = await repository.fetchRandomNickname();

      expect(nickname, MockProfileRepository.mockNickname);
    });

    test('내 기본 프로필 스냅샷을 반환한다', () async {
      const repository = MockProfileRepository(
        profileSnapshot: MyProfileSnapshot(
          onboardingStatus: LoginProfileStatus.jobInfoCompleted,
          basicProfile: LoginBasicProfile(
            nickname: '저장된 닉네임',
            residenceCode: 'R_31193620',
            height: 175,
            bodyTypeCode: 'BT_M_001',
          ),
          jobProfile: LoginJobProfile(
            company: '삼성전자',
            occupationCode: 'J103',
            occupationName: '사무직',
            emailVerified: true,
          ),
          educationProfile: LoginEducationProfile(
            educationLevel: 'UNIVERSITY',
            schoolName: '한국대학교',
            universityCode: 'U001',
          ),
          profileDetails: LoginProfileDetails(mbti: 'ESTJ'),
        ),
      );

      final snapshot = await repository.fetchMyProfile();
      final profile = await repository.fetchMyBasicProfile();

      expect(snapshot?.onboardingStatus, LoginProfileStatus.jobInfoCompleted);
      expect(snapshot?.jobProfile?.occupationCode, 'J103');
      expect(snapshot?.educationProfile?.educationLevel, 'UNIVERSITY');
      expect(snapshot?.educationProfile?.schoolName, '한국대학교');
      expect(snapshot?.profileDetails?.mbti, 'ESTJ');
      expect(profile?.nickname, '저장된 닉네임');
      expect(profile?.residenceCode, 'R_31193620');
      expect(profile?.height, 175);
      expect(profile?.bodyTypeCode, 'BT_M_001');
    });

    test('나머지 프로필 등록 API는 모두 완료된다', () async {
      final repository = MockProfileRepository();

      await repository.submitBasicProfile(
        nickname: MockProfileRepository.mockNickname,
        residence: const ResidenceCode(
          level1: '370',
          level2: '37080',
          level3: '37080412',
        ),
        height: 170,
        bodyTypeCode: 'BT_M_002',
      );
      await repository.submitProfileDetails(
        mbti: 'ISFP',
        selfIntroduction: '안녕하세요.',
      );
      await repository.submitEducation(
        university: 'U001',
        customUniversityName: null,
        educationLevel: 'UNIVERSITY',
      );
      await repository.verifyEducationEmail(email: 'sdfdd123@jnu.ac.kr');
      await repository.submitEducationCertification(
        certificationKey: 'users/1/certification/certification.jpg',
      );
      await repository.submitJob(company: '삼성전자', occupation: 'J103');
      await repository.verifyJobEmail(email: 'asd123@samsung.co.kr');
    });
  });

  group('ProfileRepositoryImpl', () {
    test('랜덤 닉네임을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/auth/signup/nickname/random');
        return http.Response.bytes(
          utf8.encode('{"nickname":"${MockProfileRepository.mockNickname}"}'),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final nickname = await repository.fetchRandomNickname();

      expect(nickname, MockProfileRepository.mockNickname);
    });

    test('기본 프로필 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/auth/signup/profile');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitBasicProfile(
        nickname: MockProfileRepository.mockNickname,
        residence: const ResidenceCode(
          level1: '370',
          level2: '37080',
          level3: '37080412',
        ),
        height: 170,
        bodyTypeCode: 'BT_M_002',
      );

      expect(body, {
        'nickname': MockProfileRepository.mockNickname,
        'residenceCode': '37080412',
        'height': 170,
        'bodyTypeCode': 'BT_M_002',
      });
    });

    test('내 기본 프로필 정보를 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/profiles/me');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'nickname': '서버 닉네임',
              'residenceCode': 'R_31193620',
              'height': 175,
              'bodyTypeCode': 'BT_M_001',
              'mbti': 'INFP',
              'selfIntroduction': '안녕하세요.',
              'onboardingStatus': 'JOB_INFO_COMPLETED',
              'job': {
                'company': '삼성전자',
                'occupationCode': 'J103',
                'occupationName': '사무직',
                'emailVerified': true,
              },
              'education': {
                'educationLevel': 'UNIVERSITY',
                'schoolName': '한국대학교',
                'universityCode': 'U001',
                'emailVerified': true,
              },
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final snapshot = await repository.fetchMyProfile();
      final profile = await repository.fetchMyBasicProfile();

      expect(snapshot?.onboardingStatus, LoginProfileStatus.jobInfoCompleted);
      expect(snapshot?.jobProfile?.company, '삼성전자');
      expect(snapshot?.jobProfile?.occupationCode, 'J103');
      expect(snapshot?.jobProfile?.emailVerified, isTrue);
      expect(snapshot?.educationProfile?.educationLevel, 'UNIVERSITY');
      expect(snapshot?.educationProfile?.schoolName, '한국대학교');
      expect(snapshot?.educationProfile?.universityCode, 'U001');
      expect(snapshot?.profileDetails?.mbti, 'INFP');
      expect(snapshot?.profileDetails?.selfIntroduction, '안녕하세요.');
      expect(profile?.nickname, '서버 닉네임');
      expect(profile?.residenceCode, 'R_31193620');
      expect(profile?.height, 175);
      expect(profile?.bodyTypeCode, 'BT_M_001');
    });

    test('내 기본 프로필 조회 실패 시 예외를 던진다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/profiles/me');
        return http.Response('', 404);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      expect(repository.fetchMyBasicProfile(), throwsException);
    });

    test('세부 프로필 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/profiles/detail');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitProfileDetails(
        mbti: 'ISFP',
        selfIntroduction: '안녕하세요.',
      );

      expect(body, {
        'mbti': 'ISFP',
        'selfIntroduction': '안녕하세요.',
        'subStylePhotoKeys': <dynamic>[],
        'subFacePhotoKeys': <dynamic>[],
      });
    });

    test('프로필 심사 요청은 body 없는 POST를 전송한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/profiles/approval/request');
        expect(request.body, isEmpty);
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.requestProfileApproval();
    });

    test('프로필 재심사 요청은 body 없는 POST를 전송한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/profiles/reapply');
        expect(request.body, isEmpty);
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.requestProfileReapply();
    });

    test('최신 거절 사유 응답을 reasons 배열로 파싱한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/profiles/rejection-reason');
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'reasons': [
                {
                  'code': 'FACE_PHOTO_FACE_NOT_VISIBLE',
                  'categoryDisplayName': '얼굴 사진',
                  'description': '얼굴이 잘 보이지 않습니다',
                },
                {
                  'code': 'SELF_INTRO_ADVERTISEMENT',
                  'categoryDisplayName': '자기소개',
                  'description': '광고성 내용이 포함되어 있습니다',
                },
              ],
              'reviewedAt': '2026-05-01T14:30:00',
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final reason = await repository.fetchRejectionReason();

      expect(reason.reviewedAt, '2026-05-01T14:30:00');
      expect(reason.reasons, hasLength(2));
      expect(reason.reasons.first.code, 'FACE_PHOTO_FACE_NOT_VISIBLE');
      expect(reason.reasons.first.categoryDisplayName, '얼굴 사진');
      expect(reason.reasons.first.description, '얼굴이 잘 보이지 않습니다');
    });

    test('구버전 단일 거절 사유 응답도 fallback 파싱한다', () {
      final reason = RejectionReason.fromJson({
        'reason': '프로필 사진이 기준에 맞지 않습니다.',
        'rejectedAt': '2026-05-01T14:30:00',
      });

      expect(reason.reviewedAt, '2026-05-01T14:30:00');
      expect(reason.reasons, hasLength(1));
      expect(reason.reasons.single.code, 'LEGACY_REASON');
      expect(reason.reasons.single.description, '프로필 사진이 기준에 맞지 않습니다.');
    });

    test('코드북 학교 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/user/profile/education');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitEducation(
        university: 'U001',
        customUniversityName: null,
        educationLevel: 'UNIVERSITY',
      );

      expect(body, {'university': 'U001', 'educationLevel': 'UNIVERSITY'});
    });

    test('코드북에 없는 학교는 직접 입력명으로 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/user/profile/education');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitEducation(
        university: null,
        customUniversityName: '한국대학교',
        educationLevel: 'UNIVERSITY',
      );

      expect(body, {
        'customUniversityName': '한국대학교',
        'educationLevel': 'UNIVERSITY',
      });
    });

    test('기타 학교는 university 없이 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/user/profile/education');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitEducation(
        university: null,
        customUniversityName: null,
        educationLevel: 'OTHER',
      );

      expect(body, {'educationLevel': 'OTHER'});
    });

    test('학교 이메일 인증을 요청한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.path,
          '/api/v1/user/profile/education/email-verifications',
        );
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.verifyEducationEmail(email: 'sdfdd123@jnu.ac.kr');

      expect(body, {'email': 'sdfdd123@jnu.ac.kr'});
    });

    test('학적 증명서를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.path,
          '/api/v1/user/profile/education/certification',
        );
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitEducationCertification(
        certificationKey: 'users/1/certification/certification.jpg',
      );

      expect(body, {
        'certificationKey': 'users/1/certification/certification.jpg',
      });
    });

    test('회사 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/user/profile/job');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitJob(company: '삼성전자', occupation: 'J103');

      expect(body, {'company': '삼성전자', 'occupation': 'J103'});
    });

    test('회사 입력이 불가능한 직종은 company null과 occupation을 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/user/profile/job');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitJob(occupation: 'J101');

      expect(body, {'company': null, 'occupation': 'J101'});
    });

    test('회사 정보를 수정한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/api/v1/user/profile/job');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.updateJob(company: '네이버', occupation: 'J108');

      expect(body, {'company': '네이버', 'occupation': 'J108'});
    });

    test('기본 프로필 정보를 수정한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/api/v1/user/profile');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.updateBasicProfile(
        nickname: '수정 닉네임',
        residence: const ResidenceCode(
          level1: 'R_31',
          level2: 'R_31193',
          level3: 'R_31193620',
        ),
        height: 176,
        bodyTypeCode: 'BT_M_003',
      );

      expect(body, {
        'nickname': '수정 닉네임',
        'residenceCode': 'R_31193620',
        'height': 176,
        'bodyTypeCode': 'BT_M_003',
      });
    });

    test('회사 이메일 인증을 요청한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.path,
          '/api/v1/user/profile/job/email-verifications',
        );
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.verifyJobEmail(email: 'asd123@samsung.co.kr');

      expect(body, {'email': 'asd123@samsung.co.kr'});
    });
  });
}
