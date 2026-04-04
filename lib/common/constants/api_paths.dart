/// 서버 API 엔드포인트를 중앙에서 관리하는 클래스.
///
/// - 모든 REST 경로는 이 파일에서 정의한다.
/// - 문자열 하드코딩을 방지한다.
/// - 경로 변경 시 단일 수정 지점을 보장한다.
/// - 도메인 단위 확장을 고려한 구조를 유지한다.
///
/// 주의:
/// - baseUrl은 포함하지 않는다.
/// - 슬래시(`/`)는 반드시 prefix로 포함한다.
/// - 동적 경로는 함수로 정의한다.
///
/// 예:
///   GET  /terms
///   GET  /terms/1
///   GET  /users/10
class ApiEndpoints {
  /// 인스턴스 생성을 방지하기 위한 private 생성자.
  ApiEndpoints._();

  // ! -------------------------------------------------------------------------
  // ! Terms Domain
  // ! -------------------------------------------------------------------------

  /// 약관 목록 조회
  ///
  /// GET /api/v1/auth/signup/terms
  static const String terms = '/api/v1/auth/signup/terms';

  /// 특정 약관 상세 조회
  ///
  /// GET /terms/{id}
  static String termDetail(int id) => '/terms/$id';

  // ! -------------------------------------------------------------------------
  // ! Auth Domain
  // ! -------------------------------------------------------------------------

  /// ID/PW 로그인
  ///
  /// POST /api/v1/auth/login
  static const String authLogin = '/api/v1/auth/login';

  /// 회원가입 비밀번호 등록
  ///
  /// POST /api/v1/auth/signup/password
  static const String signupPassword = '/api/v1/auth/signup/password';

  /// 본인인증 결과 등록
  ///
  /// POST /api/v1/auth/signup/identity-verification
  static const String signupIdentityVerification =
      '/api/v1/auth/signup/identity-verification';

  // ! -------------------------------------------------------------------------
  // ! Signup / Profile Domain
  // ! -------------------------------------------------------------------------

  /// 랜덤 닉네임 생성
  ///
  /// GET /api/v1/signup/nickname/random
  static const String signupNicknameRandom = '/api/v1/signup/nickname/random';

  /// 기본 프로필 정보 등록
  ///
  /// POST /api/v1/signup/profile
  static const String signupProfile = '/api/v1/signup/profile';

  /// 세부 프로필 정보 등록
  ///
  /// POST /api/v1/signup/profile/details
  static const String signupProfileDetails = '/api/v1/signup/profile/details';

  /// 학교 정보 등록
  ///
  /// POST /api/v1/users/profile/education
  static const String profileEducation = '/api/v1/users/profile/education';

  /// 학교 이메일 인증
  ///
  /// POST /api/v1/users/profile/education/verification
  static const String profileEducationVerification =
      '/api/v1/users/profile/education/verification';

  /// 회사 정보 등록
  ///
  /// POST /api/v1/users/profile/job
  static const String profileJob = '/api/v1/users/profile/job';

  /// 회사 이메일 인증
  ///
  /// POST /api/v1/users/profile/job/verification
  static const String profileJobVerification =
      '/api/v1/users/profile/job/verification';

  // ! -------------------------------------------------------------------------
  // ! Questions Domain
  // ! -------------------------------------------------------------------------

  /// 질문 조회
  ///
  /// GET /api/v1/questions?type=OBJECTIVE
  static String questions(String type) => '/api/v1/questions?type=$type';

  /// 객관식 질문 답변 등록
  ///
  /// POST /api/v1/users/objective_questions/answer
  static const String objectiveQuestionAnswers =
      '/api/v1/users/objective_questions/answer';

  /// 주관식 질문 답변 등록
  ///
  /// POST /api/v1/users/subjective_questions/answer
  static const String subjectiveQuestionAnswers =
      '/api/v1/users/subjective_questions/answer';

  // ! -------------------------------------------------------------------------
  // ! File Domain
  // ! -------------------------------------------------------------------------

  /// 프로필 이미지 presigned url 발급
  ///
  /// POST /api/v1/files/presigned/profile
  static const String profileImagePresign = '/api/v1/files/presigned/profile';

  /// 파일 업로드 url 발급
  ///
  /// POST /api/v1/files/uploads/presign
  static const String fileUploadPresign = '/api/v1/files/uploads/presign';

  /// 파일 업로드 완료 통지
  ///
  /// POST /api/v1/files/uploads/complete
  static const String fileUploadComplete = '/api/v1/files/uploads/complete';

  /// 파일 조회용 presigned url 발급
  ///
  /// GET /api/v1/files/{fileId}/presigned-url
  static String filePresignedUrl(String fileId) =>
      '/api/v1/files/$fileId/presigned-url';

  /// 파일 삭제
  ///
  /// DELETE /api/v1/files/{fileId}
  static String fileDetail(String fileId) => '/api/v1/files/$fileId';
}
