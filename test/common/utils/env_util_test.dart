import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/env_constants.dart';
import 'package:wingle/common/utils/env_util.dart';

void main() {
  final testEnvKey = EnvKey<String>(path: "", name: "TEST_KEY");
  final boolTrueEnvKey = EnvKey<String>(path: "", name: "BOOL_TRUE");
  final boolFalseEnvKey = EnvKey<String>(path: "", name: "BOOL_FALSE");
  final intValueEnvKey = EnvKey<String>(path: "", name: "INT_VALUE");
  final emptyValueEnvKey = EnvKey<String>(path: "", name: "EMPTY_VALUE");

  final unknownEnvKey = EnvKey<String>(path: "", name: "UNKNOWN_KEY");

  group('EnvUtil Tests', () {
    setUp(() {
      dotenv.loadFromString(
        envString: '''
        TEST_KEY=12345
        BOOL_TRUE=true
        BOOL_FALSE=false
        INT_VALUE=42
        EMPTY_VALUE= 
      ''',
      );
    });

    test('EnvUtil.get(): 입력된 KEY로 값 읽기', () {
      final value = EnvUtil.get(testEnvKey);
      expect(value, '12345');
    });

    test('EnvUtil.get(): 존재하지 않는 KEY는 예외 발생', () {
      expect(() => EnvUtil.get(unknownEnvKey), throwsException);
    });

    test('EnvUtil.get(): fallback 값 사용', () {
      final value = EnvUtil.get(unknownEnvKey, fallback: 'fallback');
      expect(value, 'fallback');
    });

    test('EnvUtil.getNullable(): 값 반환 또는 null', () {
      expect(EnvUtil.getNullable(testEnvKey), '12345');
      expect(EnvUtil.getNullable(unknownEnvKey), isNull);
    });

    test('EnvUtil.getBool(): boolean 값 파싱', () {
      expect(EnvUtil.getBool(boolTrueEnvKey), true);
      expect(EnvUtil.getBool(boolFalseEnvKey), false);
    });

    test('EnvUtil.getBool(): fallback 값 사용', () {
      expect(EnvUtil.getBool(unknownEnvKey, fallback: true), true);
    });

    test('EnvUtil.getInt(): integer 값 파싱', () {
      expect(EnvUtil.getInt(intValueEnvKey), 42);
    });

    test('EnvUtil.getInt(): fallback 값 사용', () {
      expect(EnvUtil.getInt(unknownEnvKey, fallback: 99), 99);
      expect(EnvUtil.getInt(emptyValueEnvKey, fallback: 7), 7);
    });
  });
}
