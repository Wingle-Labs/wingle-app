import 'package:wingle/features/notification/domain/repository/fcm_token_repository.dart';

/// FCM 디바이스 토큰 등록 mock 구현체.
class MockFcmTokenRepository implements FcmTokenRepository {
  /// 등록된 토큰 목록.
  final List<String> registeredTokens = <String>[];

  /// 생성자.
  MockFcmTokenRepository();

  @override
  Future<void> registerToken({required String token}) async {
    registeredTokens.add(token.trim());
  }
}
