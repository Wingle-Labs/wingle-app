import 'dart:convert';

import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/auth_token.dart';
import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_education_profile.dart';
import 'package:wingle/features/auth/domain/models/login_job_profile.dart';
import 'package:wingle/features/auth/domain/models/login_result.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';

/// 인증 세션 정보를 secure Hive에 저장하고 복원한다.
abstract final class AuthSessionPersistence {
  /// 로그인 성공 결과를 저장한다.
  static Future<void> saveLoginResult({
    required String userId,
    required String? password,
    required LoginResult result,
  }) async {
    final previousUserId = HiveUtil.read(HiveLoginBox.userId);
    if (previousUserId != null && previousUserId != userId) {
      await HiveUtil.delete(HiveLoginBox.basicProfile);
      await HiveUtil.delete(HiveLoginBox.jobProfile);
      await HiveUtil.delete(HiveLoginBox.educationProfile);
    }

    await HiveUtil.write(key: HiveLoginBox.userId, value: userId);
    if (password != null && password.isNotEmpty) {
      await HiveUtil.write(key: HiveLoginBox.userPassword, value: password);
    }

    await HiveUtil.write(
      key: HiveLoginBox.accessToken,
      value: result.accessToken,
    );
    await HiveUtil.write(
      key: HiveLoginBox.refreshToken,
      value: result.refreshToken,
    );
    await HiveUtil.write(
      key: HiveLoginBox.profileStatus,
      value: result.profileStatus.apiValue,
    );

    if (result.gender != null) {
      await HiveUtil.write(key: HiveLoginBox.gender, value: result.gender!);
    } else {
      await HiveUtil.delete(HiveLoginBox.gender);
    }

    final basicProfile = result.basicProfile;
    if (basicProfile != null && basicProfile.hasAnyValue) {
      await saveBasicProfile(basicProfile);
    }
  }

  /// 토큰 쌍만 갱신한다.
  static Future<void> saveTokens(AuthToken token) async {
    await HiveUtil.write(
      key: HiveLoginBox.accessToken,
      value: token.accessToken,
    );
    await HiveUtil.write(
      key: HiveLoginBox.refreshToken,
      value: token.refreshToken,
    );
  }

  /// 기본 프로필 정보를 저장한다.
  static Future<void> saveBasicProfile(LoginBasicProfile? profile) async {
    if (profile == null || !profile.hasAnyValue) {
      await HiveUtil.delete(HiveLoginBox.basicProfile);
      return;
    }

    await HiveUtil.write(
      key: HiveLoginBox.basicProfile,
      value: jsonEncode({...profile.toJson(), ..._currentUserScopeJson()}),
    );
  }

  /// 저장된 기본 프로필 정보를 읽는다.
  static LoginBasicProfile? readBasicProfile() {
    try {
      final raw = HiveUtil.read(HiveLoginBox.basicProfile);
      if (raw == null || raw.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }

      final json = decoded.map((key, value) => MapEntry(key.toString(), value));
      final storedUserId = json['userId']?.toString();
      final currentUserId = HiveUtil.read(HiveLoginBox.userId);
      if (storedUserId != null &&
          currentUserId != null &&
          storedUserId != currentUserId) {
        return null;
      }

      final profile = LoginBasicProfile.fromJson(json);
      return profile.hasAnyValue ? profile : null;
    } catch (_) {
      return null;
    }
  }

  /// `/profiles/me` 스냅샷을 저장한다.
  static Future<void> saveMyProfileSnapshot(MyProfileSnapshot snapshot) async {
    if (snapshot.onboardingStatus != null) {
      await HiveUtil.write(
        key: HiveLoginBox.profileStatus,
        value: snapshot.onboardingStatus!.apiValue,
      );
    }

    await saveBasicProfile(snapshot.basicProfile);
    await saveJobProfile(snapshot.jobProfile);
    await saveEducationProfile(snapshot.educationProfile);
  }

  /// 직장 프로필 정보를 저장한다.
  static Future<void> saveJobProfile(LoginJobProfile? profile) async {
    if (profile == null || !profile.hasAnyValue) {
      await HiveUtil.delete(HiveLoginBox.jobProfile);
      return;
    }

    await HiveUtil.write(
      key: HiveLoginBox.jobProfile,
      value: jsonEncode({...profile.toJson(), ..._currentUserScopeJson()}),
    );
  }

  /// 저장된 직장 프로필 정보를 읽는다.
  static LoginJobProfile? readJobProfile() {
    try {
      final raw = HiveUtil.read(HiveLoginBox.jobProfile);
      if (raw == null || raw.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }

      final json = decoded.map((key, value) => MapEntry(key.toString(), value));
      if (!_isCurrentUserScopedJson(json)) {
        return null;
      }

      final profile = LoginJobProfile.fromJson(json);
      return profile.hasAnyValue ? profile : null;
    } catch (_) {
      return null;
    }
  }

  /// 학교 프로필 정보를 저장한다.
  static Future<void> saveEducationProfile(
    LoginEducationProfile? profile,
  ) async {
    if (profile == null || !profile.hasAnyValue) {
      await HiveUtil.delete(HiveLoginBox.educationProfile);
      return;
    }

    await HiveUtil.write(
      key: HiveLoginBox.educationProfile,
      value: jsonEncode({...profile.toJson(), ..._currentUserScopeJson()}),
    );
  }

  /// 저장된 학교 프로필 정보를 읽는다.
  static LoginEducationProfile? readEducationProfile() {
    try {
      final raw = HiveUtil.read(HiveLoginBox.educationProfile);
      if (raw == null || raw.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }

      final json = decoded.map((key, value) => MapEntry(key.toString(), value));
      if (!_isCurrentUserScopedJson(json)) {
        return null;
      }

      final profile = LoginEducationProfile.fromJson(json);
      return profile.hasAnyValue ? profile : null;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _currentUserScopeJson() {
    final userId = HiveUtil.read(HiveLoginBox.userId);
    return userId == null ? const {} : {'userId': userId};
  }

  static bool _isCurrentUserScopedJson(Map<String, dynamic> json) {
    final storedUserId = json['userId']?.toString();
    final currentUserId = HiveUtil.read(HiveLoginBox.userId);
    return storedUserId == null ||
        currentUserId == null ||
        storedUserId == currentUserId;
  }
}
