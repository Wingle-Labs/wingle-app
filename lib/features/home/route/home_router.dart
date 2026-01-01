import 'package:go_router/go_router.dart';
import 'package:wingle/features/home/presentation/home.dart';
import 'package:wingle/features/home/route/home_routes.dart';

/// ! 홈 라우트
final GoRoute homeRoute = GoRoute(
  path: HomeRoutes.root.path,
  name: HomeRoutes.root.name,
  builder: (context, state) => Home(),
);
