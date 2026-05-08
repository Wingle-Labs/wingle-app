import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';

/// 로그인 응답 DTO
class LoginResponseDto {
  /// 액세스 토큰
  final String accessToken;

  /// 리프레시 토큰
  final String refreshToken;

  /// 프로필 진행 상태
  final LoginProfileStatus profileStatus;

  /// 성별
  final String? gender;

  /// 생성자
  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.profileStatus,
    this.gender,
  });

  /// JSON 파싱
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      profileStatus: LoginProfileStatus.fromApiValue(
        json['onboardingStatus']?.toString() ??
            json['profileStatus']?.toString() ??
            json['profile_status']?.toString(),
      ),
      gender: json['gender']?.toString().toLowerCase(),
    );
  }

  /// 도메인 모델 변환
  LoginResult toDomain() {
    return LoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      profileStatus: profileStatus,
      gender: gender,
    );
  }
}
