import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'profile_rejection_provider.g.dart';

/// 프로필 반려 화면 상태.
class ProfileRejectionState {
  /// 반려 사유.
  final RejectionReason rejectionReason;

  /// 재심사 요청 진행 여부.
  final bool isSubmitting;

  /// 재심사 요청 에러 메시지.
  final String? submitErrorMessage;

  /// 생성자.
  const ProfileRejectionState({
    required this.rejectionReason,
    this.isSubmitting = false,
    this.submitErrorMessage,
  });

  /// 상태 일부를 변경한다.
  ProfileRejectionState copyWith({
    RejectionReason? rejectionReason,
    bool? isSubmitting,
    String? submitErrorMessage,
  }) {
    return ProfileRejectionState(
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
    );
  }
}

/// 프로필 반려 사유 조회와 재심사 요청을 관리한다.
@Riverpod(keepAlive: true)
class ProfileRejectionController extends _$ProfileRejectionController {
  @override
  Future<ProfileRejectionState> build() async {
    final rejectionReason = await ref
        .read(profileRepositoryProvider)
        .fetchRejectionReason();

    return ProfileRejectionState(rejectionReason: rejectionReason);
  }

  /// 프로필 재심사를 요청하고 로컬 상태를 승인 대기로 갱신한다.
  Future<bool> requestReapply() async {
    final currentState = switch (state) {
      AsyncData(value: final value) => value,
      _ => null,
    };
    if (currentState == null || currentState.isSubmitting) return false;

    state = AsyncData(
      currentState.copyWith(isSubmitting: true, submitErrorMessage: null),
    );

    try {
      await ref.read(profileRepositoryProvider).requestProfileReapply();
      await ref
          .read(onboardingProfileStatusPersistenceProvider)
          .saveProfileStatus(LoginProfileStatus.awaitingApproval);

      if (!ref.mounted) return false;

      state = AsyncData(
        currentState.copyWith(isSubmitting: false, submitErrorMessage: null),
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = AsyncData(
        currentState.copyWith(
          isSubmitting: false,
          submitErrorMessage: ApiErrorMessages.requestProfileReapplyFailed,
        ),
      );
      return false;
    }
  }
}
