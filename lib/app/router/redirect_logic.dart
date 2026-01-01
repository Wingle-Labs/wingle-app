import 'package:wingle/common/constants/route_constants.dart';

/// 앱의 로그인 상태에 따른 라우트 리디렉션 로직
String? appRedirectLogic(bool loggedIn, String currentPath) {
  // currentPath가 onboarding 하위가 아니면 리디렉션하지 않음
  final isInOnboarding = currentPath.startsWith(AppRoute.onboarding.path);
  if (!loggedIn && !isInOnboarding) return AppRoute.onboarding.path;
  return null;
}
