import 'package:go_router/go_router.dart';

import 'features/exports.dart';

final routes = GoRouter(
  initialLocation: LoginScreen.routePath,
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
    GoRoute(
      path: VerificationScreen.routePath,
      name: VerificationScreen.routeName,
      builder: (_, state) {
        final params = state.extra as VerificationPathParams?;

        if (params == null) {
          throw Exception('Missing path params');
        }

        return VerificationScreen(pathParams: params);
      },
    ),
  ],
);
