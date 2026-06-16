import 'dart:async';

import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

/// FCM 권한 요청 함수.
typedef FcmPermissionRequester = Future<void> Function();

/// 현재 FCM 토큰 조회 함수.
typedef FcmTokenReader = Future<String?> Function();

/// FCM 토큰 갱신 스트림.
typedef FcmTokenRefreshStream = Stream<String>;

/// FCM 메시지 data 스트림.
typedef FcmMessageDataStream = Stream<Map<String, dynamic>>;

/// 앱 시작 시 전달된 FCM 메시지 data 조회 함수.
typedef FcmInitialMessageDataReader = Future<Map<String, dynamic>?> Function();

/// 프로필 심사 결과 push 수신 콜백.
typedef ProfileReviewResultHandler = Future<void> Function();

/// FCM 토큰 등록과 갱신 이벤트 구독을 담당한다.
class FcmTokenService {
  static const String _profileReviewResultEventType = 'PROFILE_REVIEW_RESULT';
  static const Set<String> _profileReviewResultStatuses = {
    'APPROVED',
    'REJECTED',
  };

  final FcmTokenRepository _repository;
  final FcmPermissionRequester _requestPermission;
  final FcmTokenReader _readToken;
  final FcmTokenRefreshStream _tokenRefreshStream;
  final FcmMessageDataStream _foregroundMessageDataStream;
  final FcmMessageDataStream _openedAppMessageDataStream;
  final FcmInitialMessageDataReader _readInitialMessageData;
  final ProfileReviewResultHandler _handleProfileReviewResult;
  final void Function(String message) _logger;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<Map<String, dynamic>>? _foregroundMessageSubscription;
  StreamSubscription<Map<String, dynamic>>? _openedAppMessageSubscription;

  /// 생성자.
  FcmTokenService({
    required FcmTokenRepository repository,
    required FcmPermissionRequester requestPermission,
    required FcmTokenReader readToken,
    required FcmTokenRefreshStream tokenRefreshStream,
    FcmMessageDataStream foregroundMessageDataStream =
        const Stream<Map<String, dynamic>>.empty(),
    FcmMessageDataStream openedAppMessageDataStream =
        const Stream<Map<String, dynamic>>.empty(),
    FcmInitialMessageDataReader? readInitialMessageData,
    ProfileReviewResultHandler? handleProfileReviewResult,
    required void Function(String message) logger,
  }) : _repository = repository,
       _requestPermission = requestPermission,
       _readToken = readToken,
       _tokenRefreshStream = tokenRefreshStream,
       _foregroundMessageDataStream = foregroundMessageDataStream,
       _openedAppMessageDataStream = openedAppMessageDataStream,
       _readInitialMessageData = readInitialMessageData ?? (() async => null),
       _handleProfileReviewResult = handleProfileReviewResult ?? (() async {}),
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

  /// 프로필 승인/반려 push 이벤트를 서버 상태 동기화로 연결한다.
  void startProfileReviewResultListener() {
    if (_foregroundMessageSubscription != null ||
        _openedAppMessageSubscription != null) {
      return;
    }

    unawaited(_handleMessageDataFromInitialMessage());
    _foregroundMessageSubscription = _foregroundMessageDataStream.listen(
      (data) => unawaited(_handleMessageData(data)),
      onError: _logMessageListenerError,
    );
    _openedAppMessageSubscription = _openedAppMessageDataStream.listen(
      (data) => unawaited(_handleMessageData(data)),
      onError: _logMessageListenerError,
    );
  }

  /// 리소스를 정리한다.
  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
    await _openedAppMessageSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _foregroundMessageSubscription = null;
    _openedAppMessageSubscription = null;
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

  Future<void> _handleMessageDataFromInitialMessage() async {
    try {
      final data = await _readInitialMessageData();
      if (data == null) return;

      await _handleMessageData(data);
    } catch (error, stackTrace) {
      _logger(
        '[FCM] initial message handling failed: $error\n'
        '[FCM] stackTrace: $stackTrace',
      );
    }
  }

  Future<void> _handleMessageData(Map<String, dynamic> data) async {
    if (!_isProfileReviewResultData(data)) {
      return;
    }

    try {
      await _handleProfileReviewResult();
      _logger('[FCM] profile review result handled');
    } catch (error, stackTrace) {
      _logger(
        '[FCM] profile review result handling failed: $error\n'
        '[FCM] stackTrace: $stackTrace',
      );
    }
  }

  bool _isProfileReviewResultData(Map<String, dynamic> data) {
    final eventType = data['eventType']?.toString().trim().toUpperCase();
    final status = data['status']?.toString().trim().toUpperCase();
    return eventType == _profileReviewResultEventType &&
        _profileReviewResultStatuses.contains(status);
  }

  void _logMessageListenerError(Object error, StackTrace stackTrace) {
    _logger(
      '[FCM] message listener error: $error\n'
      '[FCM] stackTrace: $stackTrace',
    );
  }
}
