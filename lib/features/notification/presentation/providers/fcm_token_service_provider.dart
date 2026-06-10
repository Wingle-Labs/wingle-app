import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/notification/application/fcm_token_service.dart';
import 'package:wingle/features/notification/presentation/providers/fcm_token_repository_provider.dart';

part 'fcm_token_service_provider.g.dart';

/// FCM 토큰 등록 서비스를 제공한다.
@Riverpod(keepAlive: true)
FcmTokenService fcmTokenService(Ref ref) {
  final repository = ref.watch(fcmTokenRepositoryProvider);
  final source = RepositorySelector.currentSource();

  if (source == RepositorySource.mock) {
    return FcmTokenService(
      repository: repository,
      requestPermission: () async {},
      readToken: () async => null,
      tokenRefreshStream: const Stream<String>.empty(),
      logger: debugPrint,
    );
  }

  final messaging = FirebaseMessaging.instance;
  final service = FcmTokenService(
    repository: repository,
    requestPermission: () async {
      await messaging.requestPermission(alert: true, badge: true, sound: true);
    },
    readToken: messaging.getToken,
    tokenRefreshStream: messaging.onTokenRefresh,
    logger: debugPrint,
  );

  ref.onDispose(() {
    unawaited(service.dispose());
  });

  return service;
}
