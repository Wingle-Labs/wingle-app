import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/presentation/providers/onboarding_profile_status_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_rejection_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

void main() {
  test('승인 대기 상태 refresh는 /profiles/me 결과를 로컬 스냅샷에 저장한다', () async {
    const snapshot = MyProfileSnapshot(
      onboardingStatus: LoginProfileStatus.profileApproved,
    );
    final persistence = _MemoryOnboardingProfileStatusPersistence();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          const _ImmediateProfileRepository(profileSnapshot: snapshot),
        ),
        onboardingProfileStatusPersistenceProvider.overrideWithValue(
          persistence,
        ),
      ],
    );
    addTearDown(container.dispose);

    final status = await container
        .read(profileApprovalStatusControllerProvider.notifier)
        .refresh();

    expect(status, LoginProfileStatus.profileApproved);
    expect(persistence.profileSnapshot, snapshot);
  });

  test('거절 사유 controller는 사유를 조회하고 재심사 요청 성공 시 승인 대기로 저장한다', () async {
    final repository = _RecordingProfileRepository(
      rejectionReason: const RejectionReason(
        reviewedAt: '2026-06-01T12:00:00',
        reasons: [
          RejectionReasonItem(
            code: 'SELF_INTRO_INAPPROPRIATE',
            categoryDisplayName: '자기소개',
            description: '부적절한 내용이 포함되어 있습니다.',
          ),
        ],
      ),
    );
    final persistence = _MemoryOnboardingProfileStatusPersistence();
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        onboardingProfileStatusPersistenceProvider.overrideWithValue(
          persistence,
        ),
      ],
    );
    addTearDown(container.dispose);

    final initialState = await container.read(
      profileRejectionControllerProvider.future,
    );
    final success = await container
        .read(profileRejectionControllerProvider.notifier)
        .requestReapply();

    expect(
      initialState.rejectionReason.reasons.single.code,
      'SELF_INTRO_INAPPROPRIATE',
    );
    expect(success, isTrue);
    expect(repository.didRequestProfileReapply, isTrue);
    expect(persistence.profileStatus, LoginProfileStatus.awaitingApproval);
  });
}

class _MemoryOnboardingProfileStatusPersistence
    implements OnboardingProfileStatusPersistence {
  MyProfileSnapshot? profileSnapshot;
  LoginProfileStatus? profileStatus;

  @override
  Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {
    profileSnapshot = snapshot;
    profileStatus = snapshot.onboardingStatus;
  }

  @override
  Future<void> saveProfileStatus(LoginProfileStatus status) async {
    profileStatus = status;
  }
}

class _RecordingProfileRepository extends MockProfileRepository {
  final RejectionReason rejectionReason;
  bool didRequestProfileReapply = false;

  _RecordingProfileRepository({required this.rejectionReason});

  @override
  Future<RejectionReason> fetchRejectionReason() async {
    return rejectionReason;
  }

  @override
  Future<void> requestProfileReapply() async {
    didRequestProfileReapply = true;
  }
}

class _ImmediateProfileRepository extends MockProfileRepository {
  const _ImmediateProfileRepository({super.profileSnapshot});

  @override
  Future<MyProfileSnapshot?> fetchMyProfile() async {
    return profileSnapshot;
  }
}
