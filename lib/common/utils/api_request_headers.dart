import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';

/// API 요청 헤더를 생성하는 유틸리티.
class ApiRequestHeaders {
  /// JSON content-type 값
  static const String jsonContentType = 'application/json';

  /// content-type 헤더 키
  static const String contentTypeHeader = 'Content-Type';

  /// authorization 헤더 키
  static const String authorizationHeader = 'Authorization';

  /// Bearer prefix
  static const String bearerPrefix = 'Bearer ';

  /// 생성자 방지
  const ApiRequestHeaders._();

  /// JSON 요청 헤더를 생성한다.
  static Map<String, String> json({bool includeAuth = false}) {
    final headers = <String, String>{contentTypeHeader: jsonContentType};

    if (includeAuth) {
      headers.addAll(auth());
    }

    return headers;
  }

  /// Authorization 헤더만 생성한다.
  static Map<String, String> auth() {
    try {
      final accessToken = HiveUtil.read(HiveLoginBox.accessToken);

      if (accessToken == null) {
        return const <String, String>{};
      }

      final token = accessToken.trim();
      if (token.isEmpty) {
        return const <String, String>{};
      }

      return bearer(token);
    } catch (_) {
      return const <String, String>{};
    }
  }

  /// 주어진 토큰으로 Bearer Authorization 헤더를 생성한다.
  static Map<String, String> bearer(String token) {
    final normalized = _normalizeBearerToken(token);
    if (normalized == null) {
      return const <String, String>{};
    }

    return {authorizationHeader: normalized};
  }

  static String? _normalizeBearerToken(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (trimmed.startsWith(bearerPrefix)) {
      return trimmed;
    }

    return '$bearerPrefix$trimmed';
  }
}
