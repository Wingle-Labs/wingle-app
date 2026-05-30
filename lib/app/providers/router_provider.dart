import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:wingle/app/config/theme/design_system.dart';
import 'package:wingle/app/router/app_router.dart';
import 'package:wingle/app/router/redirect_logic.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/auth_session_state.dart';
import 'package:wingle/common/utils/hive_util.dart';
import 'package:wingle/features/home/route/home_routes.dart';

part 'router_provider.g.dart';

/// 루트 네비게이터 키
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Provider
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    // initialLocation: designSystemRoute.path,
    initialLocation: HomeRoutes.root.path,
    refreshListenable: AuthSessionState.listenable,
    redirect: (context, state) {
      return appRedirectLogic(
        _isLoggedIn(),
        state.uri.path,
        forceLogin: AuthSessionState.shouldRedirectToLogin,
      );
    },
    routes: AppRouter.routes,
    // TODO: 에러 페이지 구현
    // errorBuilder: (context, state) {
    //   return Home();
    // },
  );
}

bool _isLoggedIn() {
  try {
    final accessToken = HiveUtil.read(HiveLoginBox.accessToken);
    return accessToken != null && accessToken.trim().isNotEmpty;
  } catch (_) {
    return false;
  }
}
