import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
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

  /// 기본 프로필 정보
  final LoginBasicProfile? basicProfile;

  /// 생성자
  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.profileStatus,
    this.gender,
    this.basicProfile,
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
      basicProfile: _parseBasicProfile(json),
    );
  }

  /// 도메인 모델 변환
  LoginResult toDomain() {
    return LoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      profileStatus: profileStatus,
      gender: gender,
      basicProfile: basicProfile,
    );
  }

  static LoginBasicProfile? _parseBasicProfile(Map<String, dynamic> json) {
    final sourceMaps = <Map<String, dynamic>>[
      json,
      ..._candidateMap(json, 'profile'),
      ..._candidateMap(json, 'basicProfile'),
      ..._candidateMap(json, 'basic_profile'),
      ..._candidateMap(json, 'user'),
      ..._candidateMap(json, 'userInfo'),
      ..._candidateMap(json, 'user_info'),
    ];

    final profile = LoginBasicProfile(
      nickname: _firstString(sourceMaps, const ['nickname']),
      residenceCode: _firstString(sourceMaps, const [
        'residenceCode',
        'residence_code',
      ]),
      height: _firstInt(sourceMaps, const ['height']),
      bodyTypeCode: _firstString(sourceMaps, const [
        'bodyTypeCode',
        'body_type_code',
      ]),
    );

    return profile.hasAnyValue ? profile : null;
  }

  static Iterable<Map<String, dynamic>> _candidateMap(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is Map<String, dynamic>) {
      return [value];
    }

    if (value is Map) {
      return [value.map((key, value) => MapEntry(key.toString(), value))];
    }

    return const [];
  }

  static String? _firstString(
    List<Map<String, dynamic>> maps,
    List<String> keys,
  ) {
    for (final map in maps) {
      for (final key in keys) {
        final value = map[key]?.toString().trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  static int? _firstInt(List<Map<String, dynamic>> maps, List<String> keys) {
    for (final map in maps) {
      for (final key in keys) {
        final value = map[key];
        if (value is int) {
          return value;
        }

        final parsed = int.tryParse(value?.toString() ?? '');
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }
}
