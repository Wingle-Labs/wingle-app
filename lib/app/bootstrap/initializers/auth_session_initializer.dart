import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/common/utils/auth_session_state.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/password.dart';
import 'package:wingle/features/auth/domain/models/phone_number.dart';
import 'package:wingle/features/auth/domain/repositories/login_repository.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

/// 앱 시작 시 저장된 인증 세션을 검증하고 복구한다.
class AuthSessionInitializer {
  /// 로그인/토큰 재발급 repository.
  final LoginRepository loginRepository;

  /// 프로필 repository.
  final ProfileRepository? profileRepository;

  /// 로그 출력 콜백.
  final void Function(String message) logger;

  /// 생성자.
  const AuthSessionInitializer({
    required this.loginRepository,
    this.profileRepository,
    required this.logger,
  });

  /// 저장된 refresh token을 우선 갱신하고, 실패하면 저장된 계정으로 재로그인한다.
  Future<AuthSessionInitializeResult> initialize() async {
    final refreshToken = HiveUtil.read(HiveLoginBox.refreshToken)?.trim();
    if (refreshToken == null || refreshToken.isEmpty) {
      AuthSessionState.notifyChanged();
      return const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.noSession,
      );
    }

    try {
      final token = await loginRepository.reissue(refreshToken: refreshToken);
      await AuthSessionPersistence.saveTokens(token);
      await _restoreServerProfileSnapshotIfAvailable();
      AuthSessionState.markAuthenticated();
      return const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.refreshed,
      );
    } catch (error) {
      logger('[AuthSession] refresh failed: $error');
      return _restoreWithSavedCredentials();
    }
  }

  Future<AuthSessionInitializeResult> _restoreWithSavedCredentials() async {
    final userId = HiveUtil.read(HiveLoginBox.userId)?.trim();
    final password = HiveUtil.read(HiveLoginBox.userPassword);

    if (userId == null ||
        userId.isEmpty ||
        password == null ||
        password.isEmpty) {
      await AuthSessionState.clearLoginInfo();
      return const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.signedOut,
      );
    }

    try {
      final result = await loginRepository.login(
        phoneNumber: PhoneNumber(userId),
        password: Password(password),
      );
      await AuthSessionPersistence.saveLoginResult(
        userId: userId,
        password: password,
        result: result,
      );
      await _restoreServerProfileSnapshotIfAvailable();
      AuthSessionState.markAuthenticated();
      return const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.reloggedIn,
      );
    } catch (error) {
      logger('[AuthSession] saved credential login failed: $error');
      await AuthSessionState.clearLoginInfo();
      return const AuthSessionInitializeResult(
        status: AuthSessionInitializeStatus.signedOut,
      );
    }
  }

  Future<void> _restoreServerProfileSnapshotIfAvailable() async {
    final repository = profileRepository;
    if (repository == null) {
      return;
    }

    try {
      final snapshot = await repository.fetchMyProfile();
      if (snapshot == null || !snapshot.hasAnyValue) {
        return;
      }

      await AuthSessionPersistence.saveMyProfileSnapshot(snapshot);
    } catch (error) {
      logger('[AuthSession] /profiles/me restore skipped: $error');
    }
  }
}

/// 인증 세션 초기화 상태.
enum AuthSessionInitializeStatus {
  /// 저장된 세션이 없다.
  noSession,

  /// refresh token으로 토큰 갱신에 성공했다.
  refreshed,

  /// 저장된 아이디/비밀번호로 재로그인했다.
  reloggedIn,

  /// 세션 복구에 실패해 로그아웃 처리했다.
  signedOut,
}

/// 인증 세션 초기화 결과.
class AuthSessionInitializeResult {
  /// 초기화 상태.
  final AuthSessionInitializeStatus status;

  /// 생성자.
  const AuthSessionInitializeResult({required this.status});

  /// 유효한 인증 세션인지 여부.
  bool get isAuthenticated =>
      status == AuthSessionInitializeStatus.refreshed ||
      status == AuthSessionInitializeStatus.reloggedIn;
}
