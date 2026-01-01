import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/auth/domain/usecases/request_phone_code.dart';
import 'package:wingle/features/auth/presentation/providers/phone_auth_repository_provider.dart';

part 'request_phone_code.g.dart';

@riverpod
/// 휴대폰 인증번호 요청
RequestPhoneCode requestPhoneCode(Ref ref) {
  final repository = ref.watch(phoneAuthRepositoryProvider);
  return RequestPhoneCode(repository);
}
