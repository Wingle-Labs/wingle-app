import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/auth_token.dart';

/// 401 응답 시 refresh token으로 토큰을 재발급하고 원 요청을 1회 재시도한다.
class AuthenticatedApiClient extends http.BaseClient {
  final http.Client _inner;
  final String _baseUrl;

  /// 생성자
  AuthenticatedApiClient({required http.Client inner, required String baseUrl})
    : _inner = inner,
      _baseUrl = baseUrl;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final retryRequest = _cloneRequest(request);
    final response = await _inner.send(request);

    if (response.statusCode != 401 ||
        retryRequest == null ||
        !_hasBearerAuth(retryRequest) ||
        _isReissueRequest(retryRequest)) {
      return response;
    }

    final originalBody = await response.stream.toBytes();
    final refreshed = await _refreshToken();

    if (!refreshed) {
      return _rebuildResponse(response, originalBody);
    }

    retryRequest.headers
      ..remove(ApiRequestHeaders.authorizationHeader)
      ..addAll(ApiRequestHeaders.auth());

    return _inner.send(retryRequest);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  http.BaseRequest? _cloneRequest(http.BaseRequest request) {
    if (request is! http.Request) {
      return null;
    }

    final clone = http.Request(request.method, request.url)
      ..bodyBytes = request.bodyBytes
      ..encoding = request.encoding
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..persistentConnection = request.persistentConnection;

    clone.headers.addAll(request.headers);
    return clone;
  }

  bool _hasBearerAuth(http.BaseRequest request) {
    final auth = request.headers[ApiRequestHeaders.authorizationHeader] ?? '';
    return auth.startsWith(ApiRequestHeaders.bearerPrefix);
  }

  bool _isReissueRequest(http.BaseRequest request) {
    return request.url.path == ApiEndpoints.authReissue;
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = HiveUtil.read(HiveLoginBox.refreshToken)?.trim();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _inner.post(
        Uri.parse('$_baseUrl${ApiEndpoints.authReissue}'),
        headers: {ApiRequestHeaders.authorizationHeader: refreshToken},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final token = AuthToken.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      if (token.accessToken.isEmpty || token.refreshToken.isEmpty) {
        return false;
      }

      await HiveUtil.write(
        key: HiveLoginBox.accessToken,
        value: token.accessToken,
      );
      await HiveUtil.write(
        key: HiveLoginBox.refreshToken,
        value: token.refreshToken,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  http.StreamedResponse _rebuildResponse(
    http.StreamedResponse response,
    List<int> body,
  ) {
    return http.StreamedResponse(
      Stream<List<int>>.value(body),
      response.statusCode,
      contentLength: body.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
