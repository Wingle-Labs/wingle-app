/// 서버 API 엔드포인트를 중앙에서 관리하는 클래스.
///
/// `API_BASE_URL`은 `https://test.wingle.kr`처럼 host만 포함하므로
/// 이 파일의 경로는 `/api/v1` prefix를 포함한다.
class ApiEndpoints {
  /// 인스턴스 생성을 방지하기 위한 private 생성자.
  ApiEndpoints._();

  // ! -------------------------------------------------------------------------
  // ! Auth Domain
  // ! -------------------------------------------------------------------------

  /// POST /api/v1/auth/login
  static const String authLogin = '/api/v1/auth/login';

  /// POST /api/v1/auth/logout
  static const String authLogout = '/api/v1/auth/logout';

  /// POST /api/v1/auth/reissue
  static const String authReissue = '/api/v1/auth/reissue';

  /// POST /api/v1/auth/signup/terms
  static const String signupTerms = '/api/v1/auth/signup/terms';

  /// POST /api/v1/auth/signup/profile
  static const String signupProfile = '/api/v1/auth/signup/profile';

  /// POST /api/v1/auth/signup/password
  static const String signupPassword = '/api/v1/auth/signup/password';

  /// POST /api/v1/auth/signup/identity-verification
  static const String signupIdentityVerification =
      '/api/v1/auth/signup/identity-verification';

  /// GET /api/v1/auth/signup/nickname/random
  static const String signupNicknameRandom =
      '/api/v1/auth/signup/nickname/random';

  // ! -------------------------------------------------------------------------
  // ! Profile Domain
  // ! -------------------------------------------------------------------------

  /// PUT /api/v1/user/profile
  static const String userProfile = '/api/v1/user/profile';

  /// GET /api/v1/profiles/me
  static const String meProfile = '/api/v1/profiles/me';

  /// POST /api/v1/user/profile/job
  static const String profileJob = '/api/v1/user/profile/job';

  /// PUT /api/v1/user/profile/job
  static const String profileJobReapply = '/api/v1/user/profile/job';

  /// POST /api/v1/user/profile/job/email-verifications
  static const String profileJobEmailVerifications =
      '/api/v1/user/profile/job/email-verifications';

  /// POST /api/v1/user/profile/job/email-verifications/confirm
  static const String profileJobEmailVerificationsConfirm =
      '/api/v1/user/profile/job/email-verifications/confirm';

  /// POST /api/v1/user/profile/education
  static const String profileEducation = '/api/v1/user/profile/education';

  /// PUT /api/v1/user/profile/education
  static const String profileEducationReapply =
      '/api/v1/user/profile/education';

  /// POST /api/v1/user/profile/education/email-verifications
  static const String profileEducationEmailVerifications =
      '/api/v1/user/profile/education/email-verifications';

  /// POST /api/v1/user/profile/education/email-verifications/confirm
  static const String profileEducationEmailVerificationsConfirm =
      '/api/v1/user/profile/education/email-verifications/confirm';

  /// POST /api/v1/user/profile/education/certification
  static const String profileEducationCertification =
      '/api/v1/user/profile/education/certification';

  /// POST /api/v1/profiles/detail
  static const String profileDetail = '/api/v1/profiles/detail';

  /// PUT /api/v1/profiles/detail
  static const String profileDetailReapply = '/api/v1/profiles/detail';

  /// POST /api/v1/profiles/approval/request
  static const String profileApprovalRequest =
      '/api/v1/profiles/approval/request';

  /// POST /api/v1/profiles/reapply
  static const String profileReapply = '/api/v1/profiles/reapply';

  /// GET /api/v1/profiles/rejection-reason
  static const String profileRejectionReason =
      '/api/v1/profiles/rejection-reason';

  // ! -------------------------------------------------------------------------
  // ! Codebook Domain
  // ! -------------------------------------------------------------------------

  /// GET /api/v1/terms/snapshot
  static const String termsSnapshot = '/api/v1/terms/snapshot';

  /// GET /api/v1/terms/current-versions
  static const String termsCurrentVersions = '/api/v1/terms/current-versions';

  /// GET /api/v1/codebook/snapshot
  static const String codebookSnapshot = '/api/v1/codebook/snapshot';

  /// GET /api/v1/codebook/current-versions
  static const String codebookCurrentVersions =
      '/api/v1/codebook/current-versions';

  /// GET /api/v1/choice-questions/snapshot
  static const String choiceQuestionsSnapshot =
      '/api/v1/choice-questions/snapshot';

  /// GET /api/v1/choice-questions/current-versions
  static const String choiceQuestionsCurrentVersions =
      '/api/v1/choice-questions/current-versions';

  /// GET /api/v1/essay-questions/snapshot
  static const String essayQuestionsSnapshot =
      '/api/v1/essay-questions/snapshot';

  /// GET /api/v1/essay-questions/current-versions
  static const String essayQuestionsCurrentVersions =
      '/api/v1/essay-questions/current-versions';

  // ! -------------------------------------------------------------------------
  // ! Answer Domain
  // ! -------------------------------------------------------------------------

  /// GET /api/v1/choice-questions/answers
  static const String choiceQuestionAnswers =
      '/api/v1/choice-questions/answers';

  /// GET /api/v1/essay-questions/answers
  static const String essayQuestionAnswers = '/api/v1/essay-questions/answers';

  // ! -------------------------------------------------------------------------
  // ! File Domain
  // ! -------------------------------------------------------------------------

  /// GET /api/v1/files/presigned/style
  static const String styleImagePresign = '/api/v1/files/presigned/style';

  /// GET /api/v1/files/presigned/face
  static const String faceImagePresign = '/api/v1/files/presigned/face';

  /// GET /api/v1/files/presigned/certification
  static const String certificationPresign =
      '/api/v1/files/presigned/certification';

  // ! -------------------------------------------------------------------------
  // ! Contact Domain
  // ! -------------------------------------------------------------------------

  /// POST /api/v1/contacts
  static const String contacts = '/api/v1/contacts';

  // ! -------------------------------------------------------------------------
  // ! Notification Domain
  // ! -------------------------------------------------------------------------

  /// POST /api/v1/notifications/token
  static const String notificationToken = '/api/v1/notifications/token';

  // ! -------------------------------------------------------------------------
  // ! Health Domain
  // ! -------------------------------------------------------------------------

  /// GET /api/v1/healthcheck
  static const String healthcheck = '/api/v1/healthcheck';
}
