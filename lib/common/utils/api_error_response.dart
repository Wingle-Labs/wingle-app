import 'dart:convert';

import 'package:http/http.dart' as http;

/// HTTP API 오류 응답에서 사용자에게 보여줄 수 있는 메시지를 추출한다.
String apiErrorMessageFromResponse(
  http.Response response, {
  required String fallbackMessage,
}) {
  final body = utf8.decode(response.bodyBytes, allowMalformed: true).trim();
  if (body.isEmpty) {
    return fallbackMessage;
  }

  try {
    final decoded = jsonDecode(body);
    if (decoded is Map) {
      final message = _nonEmptyString(decoded['message']);
      if (message != null) {
        return message;
      }

      final error = _nonEmptyString(decoded['error']);
      if (error != null) {
        return error;
      }

      final detail = _nonEmptyString(decoded['detail']);
      if (detail != null) {
        return detail;
      }
    }
  } catch (_) {
    final plainText = _nonEmptyString(body);
    if (plainText != null) {
      return plainText;
    }
  }

  return fallbackMessage;
}

/// HTTP API 오류 응답에서 추출한 메시지로 [Exception]을 만든다.
Exception apiExceptionFromResponse(
  http.Response response, {
  required String fallbackMessage,
}) {
  return Exception(
    apiErrorMessageFromResponse(response, fallbackMessage: fallbackMessage),
  );
}

String? _nonEmptyString(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
