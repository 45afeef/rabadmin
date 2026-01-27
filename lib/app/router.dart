import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/login_page.dart';

/// Centralized route names (optional but recommended)
abstract class AppRoutes {
  static const login = '/login';
  static const home = '/';
}

/// AppRouter
///
/// Keeps navigation logic outside UI
/// Easy to plug auth guards later
class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,

    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],

    /// Global error page (404, route failures, etc.)
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(state.error.toString(), textAlign: TextAlign.center),
        ),
      );
    },
  );
}
