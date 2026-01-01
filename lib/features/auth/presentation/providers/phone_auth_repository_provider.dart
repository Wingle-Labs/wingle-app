import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/auth/data/datasources/firebase_phone_auth_api.dart';
import 'package:wingle/features/auth/data/repositories/phone_auth_repository_impl.dart';
import 'package:wingle/features/auth/domain/repositories/phone_auth_repository.dart';

part 'phone_auth_repository_provider.g.dart';

@riverpod
/// 휴대폰 인증 레포지토리
PhoneAuthRepository phoneAuthRepository(Ref ref) {
  return PhoneAuthRepositoryImpl(FirebasePhoneAuthApi());
}
