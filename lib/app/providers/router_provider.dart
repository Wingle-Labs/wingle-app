import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wingle/app/router/app_router.dart';
import 'package:wingle/common/constants/route_constants.dart';
import 'package:wingle/features/home/presentation/home.dart';

part 'router_provider.g.dart';

/// 루트 네비게이터 키
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Provider
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.onboarding.path,
    redirect: (context, state) {
      return null;
    },
    routes: AppRouter.routes,
    // TODO: 에러 페이지 구현
    errorBuilder: (context, state) {
      return Home();
    },
  );
}
