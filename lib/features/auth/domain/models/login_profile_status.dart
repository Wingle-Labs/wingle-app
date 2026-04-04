/// 로그인 시점의 프로필 진행 상태.
enum LoginProfileStatus {
  /// 기본 프로필 정보 등록 전
  beforeBasicProfile,

  /// 회사 정보 등록 전
  beforeCompanyInfo,

  /// 회사 이메일 인증 요청 전
  beforeCompanyEmailVerification,

  /// 학교 정보 등록 전
  beforeSchoolInfo,

  /// 학교 이메일 인증 전
  beforeSchoolEmailVerification,

  /// 세부 프로필 정보 등록 전
  beforeProfileDetails,

  /// 프로필 이미지 presigned URL 발급 전
  beforeProfileImagePresign,

  /// 객관식 질문 답변 등록 전
  beforeObjectiveAnswers,

  /// 선택형 주관식 질문 답변 등록 전
  beforeSubjectiveAnswers,

  /// 프로필 첫 승인 대기 중
  firstApprovalPending,

  /// 프로필 첫 승인 완료
  firstApprovalApproved,

  /// 프로필 첫 승인 반려
  firstApprovalRejected;

  /// API 문자열 값을 enum으로 변환한다.
  static LoginProfileStatus fromApiValue(String? value) {
    switch (_normalize(value)) {
      case 'BEFORE_BASIC_PROFILE':
        return LoginProfileStatus.beforeBasicProfile;
      case 'BEFORE_COMPANY_INFO':
        return LoginProfileStatus.beforeCompanyInfo;
      case 'BEFORE_COMPANY_EMAIL_VERIFICATION':
        return LoginProfileStatus.beforeCompanyEmailVerification;
      case 'BEFORE_SCHOOL_INFO':
        return LoginProfileStatus.beforeSchoolInfo;
      case 'BEFORE_SCHOOL_EMAIL_VERIFICATION':
        return LoginProfileStatus.beforeSchoolEmailVerification;
      case 'BEFORE_PROFILE_DETAILS':
        return LoginProfileStatus.beforeProfileDetails;
      case 'BEFORE_PROFILE_IMAGE_PRESIGN':
        return LoginProfileStatus.beforeProfileImagePresign;
      case 'BEFORE_OBJECTIVE_ANSWERS':
        return LoginProfileStatus.beforeObjectiveAnswers;
      case 'BEFORE_SUBJECTIVE_ANSWERS':
        return LoginProfileStatus.beforeSubjectiveAnswers;
      case 'FIRST_APPROVAL_PENDING':
        return LoginProfileStatus.firstApprovalPending;
      case 'FIRST_APPROVAL_REJECTED':
        return LoginProfileStatus.firstApprovalRejected;
      case 'FIRST_APPROVAL_APPROVED':
      default:
        return LoginProfileStatus.firstApprovalApproved;
    }
  }

  static String _normalize(String? value) {
    if (value == null || value.isEmpty) {
      return 'FIRST_APPROVAL_APPROVED';
    }

    final withUnderscores = value
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .toUpperCase();

    return withUnderscores;
  }

  /// API로 보낼 문자열 값.
  String get apiValue {
    switch (this) {
      case LoginProfileStatus.beforeBasicProfile:
        return 'BEFORE_BASIC_PROFILE';
      case LoginProfileStatus.beforeCompanyInfo:
        return 'BEFORE_COMPANY_INFO';
      case LoginProfileStatus.beforeCompanyEmailVerification:
        return 'BEFORE_COMPANY_EMAIL_VERIFICATION';
      case LoginProfileStatus.beforeSchoolInfo:
        return 'BEFORE_SCHOOL_INFO';
      case LoginProfileStatus.beforeSchoolEmailVerification:
        return 'BEFORE_SCHOOL_EMAIL_VERIFICATION';
      case LoginProfileStatus.beforeProfileDetails:
        return 'BEFORE_PROFILE_DETAILS';
      case LoginProfileStatus.beforeProfileImagePresign:
        return 'BEFORE_PROFILE_IMAGE_PRESIGN';
      case LoginProfileStatus.beforeObjectiveAnswers:
        return 'BEFORE_OBJECTIVE_ANSWERS';
      case LoginProfileStatus.beforeSubjectiveAnswers:
        return 'BEFORE_SUBJECTIVE_ANSWERS';
      case LoginProfileStatus.firstApprovalPending:
        return 'FIRST_APPROVAL_PENDING';
      case LoginProfileStatus.firstApprovalApproved:
        return 'FIRST_APPROVAL_APPROVED';
      case LoginProfileStatus.firstApprovalRejected:
        return 'FIRST_APPROVAL_REJECTED';
    }
  }

  /// 첫 승인 완료 상태인지 확인한다.
  bool get isApproved => this == LoginProfileStatus.firstApprovalApproved;

  /// 기본 프로필 정보 등록 전 상태인지 확인한다.
  bool get isBeforeBasicProfile =>
      this == LoginProfileStatus.beforeBasicProfile;

  /// 첫 승인 대기 상태인지 확인한다.
  bool get isPendingApproval => this == LoginProfileStatus.firstApprovalPending;

  /// 첫 승인 반려 상태인지 확인한다.
  bool get isRejected => this == LoginProfileStatus.firstApprovalRejected;

  /// 아직 프로필 입력 프로세스에 있는지 확인한다.
  bool get requiresProfileInput => index <= beforeSubjectiveAnswers.index;
}
