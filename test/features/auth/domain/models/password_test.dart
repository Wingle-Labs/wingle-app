import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/domain/models/password.dart';

void main() {
  group('Password', () {
    test('영문, 숫자, 허용 특수문자를 포함한 8~32자 비밀번호는 유효하다', () {
      expect(const Password('abc123!@').isValid, isTrue);
      expect(const Password('A1!bcdef').isValid, isTrue);
    });

    test('공백이 포함되면 유효하지 않다', () {
      expect(const Password('abc 123!').isValid, isFalse);
    });

    test('허용되지 않은 특수문자가 포함되면 유효하지 않다', () {
      expect(const Password('abc123?').isValid, isFalse);
    });

    test('32자를 초과하면 유효하지 않다', () {
      expect(
        const Password('abc123!abc123!abc123!abc123!abc123!').isValid,
        isFalse,
      );
    });
  });
}
