import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_job_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/presentation/models/job_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'job_profile_provider.g.dart';

/// 직장 정보 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class JobProfile extends _$JobProfile {
  @override
  JobProfileModel build() {
    final persistedProfile = AuthSessionPersistence.readJobProfile();
    if (persistedProfile == null || !persistedProfile.hasAnyValue) {
      return const JobProfileModel();
    }

    return _modelFromLoginProfile(persistedProfile);
  }

  /// 회사명을 갱신한다.
  void updateCompany(String value) {
    if (state.company == value) return;
    state = state.copyWith(
      company: value,
      emailVerified: false,
      submitErrorMessage: null,
    );
    _persistCurrentState();
  }

  /// 회사 이메일을 갱신한다.
  void updateEmail(String value) {
    if (state.email == value) return;
    state = state.copyWith(
      email: value,
      emailVerified: false,
      isVerificationCodeSent: false,
      emailVerificationErrorMessage: null,
    );
  }

  /// 회사 이메일 인증번호를 갱신한다.
  void updateVerificationCode(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (state.verificationCode == sanitized) return;
    state = state.copyWith(
      verificationCode: sanitized,
      emailVerificationErrorMessage: null,
    );
  }

  /// 직업 코드를 선택한다.
  void selectOccupation({required String code, required String name}) {
    if (state.occupationCode == code && state.occupationName == name) return;
    state = state.copyWith(
      occupationCode: code,
      occupationName: name,
      company: '',
      email: '',
      verificationCode: '',
      emailVerified: false,
      isVerificationCodeSent: false,
      submitErrorMessage: null,
      emailVerificationErrorMessage: null,
    );
    _persistCurrentState();
  }

  /// 직업 선택을 초기화한다.
  void clearOccupation() {
    state = const JobProfileModel();
    _persistCurrentState();
  }

  /// 서버의 내 프로필 스냅샷이 준비되어 있으면 직장 정보 상태를 갱신한다.
  Future<void> restoreFromServerProfileIfAvailable() async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      final snapshot = await repository.fetchMyProfile();
      final profile = snapshot?.jobProfile;
      if (!ref.mounted || profile == null || !profile.hasAnyValue) {
        return;
      }

      if (snapshot != null) {
        await AuthSessionPersistence.saveMyProfileSnapshot(snapshot);
      }
      if (!ref.mounted) return;
      state = _modelFromLoginProfile(profile);
    } catch (_) {
      // 로그인 플로우를 막지 않기 위해 프로필 스냅샷 복원 실패는 무시한다.
    }
  }

  /// 직장 정보를 서버에 업로드한다.
  Future<bool> submit() async {
    if (state.isSubmitting) return false;

    final company = state.company.trim();
    final occupationCode = state.occupationCode?.trim();
    final requiresCompany = state.requiresCompany;
    if (occupationCode == null ||
        occupationCode.isEmpty ||
        (requiresCompany && company.isEmpty)) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitJobFailed,
      );
      return false;
    }

    final shouldUpdate = _readProfileStatus().hasCompletedJobInfo;
    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      if (shouldUpdate) {
        await repository.updateJob(
          company: company,
          occupation: occupationCode,
        );
      } else {
        await repository.submitJob(
          company: company,
          occupation: occupationCode,
        );
      }

      await AuthSessionPersistence.saveJobProfile(
        LoginJobProfile(
          company: company,
          occupationCode: occupationCode,
          occupationName: state.occupationName,
          emailVerified: shouldUpdate ? false : state.emailVerified,
        ),
      );
      if (!shouldUpdate) {
        await HiveUtil.write(
          key: HiveLoginBox.profileStatus,
          value: LoginProfileStatus.jobInfoCompleted.apiValue,
        );
      }

      if (!ref.mounted) return false;

      state = state.copyWith(
        company: company,
        emailVerified: shouldUpdate ? false : state.emailVerified,
        isSubmitting: false,
        submitErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitJobFailed,
      );
      return false;
    }
  }

  /// 회사 이메일 인증번호를 전송한다.
  Future<bool> sendVerificationEmail() async {
    if (state.isSubmitting) return false;
    final email = state.email.trim();
    if (!state.canSendVerificationEmail) {
      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: ApiErrorMessages.verifyJobEmailFailed,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      emailVerificationErrorMessage: null,
    );

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.verifyJobEmail(email: email);

      if (!ref.mounted) return false;

      state = state.copyWith(
        email: email,
        isSubmitting: false,
        isVerificationCodeSent: true,
        emailVerificationErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: ApiErrorMessages.verifyJobEmailFailed,
      );
      return false;
    }
  }

  /// 회사 이메일 인증번호를 확인한다.
  Future<bool> confirmVerificationCode() async {
    if (state.isSubmitting) return false;
    final email = state.email.trim();
    final code = int.tryParse(state.verificationCode.trim());
    if (!state.canConfirmVerificationCode || code == null) {
      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: ApiErrorMessages.verifyJobEmailFailed,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      emailVerificationErrorMessage: null,
    );

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.confirmJobEmail(email: email, verificationCode: code);
      await AuthSessionPersistence.saveJobProfile(
        LoginJobProfile(
          company: _nonEmpty(state.company),
          occupationCode: _nonEmpty(state.occupationCode),
          occupationName: _nonEmpty(state.occupationName),
          emailVerified: true,
        ),
      );

      if (!ref.mounted) return false;

      state = state.copyWith(
        email: email,
        emailVerified: true,
        isSubmitting: false,
        emailVerificationErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: ApiErrorMessages.verifyJobEmailFailed,
      );
      return false;
    }
  }

  void _persistCurrentState() {
    _ignorePersistenceFailure(
      AuthSessionPersistence.saveJobProfile(_profileFromState()),
    );
  }

  LoginJobProfile _profileFromState() {
    return LoginJobProfile(
      company: _nonEmpty(state.company),
      occupationCode: _nonEmpty(state.occupationCode),
      occupationName: _nonEmpty(state.occupationName),
      emailVerified: state.emailVerified,
    );
  }

  JobProfileModel _modelFromLoginProfile(LoginJobProfile profile) {
    return JobProfileModel(
      company: profile.company?.trim() ?? '',
      occupationCode: _nonEmpty(profile.occupationCode),
      occupationName: _nonEmpty(profile.occupationName),
      emailVerified: profile.emailVerified ?? false,
    );
  }

  LoginProfileStatus _readProfileStatus() {
    try {
      final rawValue = HiveUtil.read(HiveLoginBox.profileStatus);
      return LoginProfileStatus.fromApiValue(rawValue);
    } catch (_) {
      return LoginProfileStatus.signupCompleted;
    }
  }

  void _ignorePersistenceFailure(Future<void> future) {
    unawaited(future.catchError((_) {}));
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}
