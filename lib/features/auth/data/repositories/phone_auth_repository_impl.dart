import 'package:wingle/features/auth/data/datasources/firebase_phone_auth_api.dart';
import 'package:wingle/features/auth/domain/repositories/phone_auth_repository.dart';

/// 휴대폰 인증 레포지토리 구현
class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  /// Firebase 휴대폰 인증 API
  final FirebasePhoneAuthApi api;

  /// 생성자
  PhoneAuthRepositoryImpl(this.api);

  @override
  Future<bool> requestCode(String number) async {
    return await api.requestCode(number);
  }

  @override
  Future<bool> verifyCode(String smsCode) async {
    return await api.verifyCode(smsCode);
  }
}
