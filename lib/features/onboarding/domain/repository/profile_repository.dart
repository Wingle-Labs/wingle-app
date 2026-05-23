import 'package:wingle/features/onboarding/domain/model/profile/rejection_reason.dart';
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
    required String bodyTypeCode,
  });

  /// 세부 프로필 정보를 등록한다.
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
    String? mainStylePhotoKey,
    List<String> subStylePhotoKeys = const <String>[],
    String? mainFacePhotoKey,
    List<String> subFacePhotoKeys = const <String>[],
  });

  /// 학교 정보를 등록한다.
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  });

  /// 학교 이메일 인증을 요청한다.
  Future<void> verifyEducationEmail({required String email});

  /// 학교 이메일 인증 코드를 확인한다.
  Future<void> confirmEducationEmail({
    required String email,
    required int verificationCode,
  });

  /// 회사 정보를 등록한다.
  Future<void> submitJob({required String company, required String occupation});

  /// 회사 이메일 인증을 요청한다.
  Future<void> verifyJobEmail({required String email});

  /// 회사 이메일 인증 코드를 확인한다.
  Future<void> confirmJobEmail({
    required String email,
    required int verificationCode,
  });

  /// 프로필 심사를 요청한다.
  Future<void> requestProfileApproval();

  /// 프로필 재심사를 요청한다.
  Future<void> requestProfileReapply();

  /// 최근 거절 사유를 조회한다.
  Future<RejectionReason> fetchRejectionReason();
}
