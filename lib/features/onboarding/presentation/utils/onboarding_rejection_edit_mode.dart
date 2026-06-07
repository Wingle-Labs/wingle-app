import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 현재 사용자가 프로필 반려 후 수정 모드인지 확인한다.
bool isOnboardingRejectionEditMode() {
  return _readProfileStatus().isRejected;
}

/// 반려 수정 모드에서는 반려 화면으로, 그 외에는 지정 라우트로 이동한다.
void goRejectedReviewOrNamed(BuildContext context, String routeName) {
  context.goNamed(
    isOnboardingRejectionEditMode()
        ? OnboardingRoutes.profileRejected.name
        : routeName,
  );
}

/// 반려 수정 모드에서는 반려 화면으로, 그 외에는 지정 라우트를 push한다.
void goRejectedReviewOrPushNamed(BuildContext context, String routeName) {
  if (isOnboardingRejectionEditMode()) {
    context.goNamed(OnboardingRoutes.profileRejected.name);
    return;
  }

  context.pushNamed(routeName);
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
