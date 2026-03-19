import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/onboarding/presentation/models/onboarding_password_input_model.dart';

part 'onboarding_password_input_page_provider.g.dart';

/// 로그인 페이지 상태 관리
@riverpod
class OnboardingPasswordInputPage extends _$OnboardingPasswordInputPage {
  @override
  OnboardingPasswordInputModel build() {
    final uuid = ref.watch(deviceUuidProvider);
    return OnboardingPasswordInputModel(uuid: uuid);
  }

  /// 비밀번호 업데이트
  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  /// 비밀번호 표시 여부 토글
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// 재입력 비밀번호 업데이트
  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  /// 비밀번호 표시 여부 토글
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  /// 로딩 여부 업데이트
  void updateIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// 회원가입 진행
  Future<bool> submit() async {
    // TODO: 회원가입 로직 구현
    updateIsLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    final result = await Future<bool>.value(true);
    updateIsLoading(false);
    return result;
  }

  /// 상태 초기화
  void reset() {
    final uuid = ref.watch(deviceUuidProvider);
    state = OnboardingPasswordInputModel(uuid: uuid);
  }
}
