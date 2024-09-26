import 'package:go_router/go_router.dart';

import 'features/exports.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: LoginScreen.routePath,
      name: LoginScreen.routeName,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: VerificationScreen.routePath,
      name: VerificationScreen.routeName,
      builder: (_, __) => const VerificationScreen(),
    ),
  ],
);
