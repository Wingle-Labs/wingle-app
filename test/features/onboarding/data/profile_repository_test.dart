import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/data/profile_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('MockProfileRepository', () {
    test('랜덤 닉네임을 반환한다', () async {
      final repository = MockProfileRepository();

      final nickname = await repository.fetchRandomNickname();

      expect(nickname, MockProfileRepository.mockNickname);
    });

    test('나머지 프로필 등록 API는 모두 완료된다', () async {
      final repository = MockProfileRepository();

      await repository.submitBasicProfile(
        nickname: '달콤한 사탕 멜론',
        residence: const ResidenceCode(
          level1: '370',
          level2: '37080',
          level3: '37080412',
        ),
        height: 170,
        bodyType: '보통',
      );
      await repository.submitProfileDetails(
        mbti: 'ISFP',
        selfIntroduction: '안녕하세요.',
      );
      await repository.submitEducation(
        university: '한국대학교',
        educationLevel: '대학교',
      );
      await repository.verifyEducationEmail(email: 'sdfdd123@jnu.ac.kr');
      await repository.submitJob(company: '삼성전자', occupation: '전문직');
      await repository.verifyJobEmail(email: 'asd123@samsung.co.kr');
    });
  });

  group('ProfileRepositoryImpl', () {
    test('랜덤 닉네임을 조회한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/signup/nickname/random');
        return http.Response.bytes(
          utf8.encode('{"nickname":"달콤한 사탕 멜론"}'),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      final nickname = await repository.fetchRandomNickname();

      expect(nickname, '달콤한 사탕 멜론');
    });

    test('기본 프로필 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/signup/profile');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitBasicProfile(
        nickname: '달콤한 사탕 멜론',
        residence: const ResidenceCode(
          level1: '370',
          level2: '37080',
          level3: '37080412',
        ),
        height: 170,
        bodyType: '보통',
      );

      expect(body, {
        'nickname': '달콤한 사탕 멜론',
        'residence': {'level1': '370', 'level2': '37080', 'level3': '37080412'},
        'height': 170,
        'bodyType': '보통',
      });
    });

    test('세부 프로필 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/signup/profile/details');
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

      expect(body, {'MBTI': 'ISFP', 'selfIntroduction': '안녕하세요.'});
    });

    test('학교 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/users/profile/education');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitEducation(
        university: '한국대학교',
        educationLevel: '대학교',
      );

      expect(body, {'university': '한국대학교', 'educationLevel': '대학교'});
    });

    test('학교 이메일 인증을 요청한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.path,
          '/api/v1/users/profile/education/verification',
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

    test('회사 정보를 등록한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/users/profile/job');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = ProfileRepositoryImpl(
        client: client,
        baseUrl: baseUrl,
      );

      await repository.submitJob(company: '삼성전자', occupation: '전문직');

      expect(body, {'company': '삼성전자', 'occupation': '전문직'});
    });

    test('회사 이메일 인증을 요청한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/users/profile/job/verification');
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
