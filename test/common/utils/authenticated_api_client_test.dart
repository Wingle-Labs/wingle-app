import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/common/utils/auth_session_state.dart';
import 'package:wingle/common/utils/authenticated_api_client.dart';
import 'package:wingle/common/utils/hive_util.dart';

void main() {
  const baseUrl = 'https://api.example.com';
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    await HiveUtil.initialize(HiveAesCipher(Hive.generateSecureKey()));
    AuthSessionState.notifyChanged();
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
        expect(request.headers['Authorization'], 'Bearer old-refresh');
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

  test('400 유효하지 않은 토큰 응답이면 토큰을 재발급하고 원 요청을 1회 재시도한다', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'old-access');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'old-refresh');

    var protectedRequestCount = 0;

    final inner = MockClient((request) async {
      if (request.url.path == '/api/v1/auth/reissue') {
        expect(request.headers['Authorization'], 'Bearer old-refresh');
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
        return http.Response.bytes(
          utf8.encode(jsonEncode({'message': '유효하지 않은 토큰입니다'})),
          400,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }

      expect(request.headers['Authorization'], 'Bearer new-access');
      return http.Response('ok', 200);
    });

    final client = AuthenticatedApiClient(inner: inner, baseUrl: baseUrl);

    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/auth/signup/profile'),
      headers: ApiRequestHeaders.json(includeAuth: true),
      body: jsonEncode({
        'nickname': '닉네임',
        'residenceCode': 'R_11110720',
        'height': 170,
        'bodyTypeCode': 'BT_M_001',
      }),
    );

    expect(response.statusCode, 200);
    expect(response.body, 'ok');
    expect(protectedRequestCount, 2);
    expect(HiveUtil.read(HiveLoginBox.accessToken), 'new-access');
    expect(HiveUtil.read(HiveLoginBox.refreshToken), 'new-refresh');
  });

  test('refresh token이 없으면 로그인 정보를 지우고 401 원 응답을 유지한다', () async {
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
    expect(HiveUtil.read(HiveLoginBox.accessToken), isNull);
    expect(AuthSessionState.shouldRedirectToLogin, isTrue);
  });

  test('refresh token이 무효하면 로그인 정보를 지우고 401 원 응답을 유지한다', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'old-access');
    await HiveUtil.write(key: HiveLoginBox.refreshToken, value: 'bad-refresh');
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: 'BASIC_INFO_COMPLETED',
    );

    final inner = MockClient((request) async {
      if (request.url.path == '/api/v1/auth/reissue') {
        expect(request.headers['Authorization'], 'Bearer bad-refresh');
        return http.Response.bytes(
          utf8.encode(jsonEncode({'message': '유효하지 않은 토큰입니다'})),
          400,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }

      return http.Response('expired', 401);
    });

    final client = AuthenticatedApiClient(inner: inner, baseUrl: baseUrl);

    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/profiles/rejection-reason'),
      headers: ApiRequestHeaders.auth(),
    );

    expect(response.statusCode, 401);
    expect(response.body, 'expired');
    expect(HiveUtil.read(HiveLoginBox.accessToken), isNull);
    expect(HiveUtil.read(HiveLoginBox.refreshToken), isNull);
    expect(HiveUtil.read(HiveLoginBox.profileStatus), isNull);
    expect(AuthSessionState.shouldRedirectToLogin, isTrue);
  });

  test('비프로덕션 API 로깅은 request와 response를 출력하고 민감값은 마스킹한다', () async {
    final logs = <String>[];
    final inner = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'accessToken': 'secret-access',
          'refreshToken': 'secret-refresh',
          'profileStatus': 'APPROVED',
        }),
        200,
      );
    });

    final client = AuthenticatedApiClient(
      inner: inner,
      baseUrl: baseUrl,
      logger: logs.add,
      requestSourceLabel: 'LIVE (API_SOURCE=LIVE, isApiReady=true)',
    );

    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {
        ApiRequestHeaders.authorizationHeader: 'Bearer secret-access',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phoneNumber': '01000000000',
        'password': 'secret-password',
      }),
    );

    expect(response.statusCode, 200);
    expect(response.body, contains('APPROVED'));
    expect(logs, hasLength(2));
    expect(
      logs.first,
      contains('[API] request: POST $baseUrl/api/v1/auth/login'),
    );
    expect(
      logs.first,
      contains('[API] source: LIVE (API_SOURCE=LIVE, isApiReady=true)'),
    );
    expect(logs.first, contains('"Authorization":"<redacted>"'));
    expect(logs.first, contains('"password":"<redacted>"'));
    expect(logs.first, contains('"phoneNumber":"01000000000"'));
    expect(logs.first, endsWith('\n'));
    expect(logs.last, contains('[API] POST $baseUrl/api/v1/auth/login -> 200'));
    expect(logs.last, contains('"accessToken":"<redacted>"'));
    expect(logs.last, contains('"refreshToken":"<redacted>"'));
    expect(logs.last, endsWith('\n'));
    expect(logs.join('\n'), isNot(contains('secret-access')));
    expect(logs.join('\n'), isNot(contains('secret-refresh')));
    expect(logs.join('\n'), isNot(contains('secret-password')));
  });

  test('비프로덕션 API 로깅은 바이너리 request body를 문자열로 출력하지 않는다', () async {
    final logs = <String>[];
    final inner = MockClient((request) async {
      return http.Response('', 200);
    });

    final client = AuthenticatedApiClient(
      inner: inner,
      baseUrl: baseUrl,
      logger: logs.add,
      requestSourceLabel: 'LIVE (API_SOURCE=LIVE, isApiReady=true)',
    );

    final response = await client.put(
      Uri.parse('https://mock-upload.example.com/file'),
      headers: {ApiRequestHeaders.contentTypeHeader: 'image/png'},
      body: const [0, 159, 146, 150],
    );

    expect(response.statusCode, 200);
    expect(logs.first, contains('<binary body: 4 bytes'));
    expect(logs.first, contains('content-type: image/png'));
    expect(logs.join('\n'), isNot(contains('���')));
  });

  test('응답 로깅이 꺼져 있으면 로그를 출력하지 않는다', () async {
    final logs = <String>[];
    final inner = MockClient((request) async {
      return http.Response('ok', 200);
    });

    final client = AuthenticatedApiClient(
      inner: inner,
      baseUrl: baseUrl,
      enableResponseLogging: false,
      logger: logs.add,
    );

    final response = await client.get(Uri.parse('$baseUrl/api/v1/healthcheck'));

    expect(response.statusCode, 200);
    expect(response.body, 'ok');
    expect(logs, isEmpty);
  });
}
