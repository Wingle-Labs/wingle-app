import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';

/// 전화번호 모델 테스트
void main() {
  test('[PhoneNumber.isValid]: 정상적인 전화번호', () {
    final phoneNumber = PhoneNumber('01023456789');
    expect(phoneNumber.isValid, true);
  });

  test('[PhoneNumber.isValid]: 짧은 전화번호', () {
    final phoneNumber = PhoneNumber('0101234567');
    expect(phoneNumber.isValid, false);
  });

  test('[PhoneNumber.isValid]: 010이 빠진 전화번호', () {
    final phoneNumber = PhoneNumber('12345678910');
    expect(phoneNumber.isValid, false);
  });

  test('[PhoneNumber.isValid]: 긴 전화번호', () {
    final phoneNumber = PhoneNumber('010123456789');
    expect(phoneNumber.isValid, false);
  });

  test('[PhoneNumber.isValid]: 숫자가 아닌 문자가 포함된 전화번호', () {
    final phoneNumber = PhoneNumber('0101234567a');
    expect(phoneNumber.isValid, false);
  });

  test('[PhoneNumber.isValid]: 빈 전화번호', () {
    final phoneNumber = PhoneNumber('');
    expect(phoneNumber.isValid, false);
  });

  test('[PhoneNumber.isValid]: 010으로 시작하고 11자리면 유효하다', () {
    final phoneNumber = PhoneNumber('01012345678');
    expect(phoneNumber.isValid, true);
  });
}
