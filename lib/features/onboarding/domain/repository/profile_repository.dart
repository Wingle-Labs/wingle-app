import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';

/// 프로필 관련 Repository 인터페이스.
abstract class ProfileRepository {
  /// 랜덤 닉네임을 조회한다.
  Future<String> fetchRandomNickname();

  /// 기본 프로필 정보를 등록한다.
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  });

  /// 세부 프로필 정보를 등록한다.
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
  });

  /// 학교 정보를 등록한다.
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  });

  /// 학교 이메일 인증을 요청한다.
  Future<void> verifyEducationEmail({required String email});

  /// 회사 정보를 등록한다.
  Future<void> submitJob({required String company, required String occupation});

  /// 회사 이메일 인증을 요청한다.
  Future<void> verifyJobEmail({required String email});
}
