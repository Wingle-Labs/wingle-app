import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/constants/api_paths.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/api_request_headers.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/auth/domain/models/auth_token.dart';

/// API 응답 로그를 출력하는 콜백.
typedef ApiResponseLogger = void Function(String message);

/// 401 응답 시 refresh token으로 토큰을 재발급하고 원 요청을 1회 재시도한다.
class AuthenticatedApiClient extends http.BaseClient {
  final http.Client _inner;
  final String _baseUrl;
  final bool _enableResponseLogging;
  final ApiResponseLogger _logger;
  final String _requestSourceLabel;

  /// 생성자
  AuthenticatedApiClient({
    required http.Client inner,
    required String baseUrl,
    bool enableResponseLogging = !kReleaseMode,
    ApiResponseLogger? logger,
    String? requestSourceLabel,
  }) : _inner = inner,
       _baseUrl = baseUrl,
       _enableResponseLogging = enableResponseLogging,
       _logger = logger ?? debugPrint,
       _requestSourceLabel = requestSourceLabel ?? _resolveRequestSourceLabel();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final retryRequest = _cloneRequest(request);
    _logRequest(request);
    final response = await _inner.send(request);
    final responseBody = await response.stream.toBytes();
    _logStreamedResponse(request, response, responseBody);
    final rebuiltResponse = _rebuildResponse(response, responseBody);

    if (response.statusCode != 401 ||
        retryRequest == null ||
        !_hasBearerAuth(retryRequest) ||
        _isReissueRequest(retryRequest)) {
      return rebuiltResponse;
    }

    final refreshed = await _refreshToken();

    if (!refreshed) {
      return rebuiltResponse;
    }

    retryRequest.headers
      ..remove(ApiRequestHeaders.authorizationHeader)
      ..addAll(ApiRequestHeaders.auth());

    _logRequest(retryRequest);
    final retryResponse = await _inner.send(retryRequest);
    final retryResponseBody = await retryResponse.stream.toBytes();
    _logStreamedResponse(retryRequest, retryResponse, retryResponseBody);

    return _rebuildResponse(retryResponse, retryResponseBody);
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

      final uri = Uri.parse('$_baseUrl${ApiEndpoints.authReissue}');
      _logRequestDetails(
        method: 'POST',
        uri: uri,
        headers: {ApiRequestHeaders.authorizationHeader: refreshToken},
        body: '',
      );
      final response = await _inner.post(
        uri,
        headers: {ApiRequestHeaders.authorizationHeader: refreshToken},
      );
      _logResponse(method: 'POST', uri: uri, response: response);

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

  void _logRequest(http.BaseRequest request) {
    _logRequestDetails(
      method: request.method,
      uri: request.url,
      headers: request.headers,
      body: _requestBody(request),
    );
  }

  void _logRequestDetails({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) {
    if (!_enableResponseLogging) {
      return;
    }

    final formattedHeaders = jsonEncode(_redactSensitiveValues(headers));
    final formattedBody = _formatLogBody(body);
    _logger(
      '[API] request: $method $uri\n'
      '[API] source: $_requestSourceLabel\n'
      '[API] request headers: $formattedHeaders\n'
      '[API] request body: $formattedBody\n',
    );
  }

  String _requestBody(http.BaseRequest request) {
    if (request is http.Request) {
      return utf8.decode(request.bodyBytes, allowMalformed: true);
    }

    return '<unavailable>';
  }

  void _logStreamedResponse(
    http.BaseRequest request,
    http.StreamedResponse response,
    List<int> body,
  ) {
    _logResponseBody(
      method: request.method,
      uri: request.url,
      statusCode: response.statusCode,
      body: utf8.decode(body, allowMalformed: true),
    );
  }

  void _logResponse({
    required String method,
    required Uri uri,
    required http.Response response,
  }) {
    _logResponseBody(
      method: method,
      uri: uri,
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  void _logResponseBody({
    required String method,
    required Uri uri,
    required int statusCode,
    required String body,
  }) {
    if (!_enableResponseLogging) {
      return;
    }

    final formattedBody = _formatLogBody(body);
    _logger(
      '[API] $method $uri -> $statusCode\n[API] response: $formattedBody\n',
    );
  }

  static String _resolveRequestSourceLabel() {
    return RepositorySelector.selectionLabel(isApiReady: true);
  }

  String _formatLogBody(String body) {
    if (body.isEmpty) {
      return '<empty>';
    }

    try {
      final decoded = jsonDecode(body);
      return jsonEncode(_redactSensitiveValues(decoded));
    } catch (_) {
      return body;
    }
  }

  Object? _redactSensitiveValues(Object? value) {
    if (value is Map) {
      return value.map((key, nestedValue) {
        final keyText = key.toString();
        final normalizedKey = keyText.toLowerCase();
        final shouldRedact =
            normalizedKey.contains('token') ||
            normalizedKey.contains('authorization') ||
            normalizedKey.contains('password');

        return MapEntry(
          keyText,
          shouldRedact ? '<redacted>' : _redactSensitiveValues(nestedValue),
        );
      });
    }

    if (value is List) {
      return value.map(_redactSensitiveValues).toList(growable: false);
    }

    return value;
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
