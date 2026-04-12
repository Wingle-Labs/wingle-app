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
    });
  });
}
