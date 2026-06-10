import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/notification/application/fcm_token_service.dart';
import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

void main() {
  test('현재 FCM 토큰을 읽어 서버에 등록한다', () async {
    final repository = _RecordingFcmTokenRepository();
    var permissionRequested = false;
    final service = FcmTokenService(
      repository: repository,
      requestPermission: () async {
        permissionRequested = true;
      },
      readToken: () async => ' fcm-token ',
      tokenRefreshStream: const Stream<String>.empty(),
      logger: (_) {},
    );

    await service.registerCurrentToken();

    expect(permissionRequested, isTrue);
    expect(repository.tokens, ['fcm-token']);
  });

  test('빈 FCM 토큰은 등록하지 않는다', () async {
    final repository = _RecordingFcmTokenRepository();
    final service = FcmTokenService(
      repository: repository,
      requestPermission: () async {},
      readToken: () async => ' ',
      tokenRefreshStream: const Stream<String>.empty(),
      logger: (_) {},
    );

    await service.registerCurrentToken();

    expect(repository.tokens, isEmpty);
  });

  test('FCM 토큰 refresh 이벤트를 서버에 등록한다', () async {
    final repository = _RecordingFcmTokenRepository();
    final refreshController = StreamController<String>();
    final service = FcmTokenService(
      repository: repository,
      requestPermission: () async {},
      readToken: () async => null,
      tokenRefreshStream: refreshController.stream,
      logger: (_) {},
    );
    addTearDown(refreshController.close);
    addTearDown(service.dispose);

    service.startTokenRefreshListener();
    refreshController.add(' refreshed-token ');
    await Future<void>.delayed(Duration.zero);

    expect(repository.tokens, ['refreshed-token']);
  });
}

class _RecordingFcmTokenRepository implements FcmTokenRepository {
  final List<String> tokens = <String>[];

  @override
  Future<void> registerToken({required String token}) async {
    tokens.add(token.trim());
  }
}
