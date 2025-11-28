import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:value_date/app/router/app_router.dart';
import 'package:value_date/common/constants/route_constants.dart';

part 'router_provider.g.dart';

/// 루트 네비게이터 키
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Provider
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.onboarding,
    redirect: (context, state) {
      return null;
    },
    routes: AppRouter.routes,
  );
}
