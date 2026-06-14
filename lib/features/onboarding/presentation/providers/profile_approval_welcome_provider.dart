import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';

part 'profile_approval_welcome_provider.g.dart';

/// 프로필 승인 완료 안내 화면 상태.
class ProfileApprovalWelcomeModel {
  /// 사용자 닉네임.
  final String nickname;

  /// 확인 상태 저장 중 여부.
  final bool isSaving;

  /// 오류 메시지 localization key.
  final String? errorMessage;

  /// 생성자.
  const ProfileApprovalWelcomeModel({
    required this.nickname,
    this.isSaving = false,
    this.errorMessage,
  });

  /// 변경된 상태 복사본.
  ProfileApprovalWelcomeModel copyWith({
    String? nickname,
    bool? isSaving,
    String? errorMessage,
  }) {
    return ProfileApprovalWelcomeModel(
      nickname: nickname ?? this.nickname,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}

/// 프로필 승인 완료 안내 화면 로컬 저장소.
abstract interface class ProfileApprovalWelcomePersistence {
  /// 저장된 닉네임을 읽는다.
  String readNickname();

  /// 승인 완료 안내 화면을 확인한 상태로 저장한다.
  Future<void> markSeen();
}

/// Hive 세션 기반 승인 완료 안내 화면 저장소.
class AuthSessionProfileApprovalWelcomePersistence
    implements ProfileApprovalWelcomePersistence {
  /// 생성자.
  const AuthSessionProfileApprovalWelcomePersistence();

  @override
  String readNickname() {
    return AuthSessionPersistence.readBasicProfile()?.nickname?.trim() ?? '';
  }

  @override
  Future<void> markSeen() {
    return AuthSessionPersistence.markProfileApprovalWelcomeSeen();
  }
}

/// 프로필 승인 완료 안내 화면 저장소 provider.
@Riverpod(keepAlive: true)
ProfileApprovalWelcomePersistence profileApprovalWelcomePersistence(Ref ref) {
  return const AuthSessionProfileApprovalWelcomePersistence();
}

/// 프로필 승인 완료 안내 화면 상태를 관리한다.
@riverpod
class ProfileApprovalWelcomeController
    extends _$ProfileApprovalWelcomeController {
  @override
  ProfileApprovalWelcomeModel build() {
    final nickname = ref
        .watch(profileApprovalWelcomePersistenceProvider)
        .readNickname();
    return ProfileApprovalWelcomeModel(nickname: nickname);
  }

  /// 안내 화면 확인 상태를 저장한다.
  Future<bool> markSeen() async {
    if (state.isSaving) {
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await ref.read(profileApprovalWelcomePersistenceProvider).markSeen();
      if (!ref.mounted) {
        return true;
      }

      state = state.copyWith(isSaving: false, errorMessage: null);
      return true;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }

      state = state.copyWith(
        isSaving: false,
        errorMessage: 'onboarding.profileApprovedWelcome.saveFailed',
      );
      return false;
    }
  }
}
