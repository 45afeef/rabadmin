import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/';
}

/// Router provider (reactive)
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,

    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      // 🚫 Not logged in → login
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      // ✅ Logged in → prevent going back to login
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },

    routes: [
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
