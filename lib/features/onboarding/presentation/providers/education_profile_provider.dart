import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_persistence.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_education_profile.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/domain/model/file/file_models.dart';
import 'package:wingle/features/onboarding/presentation/models/education_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/university_codebook_provider.dart';

part 'education_profile_provider.g.dart';

/// 학교 프로필 로컬 저장소.
abstract interface class EducationProfilePersistence {
  /// 저장된 학교 프로필 정보를 읽는다.
  LoginEducationProfile? readEducationProfile();

  /// 학교 프로필 정보를 저장한다.
  Future<void> saveEducationProfile(LoginEducationProfile? profile);
}

/// Hive 기반 학교 프로필 로컬 저장소.
class AuthSessionEducationProfilePersistence
    implements EducationProfilePersistence {
  /// 생성자.
  const AuthSessionEducationProfilePersistence();

  @override
  LoginEducationProfile? readEducationProfile() {
    return AuthSessionPersistence.readEducationProfile();
  }

  @override
  Future<void> saveEducationProfile(LoginEducationProfile? profile) {
    return AuthSessionPersistence.saveEducationProfile(profile);
  }
}

/// 학교 프로필 로컬 저장소 provider.
final educationProfilePersistenceProvider =
    Provider<EducationProfilePersistence>(
      (ref) => const AuthSessionEducationProfilePersistence(),
    );

/// 학교 정보 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class EducationProfile extends _$EducationProfile {
  @override
  EducationProfileModel build() {
    final persistedProfile = ref
        .read(educationProfilePersistenceProvider)
        .readEducationProfile();
    if (persistedProfile == null || !persistedProfile.hasAnyValue) {
      return const EducationProfileModel();
    }

    return _modelFromLoginProfile(persistedProfile);
  }

  /// 학력 수준을 선택한다.
  void selectEducationLevel(EducationLevel educationLevel) {
    if (state.educationLevel == educationLevel) return;

    state = EducationProfileModel(educationLevel: educationLevel);
  }

  /// 학교명을 갱신한다.
  void updateSchoolName(String value) {
    if (state.schoolName == value) return;

    state = state.copyWith(
      schoolName: value,
      universityCode: null,
      isEducationSubmitted: false,
      emailVerified: false,
      submitErrorMessage: null,
      certificationFile: null,
      certificationSubmitted: false,
      certificationKey: null,
      certificationErrorMessage: null,
    );
  }

  /// 코드북 학교 항목을 선택한다.
  void selectUniversityEntry(CodebookEntry entry) {
    if (state.schoolName == entry.codeName &&
        state.universityCode == entry.code) {
      return;
    }

    state = state.copyWith(
      schoolName: entry.codeName,
      universityCode: entry.code,
      isEducationSubmitted: false,
      emailVerified: false,
      submitErrorMessage: null,
      certificationFile: null,
      certificationSubmitted: false,
      certificationKey: null,
      certificationErrorMessage: null,
    );
  }

  /// 학교 이메일을 갱신한다.
  void updateEmail(String value) {
    if (state.email == value) return;

    state = state.copyWith(
      email: value,
      emailVerified: false,
      isVerificationCodeSent: false,
      emailVerificationErrorMessage: null,
      verificationCodeErrorMessage: null,
    );
  }

  /// 학교 이메일 인증번호를 갱신한다.
  void updateVerificationCode(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (state.verificationCode == sanitized) return;

    state = state.copyWith(
      verificationCode: sanitized,
      verificationCodeErrorMessage: null,
    );
  }

  /// 학적 증명서 파일을 선택한다.
  bool selectCertificationFile({
    required String name,
    required String contentType,
    required List<int> bytes,
  }) {
    final normalizedContentType = contentType.trim().toLowerCase();
    if (!FileUploadConstants.supportedImageContentTypes.contains(
          normalizedContentType,
        ) ||
        bytes.isEmpty) {
      state = state.copyWith(
        certificationFile: null,
        certificationSubmitted: false,
        certificationKey: null,
        certificationErrorMessage:
            ApiErrorMessages.submitEducationCertificationFailed,
      );
      return false;
    }

    state = state.copyWith(
      certificationFile: EducationCertificationFile(
        name: name.trim().isEmpty ? 'certification' : name.trim(),
        contentType: normalizedContentType,
        bytes: bytes,
      ),
      certificationSubmitted: false,
      certificationKey: null,
      certificationErrorMessage: null,
    );
    return true;
  }

  /// 선택된 학적 증명서 파일을 제거한다.
  void clearCertificationFile() {
    state = state.copyWith(
      certificationFile: null,
      certificationSubmitted: false,
      certificationKey: null,
      certificationErrorMessage: null,
    );
  }

  /// 학적 증명서를 업로드하고 등록한다.
  Future<bool> submitCertification() async {
    if (state.isSubmitting) return false;

    final file = state.certificationFile;
    if (file == null || file.bytes.isEmpty) {
      state = state.copyWith(
        isSubmitting: false,
        certificationErrorMessage:
            ApiErrorMessages.submitEducationCertificationFailed,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, certificationErrorMessage: null);

    final fileRepository = ref.read(fileRepositoryProvider);

    late final ProfileImagePresignResult presign;
    try {
      presign = await fileRepository.createCertificationPresignedUrl(
        contentType: file.contentType,
      );
    } catch (error, stackTrace) {
      return _failCertification(
        message: ApiErrorMessages.createCertificationPresignedUrlFailed,
        stage: 'presign',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      await fileRepository.uploadBytesToPresignedUrl(
        presignedUrl: presign.presignedUrl,
        bytes: file.bytes,
        contentType: file.contentType,
      );
    } catch (error, stackTrace) {
      return _failCertification(
        message: ApiErrorMessages.uploadFileFailed,
        stage: 'upload',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      await ref
          .read(profileRepositoryProvider)
          .submitEducationCertification(certificationKey: presign.s3Key);
    } catch (error, stackTrace) {
      return _failCertification(
        message: ApiErrorMessages.submitEducationCertificationFailed,
        stage: 'register',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (!ref.mounted) return false;

    state = state.copyWith(
      isSubmitting: false,
      certificationSubmitted: true,
      certificationKey: presign.s3Key,
      certificationErrorMessage: null,
    );
    return true;
  }

  /// 학교 정보를 서버에 업로드한다.
  Future<bool> submitEducation() async {
    if (state.isSubmitting) return false;

    final educationLevel = state.educationLevel;
    final schoolName = state.schoolName.trim();
    if (educationLevel == null ||
        (!educationLevel.skipsSchoolName && schoolName.isEmpty)) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitEducationFailed,
      );
      return false;
    }

    final shouldUpdate = _readProfileStatus().hasCompletedEducationInfo;
    final universityEntries = ref.read(universityCodebookEntriesProvider);
    final universityEntry = educationLevel.skipsSchoolName
        ? null
        : findUniversityEntryByCodeAndName(
                state.universityCode,
                schoolName,
                universityEntries,
              ) ??
              findUniversityEntryByName(schoolName, universityEntries);
    final university = universityEntry?.code;
    final customUniversityName = educationLevel.skipsSchoolName
        ? null
        : university == null
        ? schoolName
        : null;

    state = state.copyWith(isSubmitting: true, submitErrorMessage: null);

    try {
      final repository = ref.read(profileRepositoryProvider);
      if (shouldUpdate) {
        await repository.updateEducation(
          university: university,
          customUniversityName: customUniversityName,
          educationLevel: educationLevel.apiValue,
        );
      } else {
        await repository.submitEducation(
          university: university,
          customUniversityName: customUniversityName,
          educationLevel: educationLevel.apiValue,
        );
      }

      if (!shouldUpdate) {
        await HiveUtil.write(
          key: HiveLoginBox.profileStatus,
          value: LoginProfileStatus.educationInfoCompleted.apiValue,
        );
      }
      await ref
          .read(educationProfilePersistenceProvider)
          .saveEducationProfile(
            LoginEducationProfile(
              educationLevel: educationLevel.apiValue,
              schoolName: schoolName,
              universityCode: university,
              customUniversityName: customUniversityName,
              emailVerified: shouldUpdate ? false : state.emailVerified,
            ),
          );

      if (!ref.mounted) return false;

      state = state.copyWith(
        schoolName: schoolName,
        universityCode: university,
        isEducationSubmitted: true,
        emailVerified: shouldUpdate ? false : state.emailVerified,
        isSubmitting: false,
        submitErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        submitErrorMessage: ApiErrorMessages.submitEducationFailed,
      );
      return false;
    }
  }

  /// 학교 이메일 인증번호를 전송한다.
  Future<bool> sendVerificationEmail() async {
    if (state.isSubmitting) return false;
    final email = state.email.trim();
    if (!state.canSendVerificationEmail) {
      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage:
            ApiErrorMessages.verifyEducationEmailFailed,
        verificationCodeErrorMessage: null,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      emailVerificationErrorMessage: null,
      verificationCodeErrorMessage: null,
    );

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.verifyEducationEmail(email: email);

      if (!ref.mounted) return false;

      state = state.copyWith(
        email: email,
        isSubmitting: false,
        isVerificationCodeSent: true,
        emailVerificationErrorMessage: null,
        verificationCodeErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage:
            ApiErrorMessages.verifyEducationEmailFailed,
        verificationCodeErrorMessage: null,
      );
      return false;
    }
  }

  /// 학교 이메일 인증번호를 확인한다.
  Future<bool> confirmVerificationCode() async {
    if (state.isSubmitting) return false;
    final email = state.email.trim();
    final code = int.tryParse(state.verificationCode.trim());
    if (!state.canConfirmVerificationCode || code == null) {
      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: null,
        verificationCodeErrorMessage:
            ApiErrorMessages.verifyEducationEmailFailed,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      emailVerificationErrorMessage: null,
      verificationCodeErrorMessage: null,
    );

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.confirmEducationEmail(
        email: email,
        verificationCode: code,
      );

      if (!ref.mounted) return false;

      state = state.copyWith(
        email: email,
        emailVerified: true,
        isSubmitting: false,
        emailVerificationErrorMessage: null,
        verificationCodeErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        emailVerificationErrorMessage: null,
        verificationCodeErrorMessage:
            ApiErrorMessages.verifyEducationEmailFailed,
      );
      return false;
    }
  }

  LoginProfileStatus _readProfileStatus() {
    try {
      final rawValue = HiveUtil.read(HiveLoginBox.profileStatus);
      return LoginProfileStatus.fromApiValue(rawValue);
    } catch (_) {
      return LoginProfileStatus.signupCompleted;
    }
  }

  EducationProfileModel _modelFromLoginProfile(LoginEducationProfile profile) {
    return EducationProfileModel(
      educationLevel: _educationLevelFromApiValue(profile.educationLevel),
      schoolName: profile.schoolName?.trim() ?? '',
      universityCode: _nonEmpty(profile.universityCode),
      emailVerified: profile.emailVerified ?? false,
    );
  }

  EducationLevel? _educationLevelFromApiValue(String? value) {
    final apiValue = _nonEmpty(value);
    if (apiValue == null) {
      return null;
    }

    for (final level in EducationLevel.values) {
      if (level.apiValue == apiValue) {
        return level;
      }
    }

    return null;
  }

  String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  bool _failCertification({
    required String message,
    required String stage,
    required Object error,
    required StackTrace stackTrace,
  }) {
    debugPrint('Failed to submit education certification at $stage: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (!ref.mounted) return false;

    state = state.copyWith(
      isSubmitting: false,
      certificationSubmitted: false,
      certificationErrorMessage: message,
    );
    return false;
  }
}
