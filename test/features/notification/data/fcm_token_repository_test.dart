import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/notification/data/fcm_token_repository_impl.dart';

void main() {
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

  test('FCM 토큰을 서버에 등록한다', () async {
    await HiveUtil.write(key: HiveLoginBox.accessToken, value: 'access-token');
    late Map<String, dynamic> body;

    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/notifications/token');
      expect(request.headers['Content-Type'], contains('application/json'));
      expect(request.headers['Authorization'], 'Bearer access-token');
      body = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('', 200);
    });

    final repository = FcmTokenRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    await repository.registerToken(token: ' fcm-token ');

    expect(body, {'token': 'fcm-token'});
  });

  test('빈 토큰은 서버에 등록하지 않는다', () async {
    final client = MockClient((_) async {
      fail('empty FCM token should not hit network');
    });

    final repository = FcmTokenRepositoryImpl(
      client: client,
      baseUrl: 'https://api.example.com',
    );

    expect(() => repository.registerToken(token: '   '), throwsException);
  });
}
