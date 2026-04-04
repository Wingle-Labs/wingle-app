import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/providers/device_uuid_provider.dart';
import 'package:wingle/features/onboarding/presentation/models/onboarding_password_input_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/signup_repository_provider.dart';

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
    if (!state.canSignUp) return false;

    updateIsLoading(true);

    try {
      final repository = ref.read(signupRepositoryProvider);
      await repository.submitPassword(
        uuid: state.uuid,
        password: state.password,
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      if (ref.mounted) {
        updateIsLoading(false);
      }
    }
  }

  /// 상태 초기화
  void reset() {
    final uuid = ref.read(deviceUuidProvider);
    state = OnboardingPasswordInputModel(uuid: uuid);
  }
}
