import 'package:flutter_test/flutter_test.dart';

/// live API 응답 공통 assertion.
class LiveApiAssertions {
  LiveApiAssertions._();

  static void expectStatus(
    int actual, [
    int? expected,
    Iterable<int> allowed = const [],
  ]) {
    if (expected != null) {
      expect(actual, expected);
      return;
    }

    expect(allowed, isNotEmpty);
    expect(allowed.contains(actual), isTrue);
  }

  static Map<String, dynamic> expectJsonMap(dynamic decoded) {
    expect(decoded, isA<Map>());
    return Map<String, dynamic>.from(decoded as Map);
  }

  static List<dynamic> expectJsonList(dynamic decoded) {
    expect(decoded, isA<List>());
    return decoded as List<dynamic>;
  }

  static String expectNonEmptyString(dynamic value) {
    expect(value, isA<String>());
    expect((value as String).trim(), isNotEmpty);
    return value;
  }

  static int expectInt(dynamic value) {
    expect(value, isA<num>());
    return (value as num).toInt();
  }

  static Map<String, dynamic> expectObjectField(
    Map<String, dynamic> json,
    String key,
  ) {
    expect(json.containsKey(key), isTrue, reason: 'missing field: $key');
    final value = json[key];
    expect(value, isA<Map>());
    return Map<String, dynamic>.from(value as Map);
  }

  static List<dynamic> expectListField(Map<String, dynamic> json, String key) {
    expect(json.containsKey(key), isTrue, reason: 'missing field: $key');
    final value = json[key];
    expect(value, isA<List>());
    return value as List<dynamic>;
  }
}
