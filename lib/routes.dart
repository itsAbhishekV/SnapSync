import 'package:go_router/go_router.dart';

import 'features/exports.dart';

final routes = GoRouter(
  initialLocation: HomeScreen.routePath,
  routes: [
    GoRoute(
      path: HomeScreen.routePath,
      name: HomeScreen.routeName,
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: LoginScreen.routePath,
      name: LoginScreen.routeName,
      builder: (_, __) => const LoginScreen(),
    ),
  ],
);
