import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/home/route/home_routes.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 앱의 로그인 상태에 따른 라우트 리디렉션 로직
String? appRedirectLogic(bool loggedIn, String currentPath) {
  // currentPath가 onboarding 하위가 아니면 리디렉션하지 않음
  final isInOnboarding = currentPath.startsWith(OnboardingRoutes.root.path);
  if (!loggedIn && !isInOnboarding) return OnboardingRoutes.root.path;

  if (!loggedIn) return null;

  final profileStatus = _readLoginProfileStatus();

  if (profileStatus == null) {
    return null;
  }

  if (profileStatus.isBeforeBasicProfile) {
    if (currentPath != OnboardingRoutes.basicProfile.path) {
      return OnboardingRoutes.basicProfile.fullPath;
    }
    return null;
  }

  if (profileStatus.isApproved) {
    if (isInOnboarding) return HomeRoutes.root.path;
    return null;
  }

  if (!isInOnboarding) return OnboardingRoutes.root.path;
  return null;
}

LoginProfileStatus? _readLoginProfileStatus() {
  try {
    final rawValue = HiveUtil.read(HiveLoginBox.profileStatus);
    if (rawValue == null) return null;
    print('rawValue: $rawValue');
    return LoginProfileStatus.fromApiValue(rawValue);
  } catch (_) {
    return null;
  }
}
