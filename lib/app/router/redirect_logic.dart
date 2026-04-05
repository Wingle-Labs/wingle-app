import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/auth/domain/models/login_profile_status.dart';
import 'package:wingle/features/home/route/home_routes.dart';
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

  /// 로그인을 했는데 BasicProfile을 작성하지 않은 상태고 Onboarding이 아닌 경로일 때 BasicProfile로 리디렉션
  if (profileStatus.isBeforeBasicProfile) {
    if (!currentPath.contains(OnboardingRoutes.root.path)) {
      return OnboardingRoutes.basicProfile.fullPath;
    }
    return null;
  }

  /// 로그인을 했는데 회사 정보 등록 전 상태고 Onboarding이 아닌 경로일 때 회사 정보로 리디렉션
  if (profileStatus.isBeforeCompanyInfo) {
    if (!currentPath.contains(OnboardingRoutes.root.path)) {
      return OnboardingRoutes.basicProfileCompany.fullPath;
    }
    return null;
  }

  /// 로그인을 했는데 Approved 상태이면 Home으로 리디렉션
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
    return LoginProfileStatus.fromApiValue(rawValue);
  } catch (_) {
    return null;
  }
}
