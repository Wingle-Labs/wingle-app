import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/presentation/models/login_page_model.dart';

part 'login_page_provider.g.dart';

/// 로그인 페이지 상태 관리
@riverpod
class LoginPage extends _$LoginPage {
  @override
  LoginPageModel build() {
    return const LoginPageModel();
  }

  /// 연락처(아이디) 업데이트
  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  /// 비밀번호 업데이트
  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  /// 상태 초기화
  void reset() {
    state = const LoginPageModel();
  }
}
