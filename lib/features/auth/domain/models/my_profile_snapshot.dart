import 'package:wingle/features/auth/domain/models/login_basic_profile.dart';
import 'package:wingle/features/auth/domain/models/login_education_profile.dart';
import 'package:wingle/features/auth/domain/models/login_job_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_details.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';

/// `GET /api/v1/profiles/me` 응답에서 온보딩 복원에 필요한 프로필 스냅샷.
class MyProfileSnapshot {
  /// 온보딩 진행 상태.
  final LoginProfileStatus? onboardingStatus;

  /// 기본 프로필 정보.
  final LoginBasicProfile? basicProfile;

  /// 직장 프로필 정보.
  final LoginJobProfile? jobProfile;

  /// 학교 프로필 정보.
  final LoginEducationProfile? educationProfile;

  /// 상세 프로필 정보.
  final LoginProfileDetails? profileDetails;

  /// 생성자.
  const MyProfileSnapshot({
    this.onboardingStatus,
    this.basicProfile,
    this.jobProfile,
    this.educationProfile,
    this.profileDetails,
  });

  /// JSON 객체에서 프로필 스냅샷을 만든다.
  factory MyProfileSnapshot.fromJson(Map<String, dynamic> json) {
    final basicProfile = LoginBasicProfile.fromJson(json);
    final jobJson = _asStringKeyedMap(json['job']);
    final jobProfile = jobJson == null
        ? null
        : LoginJobProfile.fromJson(jobJson);
    final educationProfile = LoginEducationProfile.fromJson(json);
    final profileDetails = LoginProfileDetails.fromJson(json);
    final rawStatus =
        json['onboardingStatus'] ?? json['onboarding_status'] ?? json['status'];

    return MyProfileSnapshot(
      onboardingStatus: rawStatus == null
          ? null
          : LoginProfileStatus.fromApiValue(rawStatus.toString()),
      basicProfile: basicProfile.hasAnyValue ? basicProfile : null,
      jobProfile: jobProfile != null && jobProfile.hasAnyValue
          ? jobProfile
          : null,
      educationProfile: educationProfile.hasAnyValue ? educationProfile : null,
      profileDetails: profileDetails.hasAnyValue ? profileDetails : null,
    );
  }

  /// 저장할 값이 하나라도 있는지 여부.
  bool get hasAnyValue =>
      onboardingStatus != null ||
      basicProfile != null ||
      jobProfile != null ||
      educationProfile != null ||
      profileDetails != null;

  static Map<String, dynamic>? _asStringKeyedMap(Object? value) {
    if (value is! Map) return null;
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
}
