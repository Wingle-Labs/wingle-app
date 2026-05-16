import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/exceptions/auth_exception.dart';
import 'package:wingle/features/auth/presentation/providers/login_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/models/login_page_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';

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
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
    _replaceText(phoneController, value);
  }

  /// 연락처 초기화
  void clearPhone() {
    phoneController.clear();
  }

  /// 비밀번호 업데이트
  void updatePassword(String value) {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
    _replaceText(passwordController, value);
  }

  /// 비밀번호 표시 여부 토글
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 로그인 요청
  Future<bool> submit() async {
    if (!state.canLogin) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(loginRepositoryProvider);
      final result = await repository.login(
        phoneNumber: state.phoneNumber,
        password: state.passwordValue,
      );

      if (!ref.mounted) return false;

      await HiveUtil.write(
        key: HiveLoginBox.userId,
        value: state.phoneNumber.apiValue,
      );
      await HiveUtil.write(
        key: HiveLoginBox.accessToken,
        value: result.accessToken,
      );
      await HiveUtil.write(
        key: HiveLoginBox.refreshToken,
        value: result.refreshToken,
      );
      await HiveUtil.write(
        key: HiveLoginBox.profileStatus,
        value: result.profileStatus.apiValue,
      );
      if (result.gender != null) {
        await HiveUtil.write(key: HiveLoginBox.gender, value: result.gender!);
      } else {
        await HiveUtil.delete(HiveLoginBox.gender);
      }

      if (!ref.mounted) return false;

      ref.read(basicProfileProvider.notifier).reset();

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        profileStatus: result.profileStatus,
      );
      return true;
    } on AuthException catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        profileStatus: null,
      );
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiErrorMessages.loginFailed,
        profileStatus: null,
      );
      return false;
    }
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
    state = state.copyWith(phone: value, errorMessage: null);
  }

  void _syncPassword() {
    final value = passwordController.text;
    if (state.password == value) return;
    state = state.copyWith(password: value, errorMessage: null);
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
