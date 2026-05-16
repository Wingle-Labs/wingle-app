import 'package:wingle/app/router/onboarding_redirect_resolver.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/onboarding/route/onboarding_routes.dart';

/// 앱의 로그인 상태에 따른 라우트 리디렉션 로직
String? appRedirectLogic(bool loggedIn, String currentPath) {
  // currentPath가 Home 하위인데 로그인되지 않은 경우 onboarding으로 리디렉션
  final isInOnboarding = currentPath.startsWith(OnboardingRoutes.root.path);
  if (!loggedIn && !isInOnboarding) return OnboardingRoutes.root.path;

  if (!loggedIn) return null;

  final profileStatus = _readLoginProfileStatus();

  /// 프로필 상태가 null이면 로그인 되지 않은 상태이므로 Onboarding으로 리디렉션
  if (profileStatus == null) {
    return OnboardingRoutes.root.path;
  }

  final destination = resolveOnboardingDestination(profileStatus);
  if (currentPath == destination.path) return null;
  if (profileStatus.isCompleted) {
    if (isInOnboarding) return destination.path;
    return null;
  }

  if (!isInOnboarding) return destination.path;
  return null;
}

LoginProfileStatus? _readLoginProfileStatus() {
  try {
    final rawValue = HiveUtil.read(HiveLoginBox.profileStatus);
    if (rawValue == null) return null;
    return LoginProfileStatus.fromApiValue(rawValue);
  } catch (_) {
    return null;
  }
}
