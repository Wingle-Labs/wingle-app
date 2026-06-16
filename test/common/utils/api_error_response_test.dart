import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/common/utils/api_error_response.dart';

void main() {
  group('apiErrorMessageFromResponse', () {
    test('JSON message 필드를 fallback보다 우선한다', () {
      final response = http.Response.bytes(
        utf8.encode('{"message":"서버 검증 실패"}'),
        400,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );

      expect(
        apiErrorMessageFromResponse(response, fallbackMessage: 'fallback'),
        '서버 검증 실패',
      );
    });

    test('message가 없으면 fallback을 반환한다', () {
      final response = http.Response('{}', 400);

      expect(
        apiErrorMessageFromResponse(response, fallbackMessage: 'fallback'),
        'fallback',
      );
    });
  });
}
