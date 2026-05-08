import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/onboarding/data/mock/mock_signup_repository.dart';
import 'package:wingle/features/onboarding/data/signup_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_gender.dart';
import 'package:wingle/features/onboarding/domain/constants/pass_operator.dart';
import 'package:wingle/features/onboarding/domain/model/pass/portone_verified_customer_dto.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('MockSignupRepository', () {
    test('비밀번호 등록과 본인인증 등록이 모두 완료된다', () async {
      final repository = MockSignupRepository();

      await repository.submitPassword(
        uuid: 'device-uuid',
        password: '!abc1234',
      );
      await repository.submitIdentityVerification(
        uuid: 'device-uuid',
        user: PortoneVerifiedCustomerDto(
          name: '김민수',
          phoneNumber: '010-1234-5678',
          operator: PassOperator.skt,
          birthDate: DateTime(2001, 1, 1),
          gender: PassGender.male,
          isForeigner: false,
          ci: 'CI123',
          di: 'DI123',
        ),
        age: 26,
        impUid: 'imp_123',
      );
    });
  });

  group('SignupRepositoryImpl', () {
    test('submitPassword는 UUID 대문자 키로 요청한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/auth/signup/password');

        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = SignupRepositoryImpl(client: client, baseUrl: baseUrl);

      await repository.submitPassword(
        uuid: 'device-uuid',
        password: '!abc1234',
      );

      expect(body, {'password': '!abc1234', 'UUID': 'device-uuid'});
    });

    test('submitIdentityVerification은 명세에 맞는 본문을 전송한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/auth/signup/identity-verification');

        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response('', 200);
      });

      final repository = SignupRepositoryImpl(client: client, baseUrl: baseUrl);

      final user = PortoneVerifiedCustomerDto(
        name: '김민수',
        phoneNumber: '010-1234-5678',
        operator: PassOperator.skt,
        birthDate: DateTime(2001, 1, 1),
        gender: PassGender.male,
        isForeigner: false,
        ci: 'CI123',
        di: 'DI123',
      );

      await repository.submitIdentityVerification(
        uuid: 'device-uuid',
        user: user,
        age: 26,
        impUid: 'imp_123',
      );

      expect(body, {
        'name': '김민수',
        'isForeigner': false,
        'phoneNumber': '010-1234-5678',
        'CI': 'CI123',
        'gender': '남',
        'UUID': 'device-uuid',
        'age': 26,
        'birth': '2001-01-01',
      });
    });
  });
}
