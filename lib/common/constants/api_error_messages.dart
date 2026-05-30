/// API 에러 메시지를 정의하는 상수 클래스.
///
/// - 네트워크 계층에서 사용하는 에러 메시지를 중앙 관리한다.
/// - 문자열 하드코딩을 방지한다.
class ApiErrorMessages {
  /// 인스턴스 생성을 방지하기 위한 private 생성자.
  ApiErrorMessages._();

  /// 약관 조회 실패 메시지.
  static const String fetchTermsFailed = 'common.error.api.fetchTermsFailed';

  /// 약관 동의 등록 실패 메시지
  static const String submitTermsFailed = 'common.error.api.submitTermsFailed';

  /// 로그인 실패 메시지
  static const String loginFailed = 'common.error.api.loginFailed';

  /// 로그인 인증 실패 메시지
  static const String invalidLoginCredentials =
      'common.error.api.invalidLoginCredentials';

  /// 로그아웃 실패 메시지
  static const String logoutFailed = 'common.error.api.logoutFailed';

  /// 토큰 재발급 실패 메시지
  static const String reissueFailed = 'common.error.api.reissueFailed';

  /// 회원가입 비밀번호 등록 실패 메시지
  static const String signupPasswordFailed =
      'common.error.api.signupPasswordFailed';

  /// 본인인증 결과 등록 실패 메시지
  static const String signupIdentityVerificationFailed =
      'common.error.api.signupIdentityVerificationFailed';

  /// 랜덤 닉네임 조회 실패 메시지
  static const String fetchRandomNicknameFailed =
      'common.error.api.fetchRandomNicknameFailed';

  /// 기본 프로필 정보 등록 실패 메시지
  static const String submitBasicProfileFailed =
      'common.error.api.submitBasicProfileFailed';

  /// 내 기본 프로필 조회 실패 메시지
  static const String fetchMyProfileFailed =
      'common.error.api.fetchMyProfileFailed';

  /// 세부 프로필 정보 등록 실패 메시지
  static const String submitProfileDetailsFailed =
      'common.error.api.submitProfileDetailsFailed';

  /// 학교 정보 등록 실패 메시지
  static const String submitEducationFailed =
      'common.error.api.submitEducationFailed';

  /// 학교 이메일 인증 실패 메시지
  static const String verifyEducationEmailFailed =
      'common.error.api.verifyEducationEmailFailed';

  /// 회사 정보 등록 실패 메시지
  static const String submitJobFailed = 'common.error.api.submitJobFailed';

  /// 회사 이메일 인증 실패 메시지
  static const String verifyJobEmailFailed =
      'common.error.api.verifyJobEmailFailed';

  /// 질문 조회 실패 메시지
  static const String fetchQuestionsFailed =
      'common.error.api.fetchQuestionsFailed';

  /// 객관식 질문 답변 등록 실패 메시지
  static const String submitObjectiveQuestionAnswersFailed =
      'common.error.api.submitObjectiveQuestionAnswersFailed';

  /// 주관식 질문 답변 등록 실패 메시지
  static const String submitSubjectiveQuestionAnswersFailed =
      'common.error.api.submitSubjectiveQuestionAnswersFailed';

  /// 프로필 이미지 presigned url 발급 실패 메시지
  static const String createProfileImagePresignedUrlFailed =
      'common.error.api.createProfileImagePresignedUrlFailed';

  /// 업로드 url 발급 실패 메시지
  static const String createUploadPresignFailed =
      'common.error.api.createUploadPresignFailed';

  /// 업로드 완료 통지 실패 메시지
  static const String completeUploadFailed =
      'common.error.api.completeUploadFailed';

  /// 이미지 조회 url 발급 실패 메시지
  static const String createPresignedUrlFailed =
      'common.error.api.createPresignedUrlFailed';

  /// 이미지 삭제 실패 메시지
  static const String deleteFileFailed = 'common.error.api.deleteFileFailed';

  /// 코드북 조회 실패 메시지
  static const String fetchCodebookFailed =
      'common.error.api.fetchCodebookFailed';

  /// 답변 조회 실패 메시지
  static const String fetchAnswersFailed =
      'common.error.api.fetchAnswersFailed';

  /// 답변 저장 실패 메시지
  static const String submitAnswersFailed =
      'common.error.api.submitAnswersFailed';

  /// 연락처 업로드 실패 메시지
  static const String uploadContactsFailed =
      'common.error.api.uploadContactsFailed';

  /// 서버 상태 확인 실패 메시지
  static const String healthcheckFailed = 'common.error.api.healthcheckFailed';

  /// 프로필 심사 요청 실패 메시지
  static const String requestProfileApprovalFailed =
      'common.error.api.requestProfileApprovalFailed';

  /// 프로필 재심사 요청 실패 메시지
  static const String requestProfileReapplyFailed =
      'common.error.api.requestProfileReapplyFailed';

  /// 프로필 거절 사유 조회 실패 메시지
  static const String fetchRejectionReasonFailed =
      'common.error.api.fetchRejectionReasonFailed';
}
