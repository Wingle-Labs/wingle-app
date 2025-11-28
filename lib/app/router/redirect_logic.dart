import 'package:wingle/common/constants/route_constants.dart';

/// 앱의 로그인 상태에 따른 라우트 리디렉션 로직
String? appRedirectLogic(bool loggedIn, String currentPath) {
  final loggingIn = currentPath == AppRoutes.root;

  if (!loggedIn && !loggingIn) return AppRoutes.onboarding;
  if (loggedIn && loggingIn) return AppRoutes.home;
  return null;
}
