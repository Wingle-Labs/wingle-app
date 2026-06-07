import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

part 'onboarding_profile_status_provider.g.dart';

/// 온보딩 프로필 상태 동기화용 로컬 저장소.
abstract interface class OnboardingProfileStatusPersistence {
  /// `/profiles/me` 응답 스냅샷을 로컬 세션에 저장한다.
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot);

  /// 온보딩 프로필 상태만 로컬 세션에 저장한다.
  Future<void> saveProfileStatus(LoginProfileStatus status);
}

/// Hive 기반 온보딩 프로필 상태 저장소.
class AuthSessionOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  /// 생성자.
  const AuthSessionOnboardingProfileStatusPersistence();

  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) {
    return AuthSessionPersistence.saveMyProfileSnapshot(snapshot);
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) {
    return AuthSessionPersistence.saveProfileStatus(status);
  }
}

/// 온보딩 프로필 상태 저장소 provider.
final onboardingProfileStatusPersistenceProvider =
    Provider<OnboardingProfileStatusPersistence>(
      (ref) => const AuthSessionOnboardingProfileStatusPersistence(),
    );

/// 승인 대기 화면에서 서버 온보딩 상태를 갱신한다.
@riverpod
class ProfileApprovalStatusController
    extends _$ProfileApprovalStatusController {
  @override
  Future<LoginProfileStatus?> build() {
    return _fetchAndPersistStatus();
  }

  /// `/profiles/me`를 다시 조회하고 로컬 세션을 최신화한다.
  Future<LoginProfileStatus?> refresh() async {
    final nextState = await AsyncValue.guard(_fetchAndPersistStatus);
    final status = switch (nextState) {
      AsyncData(value: final status) => status,
      _ => null,
    };
    if (!ref.mounted) return status;

    state = nextState;
    return status;
  }

  Future<LoginProfileStatus?> _fetchAndPersistStatus() async {
    final snapshot = await ref.read(profileRepositoryProvider).fetchMyProfile();
    if (snapshot == null) return null;
    if (!ref.mounted) return snapshot.onboardingStatus;

    await ref
        .read(onboardingProfileStatusPersistenceProvider)
        .saveMyProfileSnapshot(snapshot);

    return snapshot.onboardingStatus;
  }
}
