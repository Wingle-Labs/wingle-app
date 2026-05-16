import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/features/auth/data/repositories/login_repository_impl.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

void main() {
  const baseUrl = 'https://api.example.com';

  group('LoginRepositoryImpl', () {
    test('로그인은 Swagger 경로와 본문을 사용한다', () async {
      late Map<String, dynamic> body;

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/auth/login');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
            'onboardingStatus': 'FIRST_APPROVAL_PENDING',
          }),
          200,
        );
      });

      final repository = LoginRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.login(
        phoneNumber: PhoneNumber('010-9256-6504'),
        password: Password('Password1!'),
      );

      expect(body, {'phoneNumber': '010-9256-6504', 'password': 'Password1!'});
      expect(result.accessToken, 'access-token');
    });

    test('토큰을 재발급한다', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/auth/reissue');
        expect(request.headers['Authorization'], 'refresh-token');
        return http.Response(
          jsonEncode({
            'accessToken': 'new-access-token',
            'refreshToken': 'new-refresh-token',
          }),
          200,
        );
      });

      final repository = LoginRepositoryImpl(client: client, baseUrl: baseUrl);

      final result = await repository.reissue(refreshToken: 'refresh-token');

      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
    });
  });
}
