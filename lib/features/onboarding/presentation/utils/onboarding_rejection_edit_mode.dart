import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/app/router/route_node.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/route/onboarding_route_chain.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 온보딩 수정 진입 모드 query key.
const String onboardingEditModeQueryKey = 'editMode';

/// 온보딩 수정 후 돌아갈 route name query key.
const String onboardingReturnToQueryKey = 'returnTo';

/// 프로필 반려 수정 진입 모드 query value.
const String onboardingRejectionEditModeValue = 'rejection';

/// 현재 사용자가 프로필 반려 후 수정 모드인지 확인한다.
bool isOnboardingRejectionEditMode([BuildContext? context]) {
  if (context != null && hasOnboardingRejectionEditIntent(context)) {
    return true;
  }

  return _readProfileStatus().isRejected;
}

/// 프로필 재심사 화면에서 수정 화면으로 진입할 때 사용할 query parameters.
Map<String, String> onboardingRejectionEditQueryParameters({
  RouteNode returnRoute = OnboardingRoutes.profileRejected,
}) {
  return {
    onboardingEditModeQueryKey: onboardingRejectionEditModeValue,
    onboardingReturnToQueryKey: returnRoute.name,
  };
}

/// 현재 route가 프로필 재심사 수정 진입 의도를 가지고 있는지 확인한다.
bool hasOnboardingRejectionEditIntent(BuildContext context) {
  return _rejectionEditReturnRouteName(context) != null;
}

/// 프로필 재심사 화면에서 대상 수정 route로 이동한다.
void goOnboardingRejectionEditRoute(BuildContext context, RouteNode route) {
  context.goNamed(
    route.name,
    queryParameters: onboardingRejectionEditQueryParameters(),
  );
}

/// 재심사 수정 진입 route에서는 재심사 화면으로, 일반 route에서는 체인 이전으로 이동한다.
bool goRejectedReviewOrPrevious(
  BuildContext context,
  OnboardingRouteFlow flow,
  RouteNode route,
) {
  if (hasOnboardingRejectionEditIntent(context)) {
    _goRejectedReviewReturnRoute(context);
    return true;
  }

  return OnboardingRouteChain.goPrevious(context, flow, route);
}

/// 반려 수정 모드에서는 반려 화면으로, 그 외에는 지정 라우트로 이동한다.
void goRejectedReviewOrNamed(BuildContext context, String routeName) {
  if (isOnboardingRejectionEditMode(context)) {
    _goRejectedReviewReturnRoute(context);
    return;
  }

  context.goNamed(routeName);
}

/// 반려 수정 모드에서는 반려 화면으로, 그 외에는 지정 라우트를 push한다.
void goRejectedReviewOrPushNamed(BuildContext context, String routeName) {
  if (isOnboardingRejectionEditMode(context)) {
    _goRejectedReviewReturnRoute(context);
    return;
  }

  context.pushNamed(routeName);
}

String? _rejectionEditReturnRouteName(BuildContext context) {
  try {
    final queryParameters = GoRouterState.of(context).uri.queryParameters;
    if (queryParameters[onboardingEditModeQueryKey] !=
        onboardingRejectionEditModeValue) {
      return null;
    }

    return _nonEmpty(queryParameters[onboardingReturnToQueryKey]);
  } catch (_) {
    return null;
  }
}

void _goRejectedReviewReturnRoute(BuildContext context) {
  context.goNamed(
    _rejectionEditReturnRouteName(context) ??
        OnboardingRoutes.profileRejected.name,
  );
}

LoginProfileStatus _readProfileStatus() {
  try {
    return LoginProfileStatus.fromApiValue(
      HiveUtil.read(HiveLoginBox.profileStatus),
    );
  } catch (_) {
    return LoginProfileStatus.signupCompleted;
  }
}

String? _nonEmpty(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
