const Set<String> _personalEmailDomains = {
  'gmail.com',
  'googlemail.com',
  'naver.com',
  'hanmail.net',
  'daum.net',
  'kakao.com',
  'nate.com',
  'outlook.com',
  'hotmail.com',
  'icloud.com',
  'yahoo.com',
  'proton.me',
  'protonmail.com',
};

const Object _undefined = Object();

/// 선택된 학적 증명서 파일.
class EducationCertificationFile {
  /// 원본 파일명.
  final String name;

  /// MIME 타입.
  final String contentType;

  /// 파일 바이트.
  final List<int> bytes;

  /// 생성자.
  EducationCertificationFile({
    required this.name,
    required this.contentType,
    required List<int> bytes,
  }) : bytes = List<int>.unmodifiable(bytes);

  /// 파일 크기.
  int get sizeInBytes => bytes.length;
}

/// 학력 수준.
enum EducationLevel {
  /// 고등학교.
  highSchool(
    apiValue: 'HIGH_SCHOOL',
    labelKey: 'onboarding.basicProfile.education.option.highSchool',
  ),

  /// 전문대.
  juniorCollege(
    apiValue: 'JUNIOR_COLLEGE',
    labelKey: 'onboarding.basicProfile.education.option.juniorCollege',
  ),

  /// 대학교.
  university(
    apiValue: 'UNIVERSITY',
    labelKey: 'onboarding.basicProfile.education.option.university',
  ),

  /// 석사.
  master(
    apiValue: 'MASTER',
    labelKey: 'onboarding.basicProfile.education.option.master',
  ),

  /// 박사.
  doctorate(
    apiValue: 'DOCTORATE',
    labelKey: 'onboarding.basicProfile.education.option.doctorate',
  ),

  /// 기타.
  other(
    apiValue: 'OTHER',
    labelKey: 'onboarding.basicProfile.education.option.other',
  );

  /// API enum 값.
  final String apiValue;

  /// 표시용 번역 키.
  final String labelKey;

  /// 생성자.
  const EducationLevel({required this.apiValue, required this.labelKey});

  /// 학교명 입력을 건너뛰는 학력인지 여부.
  bool get skipsSchoolName => false;

  /// 학교 이메일/학적 증명 인증을 건너뛰는 학력인지 여부.
  bool get skipsEducationVerification =>
      this == EducationLevel.highSchool || this == EducationLevel.other;
}

/// 학교 정보 입력 상태.
class EducationProfileModel {
  /// 선택한 학력 수준.
  final EducationLevel? educationLevel;

  /// 학교명.
  final String schoolName;

  /// 코드북에 매칭된 학교 코드.
  final String? universityCode;

  /// 학교 정보 제출 완료 여부.
  final bool isEducationSubmitted;

  /// 학교 이메일 인증 완료 여부.
  final bool emailVerified;

  /// 제출 중 여부.
  final bool isSubmitting;

  /// 제출 실패 메시지.
  final String? submitErrorMessage;

  /// 학교 이메일.
  final String email;

  /// 학교 이메일 인증번호.
  final String verificationCode;

  /// 이메일 인증번호 전송 여부.
  final bool isVerificationCodeSent;

  /// 이메일 인증 실패 메시지.
  final String? emailVerificationErrorMessage;

  /// 이메일 인증번호 확인 실패 메시지.
  final String? verificationCodeErrorMessage;

  /// 선택된 학적 증명서 파일.
  final EducationCertificationFile? certificationFile;

  /// 학적 증명서 등록 완료 여부.
  final bool certificationSubmitted;

  /// 학적 증명서 등록에 사용된 S3 key.
  final String? certificationKey;

  /// 학적 증명서 등록 실패 메시지.
  final String? certificationErrorMessage;

  /// 생성자.
  const EducationProfileModel({
    this.educationLevel,
    this.schoolName = '',
    this.universityCode,
    this.isEducationSubmitted = false,
    this.emailVerified = false,
    this.isSubmitting = false,
    this.submitErrorMessage,
    this.email = '',
    this.verificationCode = '',
    this.isVerificationCodeSent = false,
    this.emailVerificationErrorMessage,
    this.verificationCodeErrorMessage,
    this.certificationFile,
    this.certificationSubmitted = false,
    this.certificationKey,
    this.certificationErrorMessage,
  });

  /// 학력 선택 단계 진행 가능 여부.
  bool get canContinueEducationLevel => educationLevel != null;

  /// 학교명 입력이 필요한지 여부.
  bool get requiresSchoolName =>
      educationLevel != null && !educationLevel!.skipsSchoolName;

  /// 학교명 단계 진행 가능 여부.
  bool get canContinueSchool =>
      canContinueEducationLevel &&
      (!requiresSchoolName || schoolName.trim().isNotEmpty);

  /// 이메일 인증번호 전송 가능 여부.
  bool get canSendVerificationEmail => _isSchoolEmail(email);

  /// 이메일 인증 확인 가능 여부.
  bool get canConfirmVerificationCode =>
      canSendVerificationEmail &&
      verificationCode.trim().replaceAll(RegExp(r'[^0-9]'), '').isNotEmpty;

  /// 학적 증명서 제출 가능 여부.
  bool get canSubmitCertification =>
      certificationFile != null && certificationFile!.bytes.isNotEmpty;

  /// 값 복사.
  EducationProfileModel copyWith({
    EducationLevel? educationLevel,
    String? schoolName,
    Object? universityCode = _undefined,
    bool? isEducationSubmitted,
    bool? emailVerified,
    bool? isSubmitting,
    String? submitErrorMessage,
    String? email,
    String? verificationCode,
    bool? isVerificationCodeSent,
    String? emailVerificationErrorMessage,
    String? verificationCodeErrorMessage,
    Object? certificationFile = _undefined,
    bool? certificationSubmitted,
    Object? certificationKey = _undefined,
    String? certificationErrorMessage,
  }) {
    return EducationProfileModel(
      educationLevel: educationLevel ?? this.educationLevel,
      schoolName: schoolName ?? this.schoolName,
      universityCode: universityCode == _undefined
          ? this.universityCode
          : universityCode as String?,
      isEducationSubmitted: isEducationSubmitted ?? this.isEducationSubmitted,
      emailVerified: emailVerified ?? this.emailVerified,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      isVerificationCodeSent:
          isVerificationCodeSent ?? this.isVerificationCodeSent,
      emailVerificationErrorMessage: emailVerificationErrorMessage,
      verificationCodeErrorMessage: verificationCodeErrorMessage,
      certificationFile: certificationFile == _undefined
          ? this.certificationFile
          : certificationFile as EducationCertificationFile?,
      certificationSubmitted:
          certificationSubmitted ?? this.certificationSubmitted,
      certificationKey: certificationKey == _undefined
          ? this.certificationKey
          : certificationKey as String?,
      certificationErrorMessage: certificationErrorMessage,
    );
  }

  bool _isSchoolEmail(String value) {
    final trimmed = value.trim().toLowerCase();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return false;
    }

    final domain = trimmed.split('@').last;
    return !_personalEmailDomains.contains(domain);
  }
}
