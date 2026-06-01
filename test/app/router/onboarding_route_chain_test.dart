import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  group('OnboardingRouteChain', () {
    test('profileInput에서 학교 정보의 이전 라우트는 직종 선택이다', () {
      expect(
        OnboardingRouteChain.previousOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.basicProfileEducation,
        ),
        OnboardingRoutes.basicProfileCompany,
      );
    });

    test('profileInput의 기본 프로필 라우트가 이전/다음 관계를 갖는다', () {
      expect(
        OnboardingRouteChain.previousOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.basicProfileCompanyName,
        ),
        OnboardingRoutes.basicProfileCompany,
      );
      expect(
        OnboardingRouteChain.nextOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.basicProfileCompanyName,
        ),
        OnboardingRoutes.basicProfileCompanyEmail,
      );
      expect(
        OnboardingRouteChain.previousOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.profileDetails,
        ),
        OnboardingRoutes.basicProfileEducation,
      );
      expect(
        OnboardingRouteChain.nextOf(
          OnboardingRouteFlow.profileInput,
          OnboardingRoutes.profileDetails,
        ),
        OnboardingRoutes.approvalRequest,
      );
    });

    test('같은 라우트도 flow에 따라 다른 다음 라우트를 반환한다', () {
      expect(
        OnboardingRouteChain.nextOf(
          OnboardingRouteFlow.signupPass,
          OnboardingRoutes.agreement,
        ),
        OnboardingRoutes.pass,
      );
      expect(
        OnboardingRouteChain.nextOf(
          OnboardingRouteFlow.signupPhone,
          OnboardingRoutes.agreement,
        ),
        OnboardingRoutes.phone,
      );
      expect(
        OnboardingRouteChain.previousOf(
          OnboardingRouteFlow.approvedQuestions,
          OnboardingRoutes.requiredSelfIntro,
        ),
        OnboardingRoutes.choiceQuestions,
      );
    });
  });
}
