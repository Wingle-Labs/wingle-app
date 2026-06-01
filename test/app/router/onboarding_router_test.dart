import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/router/app_router.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

void main() {
  group('AppRouter', () {
    test('registers onboarding signup routes', () {
      final router = GoRouter(
        routes: AppRouter.routes,
        initialLocation: '/home',
      );

      expect(
        router.namedLocation(OnboardingRoutes.agreement.name),
        OnboardingRoutes.agreement.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.pass.name),
        OnboardingRoutes.pass.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.passWebView.name),
        OnboardingRoutes.passWebView.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.basicProfileEducation.name),
        OnboardingRoutes.basicProfileEducation.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.profileDetails.name),
        OnboardingRoutes.profileDetails.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.profileStylePhotos.name),
        OnboardingRoutes.profileStylePhotos.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.profileFacePhotos.name),
        OnboardingRoutes.profileFacePhotos.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.approvalPending.name),
        OnboardingRoutes.approvalPending.fullPath,
      );
      expect(
        router.namedLocation(OnboardingRoutes.choiceQuestions.name),
        OnboardingRoutes.choiceQuestions.fullPath,
      );
    });
  });
}
