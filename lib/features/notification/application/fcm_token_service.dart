import 'dart:async';

import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

/// FCM 권한 요청 함수.
typedef FcmPermissionRequester = Future<void> Function();

/// 현재 FCM 토큰 조회 함수.
typedef FcmTokenReader = Future<String?> Function();

/// FCM 토큰 갱신 스트림.
typedef FcmTokenRefreshStream = Stream<String>;

/// FCM 토큰 등록과 갱신 이벤트 구독을 담당한다.
class FcmTokenService {
  final FcmTokenRepository _repository;
  final FcmPermissionRequester _requestPermission;
  final FcmTokenReader _readToken;
  final FcmTokenRefreshStream _tokenRefreshStream;
  final void Function(String message) _logger;

  StreamSubscription<String>? _tokenRefreshSubscription;

  /// 생성자.
  FcmTokenService({
    required FcmTokenRepository repository,
    required FcmPermissionRequester requestPermission,
    required FcmTokenReader readToken,
    required FcmTokenRefreshStream tokenRefreshStream,
    required void Function(String message) logger,
  }) : _repository = repository,
       _requestPermission = requestPermission,
       _readToken = readToken,
       _tokenRefreshStream = tokenRefreshStream,
       _logger = logger;

  /// 현재 디바이스 FCM 토큰을 발급받아 서버에 등록한다.
  Future<void> registerCurrentToken() async {
    try {
      await _requestPermission();
      final token = await _readToken();
      await _registerTokenIfPresent(token);
    } catch (error, stackTrace) {
      _logger(
        '[FCM] token registration skipped: $error\n'
        '[FCM] stackTrace: $stackTrace',
      );
    }
  }

  /// FCM 토큰 refresh 이벤트를 서버 등록으로 연결한다.
  void startTokenRefreshListener() {
    if (_tokenRefreshSubscription != null) {
      return;
    }

    _tokenRefreshSubscription = _tokenRefreshStream.listen(
      (token) => unawaited(_registerTokenIfPresent(token)),
      onError: (Object error, StackTrace stackTrace) {
        _logger(
          '[FCM] token refresh listener error: $error\n'
          '[FCM] stackTrace: $stackTrace',
        );
      },
    );
  }

  /// 리소스를 정리한다.
  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }

  Future<void> _registerTokenIfPresent(String? token) async {
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) {
      _logger('[FCM] token registration skipped: empty token');
      return;
    }

    try {
      await _repository.registerToken(token: normalizedToken);
      _logger('[FCM] token registered');
    } catch (error, stackTrace) {
      _logger(
        '[FCM] token registration failed: $error\n'
        '[FCM] stackTrace: $stackTrace',
      );
    }
  }
}
