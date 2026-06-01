import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/domain/constants/file_upload_constants.dart';
import 'package:wingle/features/onboarding/presentation/models/education_profile_model.dart';
import 'package:wingle/features/onboarding/presentation/providers/file_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/university_codebook_provider.dart';

part 'education_profile_provider.g.dart';

/// 학교 정보 입력 상태를 관리하는 Notifier.
@Riverpod(keepAlive: true)
class EducationProfile extends _$EducationProfile {
  @override
  EducationProfileModel build() {
    return const EducationProfileModel();
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

    try {
      final fileRepository = ref.read(fileRepositoryProvider);
      final presign = await fileRepository.createCertificationPresignedUrl(
        contentType: file.contentType,
      );
      await fileRepository.uploadBytesToPresignedUrl(
        presignedUrl: presign.presignedUrl,
        bytes: file.bytes,
        contentType: file.contentType,
      );
      await ref
          .read(profileRepositoryProvider)
          .submitEducationCertification(certificationKey: presign.s3Key);

      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        certificationSubmitted: true,
        certificationKey: presign.s3Key,
        certificationErrorMessage: null,
      );
      return true;
    } catch (_) {
      if (!ref.mounted) return false;

      state = state.copyWith(
        isSubmitting: false,
        certificationSubmitted: false,
        certificationErrorMessage:
            ApiErrorMessages.submitEducationCertificationFailed,
      );
      return false;
    }
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
    final universityEntry = educationLevel.skipsSchoolName
        ? null
        : findUniversityEntryByName(
            schoolName,
            ref.read(universityCodebookEntriesProvider),
          );
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
}
