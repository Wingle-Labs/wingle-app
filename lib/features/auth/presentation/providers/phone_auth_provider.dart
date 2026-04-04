import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/presentation/providers/request_phone_code.dart';
import 'package:wingle/features/auth/presentation/states/phone_auth_state.dart';

part 'phone_auth_provider.g.dart';

@riverpod
/// 휴대폰 인증 상태를 관리합니다.
class PhoneAuth extends _$PhoneAuth {
  @override
  PhoneAuthState build() {
    return PhoneAuthState.init();
  }

  /// 휴대폰 번호 업데이트
  void onChanged(String phoneNumber) {
    state = state.copyWith(phoneNumber: PhoneNumber(phoneNumber));
  }

  /// 휴대폰 번호 변경
  void changePhoneNumber() {
    state = state.copyWith(
      isSending: false,
      isSent: false,
      isVerifying: false,
      isVerified: false,
    );
  }

  /// 휴대폰 인증번호 요청
  Future<void> requestPhoneCode() async {
    final request = ref.read(requestPhoneCodeProvider);
    state = state.copyWith(isSent: false, isSending: true);

    final result = await request.call(state.phoneNumber.apiValue);
    state = state.copyWith(isSending: false);
    if (result) {
      state = state.copyWith(isSent: true);
    } else {
      state = state.copyWith(isSent: false);
    }
  }

  /// 휴대폰 인증번호 확인
  Future<void> verifyPhoneCode() async {
    state = state.copyWith(isVerifying: true);
  }
}
