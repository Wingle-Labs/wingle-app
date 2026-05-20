import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/data/datasources/firebase_phone_auth_api.dart';
import 'package:wingle/features/auth/data/repositories/phone_auth_repository_impl.dart';

class _FakePhoneAuthApi extends FirebasePhoneAuthApi {
  int requestCount = 0;
  int verifyCount = 0;
  String? lastPhone;
  String? lastCode;

  @override
  Future<bool> requestCode(String phone) async {
    requestCount += 1;
    lastPhone = phone;
    return true;
  }

  @override
  Future<bool> verifyCode(String smsCode) async {
    verifyCount += 1;
    lastCode = smsCode;
    return true;
  }
}

void main() {
  test('PhoneAuthRepositoryImpl은 API에 요청과 검증을 위임한다', () async {
    final api = _FakePhoneAuthApi();
    final repository = PhoneAuthRepositoryImpl(api);

    final requested = await repository.requestCode('01012345678');
    final verified = await repository.verifyCode('123456');

    expect(requested, isTrue);
    expect(verified, isTrue);
    expect(api.requestCount, 1);
    expect(api.verifyCount, 1);
    expect(api.lastPhone, '01012345678');
    expect(api.lastCode, '123456');
  });
}

