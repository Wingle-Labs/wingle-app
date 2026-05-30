import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';

/// 로그인 성공 결과
class LoginResult {
  /// 액세스 토큰
  final String accessToken;

  /// 리프레시 토큰
  final String refreshToken;

  /// 로그인 시점의 프로필 진행 상태
  final LoginProfileStatus profileStatus;

  /// 로그인 시점의 성별
  final String? gender;

  /// 로그인 시점의 기본 프로필 정보
  final LoginBasicProfile? basicProfile;

  /// 생성자
  const LoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.profileStatus,
    this.gender,
    this.basicProfile,
  });
}
