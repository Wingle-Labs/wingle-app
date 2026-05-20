import 'dart:convert';

import 'package:http/http.dart' as http;

import 'live_api_env.dart';

/// live API 호출용 HTTP 클라이언트.
class LiveApiClient {
  final http.Client _client;
  final String _baseUrl;
  final String? _accessToken;
  final String? _accountId;
  final String? _accountPassword;
  final String? _adminAccessToken;
  String? _resolvedAccessToken;
  Future<String>? _accessTokenFuture;

  LiveApiClient._({
    required http.Client client,
    required String baseUrl,
    String? accessToken,
    String? accountId,
    String? accountPassword,
    String? adminAccessToken,
  }) : _client = client,
       _baseUrl = baseUrl,
       _accessToken = accessToken == null ? null : _normalizeToken(accessToken),
       _accountId = accountId,
       _accountPassword = accountPassword,
       _adminAccessToken = adminAccessToken == null
           ? null
           : _normalizeToken(adminAccessToken);

  factory LiveApiClient.fromEnv({http.Client? client}) {
    final env = LiveApiEnv.load();
    final baseUrl = LiveApiEnv.get(LiveApiEnv.baseUrlKey);
    final accessToken = LiveApiEnv.get(LiveApiEnv.accessTokenKey);
    final accountId = LiveApiEnv.get(LiveApiEnv.accountIdKey);
    final accountPassword = LiveApiEnv.get(LiveApiEnv.accountPasswordKey);

    final hasStaticToken = accessToken != null;
    final hasAccountCredentials = accountId != null && accountPassword != null;

    if (baseUrl == null || (!hasStaticToken && !hasAccountCredentials)) {
      throw StateError(
        LiveApiEnv.missingConfigMessage([
          LiveApiEnv.baseUrlKey,
          if (!hasStaticToken) LiveApiEnv.accessTokenKey,
          if (!hasAccountCredentials) LiveApiEnv.accountIdKey,
          if (!hasAccountCredentials) LiveApiEnv.accountPasswordKey,
        ]),
      );
    }

    return LiveApiClient._(
      client: client ?? http.Client(),
      baseUrl: baseUrl,
      accessToken: accessToken,
      accountId: accountId,
      accountPassword: accountPassword,
      adminAccessToken:
          env[LiveApiEnv.adminAccessTokenKey]?.trim().isEmpty == true
          ? null
          : env[LiveApiEnv.adminAccessTokenKey]?.trim(),
    );
  }

  Uri uri(String path, [Map<String, dynamic>? queryParameters]) {
    return Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: queryParameters);
  }

  Future<LiveApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool admin = false,
    bool includeAuth = true,
    Map<String, String>? headers,
  }) async {
    final headersMap = await _headers(
      admin: admin,
      includeAuth: includeAuth,
      headers: headers,
    );
    final response = await _client.get(
      uri(path, queryParameters),
      headers: headersMap,
    );
    return LiveApiResponse.fromHttp(response);
  }

  Future<LiveApiResponse> post(
    String path, {
    Object? body,
    bool admin = false,
    bool includeAuth = true,
    Map<String, String>? headers,
  }) async {
    final headersMap = await _headers(
      admin: admin,
      includeAuth: includeAuth,
      headers: headers,
    );
    final response = await _client.post(
      uri(path),
      headers: headersMap,
      body: body == null ? null : jsonEncode(body),
    );
    return LiveApiResponse.fromHttp(response);
  }

  Future<LiveApiResponse> put(
    String path, {
    Object? body,
    bool admin = false,
    bool includeAuth = true,
    Map<String, String>? headers,
  }) async {
    final headersMap = await _headers(
      admin: admin,
      includeAuth: includeAuth,
      headers: headers,
    );
    final response = await _client.put(
      uri(path),
      headers: headersMap,
      body: body == null ? null : jsonEncode(body),
    );
    return LiveApiResponse.fromHttp(response);
  }

  Future<LiveApiResponse> delete(
    String path, {
    Object? body,
    bool admin = false,
    bool includeAuth = true,
    Map<String, String>? headers,
  }) async {
    final headersMap = await _headers(
      admin: admin,
      includeAuth: includeAuth,
      headers: headers,
    );
    final response = await _client.delete(
      uri(path),
      headers: headersMap,
      body: body == null ? null : jsonEncode(body),
    );
    return LiveApiResponse.fromHttp(response);
  }

  Future<Map<String, String>> _headers({
    required bool admin,
    required bool includeAuth,
    Map<String, String>? headers,
  }) async {
    final merged = <String, String>{'Accept': 'application/json'};
    if (includeAuth) {
      final token = await _resolveToken(admin: admin);
      merged['Authorization'] = 'Bearer $token';
    }
    if (headers != null) {
      merged.addAll(headers);
    }
    return merged;
  }

  static String _normalizeToken(String token) {
    final trimmed = token.trim();
    return trimmed.toLowerCase().startsWith('bearer ')
        ? trimmed.substring(7).trim()
        : trimmed;
  }

  Future<String> _resolveToken({required bool admin}) async {
    if (admin) {
      final adminToken = _adminAccessToken;
      if (adminToken != null) {
        return adminToken;
      }
    }

    final staticToken = _accessToken;
    if (staticToken != null) {
      return staticToken;
    }

    final resolvedToken = _resolvedAccessToken;
    if (resolvedToken != null) {
      return resolvedToken;
    }

    return _ensureAccessToken();
  }

  Future<String> _ensureAccessToken() {
    final staticToken = _accessToken;
    if (staticToken != null) {
      return Future.value(staticToken);
    }

    final cached = _resolvedAccessToken;
    if (cached != null) {
      return Future.value(cached);
    }

    final pending = _accessTokenFuture;
    if (pending != null) {
      return pending;
    }

    final accountId = _accountId;
    final accountPassword = _accountPassword;
    if (accountId == null || accountPassword == null) {
      throw StateError('계정 자격이 없어 access token을 생성할 수 없습니다.');
    }

    _accessTokenFuture = _client
        .post(
          uri('/api/v1/auth/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'phoneNumber': accountId,
            'password': accountPassword,
          }),
        )
        .then((response) {
          if (response.statusCode < 200 || response.statusCode >= 300) {
            throw StateError(
              '로그인에 실패했습니다. '
              'status=${response.statusCode}, body=${response.body}',
            );
          }

          final decoded = jsonDecode(response.body);
          if (decoded is! Map<String, dynamic>) {
            throw StateError('로그인 응답이 JSON 객체가 아닙니다.');
          }

          final accessToken = decoded['accessToken']?.toString().trim();
          if (accessToken == null || accessToken.isEmpty) {
            throw StateError('로그인 응답에 accessToken이 없습니다.');
          }

          _resolvedAccessToken = _normalizeToken(accessToken);
          return _resolvedAccessToken!;
        });

    return _accessTokenFuture!;
  }
}

/// HTTP 응답 래퍼.
class LiveApiResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  LiveApiResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  factory LiveApiResponse.fromHttp(http.Response response) {
    return LiveApiResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
    );
  }

  dynamic get decoded {
    if (body.isEmpty) {
      return null;
    }

    return jsonDecode(body);
  }
}
