import 'dart:io';

import 'package:wingle/common/constants/env_constants.dart';

/// 실제 서버 live contract test를 위한 환경 설정.
class LiveApiEnv {
  /// 생성자 방지.
  LiveApiEnv._();

  static const String _envFilePath = 'lib/app/config/env/live_api.env';

  static const String baseUrlKey = 'TEST_API_BASE_URL';
  static const String accessTokenKey = 'TEST_API_ACCESS_TOKEN';
  static const String accountIdKey = 'TEST_API_ACCOUNT_ID';
  static const String accountPasswordKey = 'TEST_API_ACCOUNT_PASSWORD';
  static const String refreshTokenKey = 'TEST_API_REFRESH_TOKEN';
  static const String adminAccessTokenKey = 'TEST_API_ADMIN_ACCESS_TOKEN';
  static const String adminUserIdKey = 'TEST_API_ADMIN_USER_ID';
  static const String adminDestructiveOkKey = 'TEST_API_ADMIN_DESTRUCTIVE_OK';
  static const String loginPhoneNumberKey = 'TEST_API_LOGIN_PHONE_NUMBER';
  static const String loginPasswordKey = 'TEST_API_LOGIN_PASSWORD';
  static const String signupUuidKey = 'TEST_API_SIGNUP_UUID';
  static const String signupPasswordKey = 'TEST_API_SIGNUP_PASSWORD';
  static const String profileNicknameKey = 'TEST_API_PROFILE_NICKNAME';
  static const String profileHeightKey = 'TEST_API_PROFILE_HEIGHT';
  static const String profileResidenceCodeKey =
      'TEST_API_PROFILE_RESIDENCE_CODE';
  static const String profileBodyTypeCodeKey =
      'TEST_API_PROFILE_BODY_TYPE_CODE';
  static const String profileMbtiKey = 'TEST_API_PROFILE_MBTI';
  static const String profileIntroductionKey = 'TEST_API_PROFILE_INTRODUCTION';
  static const String profileCompanyKey = 'TEST_API_PROFILE_COMPANY';
  static const String profileOccupationKey = 'TEST_API_PROFILE_OCCUPATION';
  static const String profileUniversityKey = 'TEST_API_PROFILE_UNIVERSITY';
  static const String profileEducationLevelKey =
      'TEST_API_PROFILE_EDUCATION_LEVEL';
  static const String contactPhoneNumbersKey = 'TEST_API_CONTACT_PHONE_NUMBERS';
  static const String fcmTokenKey = 'TEST_API_FCM_TOKEN';
  static const String identityNameKey = 'TEST_API_IDENTITY_NAME';
  static const String identityPhoneNumberKey = 'TEST_API_IDENTITY_PHONE';
  static const String identityCiKey = 'TEST_API_IDENTITY_CI';
  static const String identityGenderKey = 'TEST_API_IDENTITY_GENDER';
  static const String identityBirthKey = 'TEST_API_IDENTITY_BIRTH';
  static const String identityAgeKey = 'TEST_API_IDENTITY_AGE';

  static Map<String, String>? _cachedEnv;

  /// `.env`와 프로세스 환경변수를 합쳐 반환한다.
  static Map<String, String> load() {
    if (_cachedEnv != null) {
      return _cachedEnv!;
    }

    final env = <String, String>{};

    env.addAll(Platform.environment);

    final file = File(_envFilePath);
    if (file.existsSync()) {
      env.addAll(_parseEnvFile(file.readAsStringSync()));
    }

    _cachedEnv = env;
    return env;
  }

  /// live test에 필요한 최소 설정이 준비되었는지 확인한다.
  static bool hasRequiredConfig() {
    final env = load();
    return env[baseUrlKey]?.trim().isNotEmpty == true &&
        ((env[accessTokenKey]?.trim().isNotEmpty == true) ||
            (env[accountIdKey]?.trim().isNotEmpty == true &&
                env[accountPasswordKey]?.trim().isNotEmpty == true));
  }

  /// 기본 사용자 세션을 만들 수 있는지 확인한다.
  static bool hasUserSessionConfig() => hasRequiredConfig();

  /// 관리자 세션 구성을 확인한다.
  static bool hasAdminSessionConfig() {
    final env = load();
    return hasRequiredConfig() &&
        env[adminAccessTokenKey]?.trim().isNotEmpty == true;
  }

  /// EnvConstants의 live API 파일 키와 호환되는지 확인한다.
  static void ensureConfigured() {
    final envFile = EnvConstants.liveApi;
    if (envFile.path != _envFilePath) {
      throw StateError('live api env path mismatch');
    }
  }

  /// 스킵 사유를 만든다.
  static String missingConfigMessage(List<String> missingKeys) {
    return 'live contract test를 실행하려면 다음 환경 변수가 필요합니다: '
        '${missingKeys.join(', ')}';
  }

  /// 값 조회.
  static String? get(String key) {
    final value = load()[key];
    if (value == null) {
      return null;
    }

    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// 정수 값 조회.
  static int? getInt(String key) {
    final raw = get(key);
    if (raw == null) {
      return null;
    }
    return int.tryParse(raw);
  }

  static Map<String, String> _parseEnvFile(String content) {
    final entries = <String, String>{};
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        continue;
      }

      final index = trimmed.indexOf('=');
      if (index <= 0) {
        continue;
      }

      final key = trimmed.substring(0, index).trim();
      var value = trimmed.substring(index + 1).trim();

      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }

      entries[key] = value;
    }

    return entries;
  }
}
