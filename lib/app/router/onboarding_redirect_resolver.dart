import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 로그인/앱 재진입 시 온보딩 상태에 따라 이동할 목적지.
class OnboardingRedirectDestination {
  /// 라우트 이름.
  final String name;

  /// 전체 경로.
  final String path;

  /// 생성자.
  const OnboardingRedirectDestination({required this.name, required this.path});
}

/// BE onboardingStatus를 앱의 라우팅 목적지로 변환한다.
OnboardingRedirectDestination resolveOnboardingDestination(
  LoginProfileStatus status,
) {
  switch (status) {
    case LoginProfileStatus.signupCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.basicProfile.name,
        path: OnboardingRoutes.basicProfile.fullPath,
      );
    case LoginProfileStatus.basicInfoCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.basicProfileCompany.name,
        path: OnboardingRoutes.basicProfileCompany.fullPath,
      );
    case LoginProfileStatus.jobInfoCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.basicProfileEducation.name,
        path: OnboardingRoutes.basicProfileEducation.fullPath,
      );
    case LoginProfileStatus.educationInfoCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.profileDetails.name,
        path: OnboardingRoutes.profileDetails.fullPath,
      );
    case LoginProfileStatus.profileCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.approvalRequest.name,
        path: OnboardingRoutes.approvalRequest.fullPath,
      );
    case LoginProfileStatus.awaitingApproval:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.approvalPending.name,
        path: OnboardingRoutes.approvalPending.fullPath,
      );
    case LoginProfileStatus.profileRejected:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.profileRejected.name,
        path: OnboardingRoutes.profileRejected.fullPath,
      );
    case LoginProfileStatus.profileApproved:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.choiceQuestions.name,
        path: OnboardingRoutes.choiceQuestions.fullPath,
      );
    case LoginProfileStatus.choiceQuestionCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.requiredSelfIntro.name,
        path: OnboardingRoutes.requiredSelfIntro.fullPath,
      );
    case LoginProfileStatus.essayQuestionCompleted:
      return OnboardingRedirectDestination(
        name: OnboardingRoutes.contactBlock.name,
        path: OnboardingRoutes.contactBlock.fullPath,
      );
    case LoginProfileStatus.onboardingCompleted:
      return OnboardingRedirectDestination(
        name: HomeRoutes.root.name,
        path: HomeRoutes.root.path,
      );
  }
}
