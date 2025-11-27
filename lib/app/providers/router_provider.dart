import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:value_date/app/router/app_router.dart';
import 'package:value_date/common/constants/route_constants.dart';

/// 루트 네비게이터 키
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.root,
    redirect: (context, state) {
      return null;
    },
    routes: AppRouter.routes,
  );
});
