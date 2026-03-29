import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/features/onboarding/presentation/models/login_page_model.dart';

part 'login_page_provider.g.dart';

/// 로그인 페이지 상태 관리
@riverpod
class LoginPage extends _$LoginPage {
  /// 연락처 입력 컨트롤러
  late final TextEditingController phoneController;

  /// 비밀번호 입력 컨트롤러
  late final TextEditingController passwordController;

  @override
  LoginPageModel build() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();

    phoneController.addListener(_syncPhone);
    passwordController.addListener(_syncPassword);

    ref.onDispose(() {
      phoneController
        ..removeListener(_syncPhone)
        ..dispose();
      passwordController
        ..removeListener(_syncPassword)
        ..dispose();
    });

    return const LoginPageModel();
  }

  /// 연락처(아이디) 업데이트
  void updatePhone(String value) {
    _replaceText(phoneController, value);
  }

  /// 연락처 초기화
  void clearPhone() {
    phoneController.clear();
  }

  /// 비밀번호 업데이트
  void updatePassword(String value) {
    _replaceText(passwordController, value);
  }

  /// 비밀번호 표시 여부 토글
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 상태 초기화
  void reset() {
    phoneController.clear();
    passwordController.clear();
    state = const LoginPageModel();
  }

  void _syncPhone() {
    final value = phoneController.text;
    if (state.phone == value) return;
    state = state.copyWith(phone: value);
  }

  void _syncPassword() {
    final value = passwordController.text;
    if (state.password == value) return;
    state = state.copyWith(password: value);
  }

  void _replaceText(TextEditingController controller, String value) {
    if (controller.text == value) return;

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}
