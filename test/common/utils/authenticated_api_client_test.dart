import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/hive_util.dart';

void main() {
  const baseUrl = 'https://api.example.com';
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('401 응답이면 토큰을 재발급하고 원 요청을 1회 재시도한다', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'old-access');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'old-refresh');

    var protectedRequestCount = 0;

    final inner = MockClient((request) async {
      if (request.url.path == '/api/v1/auth/reissue') {
        expect(request.headers['Authorization'], 'old-refresh');
        return http.Response(
          jsonEncode({
            'accessToken': 'new-access',
            'refreshToken': 'new-refresh',
          }),
          200,
        );
      }

      protectedRequestCount += 1;
      if (protectedRequestCount == 1) {
        expect(request.headers['Authorization'], 'Bearer old-access');
        return http.Response('expired', 401);
      }

      expect(request.headers['Authorization'], 'Bearer new-access');
      return http.Response('ok', 200);
    });

    final client = AuthenticatedApiClient(inner: inner, baseUrl: baseUrl);

    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/profiles/rejection-reason'),
      headers: ApiRequestHeaders.auth(),
    );

    expect(response.statusCode, 200);
    expect(response.body, 'ok');
    expect(protectedRequestCount, 2);
    expect(HiveUtil.read(HiveLoginBox.accessToken), 'new-access');
    expect(HiveUtil.read(HiveLoginBox.refreshToken), 'new-refresh');
  });

  test('refresh token이 없으면 401 원 응답을 유지한다', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'old-access');

    final inner = MockClient((request) async {
      return http.Response('expired', 401);
    });

    final client = AuthenticatedApiClient(inner: inner, baseUrl: baseUrl);

    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/profiles/rejection-reason'),
      headers: ApiRequestHeaders.auth(),
    );

    expect(response.statusCode, 401);
    expect(response.body, 'expired');
  });
}
