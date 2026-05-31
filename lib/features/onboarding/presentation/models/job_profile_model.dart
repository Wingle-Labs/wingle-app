import 'package:wingle/features/onboarding/domain/model/profile/job_occupation_policy.dart';

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

/// 직장 정보 입력 상태.
class JobProfileModel {
  /// 회사명.
  final String company;

  /// 직업 코드.
  final String? occupationCode;

  /// 직업 표시명.
  final String? occupationName;

  /// 직장 이메일 인증 완료 여부.
  final bool emailVerified;

  /// 제출 중 여부.
  final bool isSubmitting;

  /// 제출 실패 메시지.
  final String? submitErrorMessage;

  /// 회사 이메일.
  final String email;

  /// 회사 이메일 인증번호.
  final String verificationCode;

  /// 이메일 인증번호 전송 여부.
  final bool isVerificationCodeSent;

  /// 이메일 인증 실패 메시지.
  final String? emailVerificationErrorMessage;

  /// 이메일 인증번호 확인 실패 메시지.
  final String? verificationCodeErrorMessage;

  /// 생성자.
  const JobProfileModel({
    this.company = '',
    this.occupationCode,
    this.occupationName,
    this.emailVerified = false,
    this.isSubmitting = false,
    this.submitErrorMessage,
    this.email = '',
    this.verificationCode = '',
    this.isVerificationCodeSent = false,
    this.emailVerificationErrorMessage,
    this.verificationCodeErrorMessage,
  });

  /// 직종 선택 완료 여부.
  bool get hasOccupation =>
      occupationCode != null && occupationCode!.trim().isNotEmpty;

  /// 회사명 입력과 이메일 인증이 필요한 직종인지 여부.
  bool get requiresCompany =>
      JobOccupationPolicy.requiresCompany(occupationCode);

  /// 회사명/이메일 단계를 건너뛰는 직종인지 여부.
  bool get skipsCompanyAndEmail =>
      JobOccupationPolicy.skipsCompanyAndEmail(occupationCode);

  /// 회사 입력 단계 진행 가능 여부.
  bool get canContinueCompany =>
      hasOccupation && (!requiresCompany || company.trim().isNotEmpty);

  /// 이메일 인증번호 전송 가능 여부.
  bool get canSendVerificationEmail => _isCompanyEmail(email);

  /// 이메일 인증 확인 가능 여부.
  bool get canConfirmVerificationCode =>
      canSendVerificationEmail &&
      verificationCode.trim().replaceAll(RegExp(r'[^0-9]'), '').isNotEmpty;

  /// 값 복사.
  JobProfileModel copyWith({
    String? company,
    String? occupationCode,
    String? occupationName,
    bool? emailVerified,
    bool? isSubmitting,
    String? submitErrorMessage,
    String? email,
    String? verificationCode,
    bool? isVerificationCodeSent,
    String? emailVerificationErrorMessage,
    String? verificationCodeErrorMessage,
  }) {
    return JobProfileModel(
      company: company ?? this.company,
      occupationCode: occupationCode ?? this.occupationCode,
      occupationName: occupationName ?? this.occupationName,
      emailVerified: emailVerified ?? this.emailVerified,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitErrorMessage: submitErrorMessage,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      isVerificationCodeSent:
          isVerificationCodeSent ?? this.isVerificationCodeSent,
      emailVerificationErrorMessage: emailVerificationErrorMessage,
      verificationCodeErrorMessage: verificationCodeErrorMessage,
    );
  }

  bool _isCompanyEmail(String value) {
    final trimmed = value.trim().toLowerCase();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return false;
    }

    final domain = trimmed.split('@').last;
    return !_personalEmailDomains.contains(domain);
  }
}
