/// 로그인 시점의 온보딩 진행 상태.
enum LoginProfileStatus {
  /// 비밀번호 등록까지 완료되어 User가 생성됨
  signupCompleted,

  /// 기본 프로필 등록 완료
  basicInfoCompleted,

  /// 직장 정보 등록 완료
  jobInfoCompleted,

  /// 학력 정보 등록 완료
  educationInfoCompleted,

  /// 상세 프로필 등록 완료
  profileCompleted,

  /// 관리자 심사 대기
  awaitingApproval,

  /// 관리자 승인 완료
  profileApproved,

  /// 관리자 거절 완료
  profileRejected,

  /// 객관식 질문 답변 완료
  choiceQuestionCompleted,

  /// 주관식 질문 답변 완료
  essayQuestionCompleted,

  /// 온보딩 최종 완료
  onboardingCompleted;

  /// API 문자열 값을 enum으로 변환한다.
  static LoginProfileStatus fromApiValue(String? value) {
    switch (_normalize(value)) {
      case 'SIGNUP_COMPLETED':
      case 'BEFORE_BASIC_PROFILE':
        return LoginProfileStatus.signupCompleted;
      case 'BASIC_INFO_COMPLETED':
      case 'BEFORE_COMPANY_INFO':
      case 'BEFORE_COMPANY_EMAIL_VERIFICATION':
        return LoginProfileStatus.basicInfoCompleted;
      case 'JOB_INFO_COMPLETED':
      case 'BEFORE_SCHOOL_INFO':
      case 'BEFORE_SCHOOL_EMAIL_VERIFICATION':
        return LoginProfileStatus.jobInfoCompleted;
      case 'EDUCATION_INFO_COMPLETED':
      case 'BEFORE_PROFILE_DETAILS':
      case 'BEFORE_PROFILE_IMAGE_PRESIGN':
        return LoginProfileStatus.educationInfoCompleted;
      case 'PROFILE_COMPLETED':
        return LoginProfileStatus.profileCompleted;
      case 'AWAITING_APPROVAL':
      case 'FIRST_APPROVAL_PENDING':
        return LoginProfileStatus.awaitingApproval;
      case 'PROFILE_APPROVED':
      case 'FIRST_APPROVAL_APPROVED':
        return LoginProfileStatus.profileApproved;
      case 'PROFILE_REJECTED':
      case 'FIRST_APPROVAL_REJECTED':
        return LoginProfileStatus.profileRejected;
      case 'CHOICE_QUESTION_COMPLETED':
      case 'BEFORE_OBJECTIVE_ANSWERS':
        return LoginProfileStatus.choiceQuestionCompleted;
      case 'ESSAY_QUESTION_COMPLETED':
      case 'BEFORE_SUBJECTIVE_ANSWERS':
        return LoginProfileStatus.essayQuestionCompleted;
      case 'ONBOARDING_COMPLETED':
        return LoginProfileStatus.onboardingCompleted;
      default:
        return LoginProfileStatus.signupCompleted;
    }
  }

  static String _normalize(String? value) {
    if (value == null || value.isEmpty) {
      return 'SIGNUP_COMPLETED';
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
      case LoginProfileStatus.signupCompleted:
        return 'SIGNUP_COMPLETED';
      case LoginProfileStatus.basicInfoCompleted:
        return 'BASIC_INFO_COMPLETED';
      case LoginProfileStatus.jobInfoCompleted:
        return 'JOB_INFO_COMPLETED';
      case LoginProfileStatus.educationInfoCompleted:
        return 'EDUCATION_INFO_COMPLETED';
      case LoginProfileStatus.profileCompleted:
        return 'PROFILE_COMPLETED';
      case LoginProfileStatus.awaitingApproval:
        return 'AWAITING_APPROVAL';
      case LoginProfileStatus.profileApproved:
        return 'PROFILE_APPROVED';
      case LoginProfileStatus.profileRejected:
        return 'PROFILE_REJECTED';
      case LoginProfileStatus.choiceQuestionCompleted:
        return 'CHOICE_QUESTION_COMPLETED';
      case LoginProfileStatus.essayQuestionCompleted:
        return 'ESSAY_QUESTION_COMPLETED';
      case LoginProfileStatus.onboardingCompleted:
        return 'ONBOARDING_COMPLETED';
    }
  }

  /// Home 진입이 가능한 최종 완료 상태인지 확인한다.
  bool get isCompleted => this == LoginProfileStatus.onboardingCompleted;

  /// 기본 프로필 입력이 필요한 상태인지 확인한다.
  bool get needsBasicProfile => this == LoginProfileStatus.signupCompleted;

  /// 회사 정보 입력이 필요한 상태인지 확인한다.
  bool get needsJobInfo => this == LoginProfileStatus.basicInfoCompleted;

  /// 심사 대기 상태인지 확인한다.
  bool get isPendingApproval => this == LoginProfileStatus.awaitingApproval;

  /// 심사 반려 상태인지 확인한다.
  bool get isRejected => this == LoginProfileStatus.profileRejected;

  /// 아직 온보딩 프로세스에 있는지 확인한다.
  bool get requiresOnboarding => !isCompleted;
}
