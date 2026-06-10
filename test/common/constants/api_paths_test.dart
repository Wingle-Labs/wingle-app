import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_paths.dart';

void main() {
  test('앱에서 사용하는 Swagger API 42개 경로를 관리한다', () {
    final operations = <String>[
      'POST ${ApiEndpoints.authLogin}',
      'POST ${ApiEndpoints.authLogout}',
      'POST ${ApiEndpoints.authReissue}',
      'POST ${ApiEndpoints.signupTerms}',
      'POST ${ApiEndpoints.signupProfile}',
      'POST ${ApiEndpoints.signupPassword}',
      'POST ${ApiEndpoints.signupIdentityVerification}',
      'GET ${ApiEndpoints.signupNicknameRandom}',
      'PUT ${ApiEndpoints.userProfile}',
      'GET ${ApiEndpoints.meProfile}',
      'POST ${ApiEndpoints.profileJob}',
      'PUT ${ApiEndpoints.profileJobReapply}',
      'POST ${ApiEndpoints.profileJobEmailVerifications}',
      'POST ${ApiEndpoints.profileJobEmailVerificationsConfirm}',
      'POST ${ApiEndpoints.profileEducation}',
      'PUT ${ApiEndpoints.profileEducationReapply}',
      'POST ${ApiEndpoints.profileEducationEmailVerifications}',
      'POST ${ApiEndpoints.profileEducationEmailVerificationsConfirm}',
      'POST ${ApiEndpoints.profileEducationCertification}',
      'POST ${ApiEndpoints.profileDetail}',
      'PUT ${ApiEndpoints.profileDetailReapply}',
      'POST ${ApiEndpoints.profileApprovalRequest}',
      'POST ${ApiEndpoints.profileReapply}',
      'GET ${ApiEndpoints.profileRejectionReason}',
      'GET ${ApiEndpoints.termsSnapshot}',
      'GET ${ApiEndpoints.termsCurrentVersions}',
      'GET ${ApiEndpoints.codebookSnapshot}',
      'GET ${ApiEndpoints.codebookCurrentVersions}',
      'GET ${ApiEndpoints.choiceQuestionsSnapshot}',
      'GET ${ApiEndpoints.choiceQuestionsCurrentVersions}',
      'GET ${ApiEndpoints.essayQuestionsSnapshot}',
      'GET ${ApiEndpoints.essayQuestionsCurrentVersions}',
      'GET ${ApiEndpoints.choiceQuestionAnswers}',
      'POST ${ApiEndpoints.choiceQuestionAnswers}',
      'GET ${ApiEndpoints.essayQuestionAnswers}',
      'POST ${ApiEndpoints.essayQuestionAnswers}',
      'GET ${ApiEndpoints.styleImagePresign}',
      'GET ${ApiEndpoints.faceImagePresign}',
      'GET ${ApiEndpoints.certificationPresign}',
      'POST ${ApiEndpoints.contacts}',
      'POST ${ApiEndpoints.notificationToken}',
      'GET ${ApiEndpoints.healthcheck}',
    ];

    expect(operations, hasLength(42));
    expect(operations.every((op) => op.contains(' /api/v1/')), isTrue);
  });
}
