import 'dart:async';

import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/my_profile_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';

/// 프로필 Repository Mock 구현
class MockProfileRepository implements ProfileRepository {
  /// 생성자.
  const MockProfileRepository({this.profileSnapshot, this.basicProfile});

  /// 테스트용 랜덤 닉네임
  static const String mockNickname = '달콤한 사탕 멜론';

  /// 테스트용 내 기본 프로필 스냅샷.
  final LoginBasicProfile? basicProfile;

  /// 테스트용 내 프로필 스냅샷.
  final MyProfileSnapshot? profileSnapshot;

  @override
  Future<String> fetchRandomNickname() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return mockNickname;
  }

  @override
  Future<MyProfileSnapshot?> fetchMyProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return profileSnapshot ?? MyProfileSnapshot(basicProfile: basicProfile);
  }

  @override
  Future<LoginBasicProfile?> fetchMyBasicProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return profileSnapshot?.basicProfile ?? basicProfile;
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyTypeCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateEducation({
    required String? university,
    required String educationLevel,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> verifyEducationEmail({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> confirmEducationEmail({
    required String email,
    required int verificationCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> submitJob({String? company, required String occupation}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateJob({String? company, required String occupation}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> verifyJobEmail({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> confirmJobEmail({
    required String email,
    required int verificationCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> requestProfileApproval() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> requestProfileReapply() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<RejectionReason> fetchRejectionReason() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const RejectionReason(
      reason: '프로필 사진이 기준에 맞지 않습니다.',
      reviewedAt: '2026-05-01T14:30:00',
    );
  }
}
