import 'dart:async';

import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

/// 프로필 Repository Mock 구현
class MockProfileRepository implements ProfileRepository {
  /// 테스트용 랜덤 닉네임
  static const String mockNickname = '달콤한 사탕 멜론';

  @override
  Future<String> fetchRandomNickname() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return mockNickname;
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> verifyEducationEmail({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> submitJob({
    required String company,
    required String occupation,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> verifyJobEmail({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
