import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/router/route_node.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 온보딩 안에서 서로 다른 의미를 갖는 화면 흐름.
enum OnboardingRouteFlow {
  /// 기본 프로필 입력부터 심사/승인 관련 placeholder까지 이어지는 흐름.
  profileInput,

  /// PASS 인증 기반 회원가입 흐름.
  signupPass,

  /// 전화번호 인증 기반 회원가입 흐름.
  signupPhone,

  /// 승인 이후 질문 입력 흐름.
  approvedQuestions,
}

/// 온보딩 라우트의 이전/다음 관계를 중앙에서 관리한다.
abstract final class OnboardingRouteChain {
  static final Map<OnboardingRouteFlow, _RouteChainDefinition> _definitions = {
    OnboardingRouteFlow.profileInput: _RouteChainDefinition([
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfile,
        next: OnboardingRoutes.basicProfileResidence,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileResidence,
        previous: OnboardingRoutes.basicProfile,
        next: OnboardingRoutes.basicProfileHeight,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileHeight,
        previous: OnboardingRoutes.basicProfileResidence,
        next: OnboardingRoutes.basicProfileBodyShape,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileBodyShape,
        previous: OnboardingRoutes.basicProfileHeight,
        next: OnboardingRoutes.basicProfileCompany,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileCompany,
        previous: OnboardingRoutes.basicProfileBodyShape,
        next: OnboardingRoutes.basicProfileCompanyName,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileCompanyName,
        previous: OnboardingRoutes.basicProfileCompany,
        next: OnboardingRoutes.basicProfileCompanyEmail,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileCompanyEmail,
        previous: OnboardingRoutes.basicProfileCompanyName,
        next: OnboardingRoutes.basicProfileEducation,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.basicProfileEducation,
        previous: OnboardingRoutes.basicProfileCompany,
        next: OnboardingRoutes.profileDetails,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileDetails,
        previous: OnboardingRoutes.basicProfileEducation,
        next: OnboardingRoutes.profileStylePhotos,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileStylePhotos,
        previous: OnboardingRoutes.profileDetails,
        next: OnboardingRoutes.profileFacePhotos,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileFacePhotos,
        previous: OnboardingRoutes.profileStylePhotos,
        next: OnboardingRoutes.profileSelfIntroduction,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileSelfIntroduction,
        previous: OnboardingRoutes.profileFacePhotos,
        next: OnboardingRoutes.approvalRequest,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.approvalRequest,
        previous: OnboardingRoutes.profileSelfIntroduction,
        next: OnboardingRoutes.approvalPending,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.approvalPending,
        previous: OnboardingRoutes.approvalRequest,
        next: OnboardingRoutes.profileApprovedWelcome,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileApprovedWelcome,
        previous: OnboardingRoutes.approvalPending,
        next: OnboardingRoutes.choiceQuestions,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.profileRejected,
        previous: OnboardingRoutes.approvalPending,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.choiceQuestions,
        previous: OnboardingRoutes.profileApprovedWelcome,
      ),
    ]),
    OnboardingRouteFlow.signupPass: _RouteChainDefinition([
      _RouteChainEntry(
        route: OnboardingRoutes.agreement,
        previous: OnboardingRoutes.login,
        next: OnboardingRoutes.pass,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.pass,
        previous: OnboardingRoutes.agreement,
        next: OnboardingRoutes.passWebView,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.passWebView,
        previous: OnboardingRoutes.pass,
        next: OnboardingRoutes.onboardingPassword,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.onboardingPassword,
        previous: OnboardingRoutes.passWebView,
        next: OnboardingRoutes.login,
      ),
    ]),
    OnboardingRouteFlow.signupPhone: _RouteChainDefinition([
      _RouteChainEntry(
        route: OnboardingRoutes.agreement,
        previous: OnboardingRoutes.login,
        next: OnboardingRoutes.phone,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.phone,
        previous: OnboardingRoutes.agreement,
        next: OnboardingRoutes.otp,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.otp,
        previous: OnboardingRoutes.phone,
        next: OnboardingRoutes.age,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.age,
        previous: OnboardingRoutes.otp,
        next: OnboardingRoutes.requiredSelfIntro,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.requiredSelfIntro,
        previous: OnboardingRoutes.age,
        next: OnboardingRoutes.contactBlock,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.contactBlock,
        previous: OnboardingRoutes.requiredSelfIntro,
        next: HomeRoutes.root,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.selectiveSelfIntro,
        previous: OnboardingRoutes.requiredSelfIntro,
        next: HomeRoutes.root,
      ),
    ]),
    OnboardingRouteFlow.approvedQuestions: _RouteChainDefinition([
      _RouteChainEntry(
        route: OnboardingRoutes.choiceQuestions,
        previous: OnboardingRoutes.profileApprovedWelcome,
        next: OnboardingRoutes.requiredSelfIntro,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.requiredSelfIntro,
        previous: OnboardingRoutes.choiceQuestions,
        next: OnboardingRoutes.contactBlock,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.essayQuestionInput,
        previous: OnboardingRoutes.requiredSelfIntro,
        next: OnboardingRoutes.requiredSelfIntro,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.contactBlock,
        previous: OnboardingRoutes.requiredSelfIntro,
        next: HomeRoutes.root,
      ),
      _RouteChainEntry(
        route: OnboardingRoutes.selectiveSelfIntro,
        previous: OnboardingRoutes.requiredSelfIntro,
        next: HomeRoutes.root,
      ),
    ]),
  };

  /// [flow] 안에서 [route]의 이전 라우트를 반환한다.
  static RouteNode? previousOf(OnboardingRouteFlow flow, RouteNode route) {
    return _definitions[flow]?.previousOf(route);
  }

  /// [flow] 안에서 [route]의 기본 다음 라우트를 반환한다.
  static RouteNode? nextOf(OnboardingRouteFlow flow, RouteNode route) {
    return _definitions[flow]?.nextOf(route);
  }

  /// [flow] 안에서 [route]의 이전 라우트로 이동한다.
  static bool goPrevious(
    BuildContext context,
    OnboardingRouteFlow flow,
    RouteNode route,
  ) {
    final previous = previousOf(flow, route);
    if (previous == null) {
      return false;
    }

    context.goNamed(previous.name);
    return true;
  }
}

class _RouteChainDefinition {
  final Map<String, _RouteChainEntry> _entriesByRouteName;

  _RouteChainDefinition(List<_RouteChainEntry> entries)
    : _entriesByRouteName = {
        for (final entry in entries) entry.route.name: entry,
      };

  RouteNode? previousOf(RouteNode route) {
    return _entriesByRouteName[route.name]?.previous;
  }

  RouteNode? nextOf(RouteNode route) {
    return _entriesByRouteName[route.name]?.next;
  }
}

class _RouteChainEntry {
  final RouteNode route;
  final RouteNode? previous;
  final RouteNode? next;

  const _RouteChainEntry({required this.route, this.previous, this.next});
}
