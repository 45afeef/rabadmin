import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../core/providers/app_initialization.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const splash = '/splash';
}

/// Router provider (reactive)
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final initializationState = ref.watch(appInitializationProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    redirect: (context, state) {
      // Show splash while initializing
      if (initializationState.isLoading) {
        return AppRoutes.splash;
      }

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      // 🚫 Not logged in → login
      if (!isLoggedIn && !isLoggingIn && !isSplash) {
        return AppRoutes.login;
      }

      // ✅ Logged in → prevent going back to login
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }

      // Move away from splash once initialized
      if (isSplash && isLoggedIn) {
        return AppRoutes.home;
      }

      if (isSplash && !isLoggedIn) {
        return AppRoutes.login;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashPage(),
      ),
      GoRoute(path: AppRoutes.login, builder: (context, state) => LoginPage()),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return const HomePage();
        },
      ),
    ],
  );
});

/// Simple splash page shown during initialization
class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
