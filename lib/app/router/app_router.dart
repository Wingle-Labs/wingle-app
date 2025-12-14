import 'package:go_router/go_router.dart';
import 'package:wingle/features/home/route/home_router.dart';
import 'package:wingle/features/onboarding/route/onboarding_router.dart';

/// 앱 라우터 정의 클래스
class AppRouter {
  /// 최상위 라우트 목록
  static List<GoRoute> get routes => <GoRoute>[homeRoute, onboardingRoute];
}
