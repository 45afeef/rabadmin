import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/app_initialization.dart';
import '../features/agency/presentation/widgets/agencies_list_page.dart';
import '../features/agency/presentation/widgets/agency_detail_page.dart';
import '../features/agency/presentation/widgets/add_staff_page.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';

// service providers presentation
import '../features/service_providers/presentation/pages/service_providers_home_page.dart';
import '../features/service_providers/presentation/pages/cab_providers_list_page.dart';
import '../features/service_providers/presentation/pages/stay_providers_list_page.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const splash = '/splash';
  static const agencies = '/agencies';
  static const agencyDetail = '/agencies/:agencyId';
  static const addStaff = '/agencies/:agencyId/add-staff';

  // service provider feature
  static const serviceProviders = '/service-providers';
  static const cabProviders = '/service-providers/cab';
  static const stayProviders = '/service-providers/stay';
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
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.agencies,
        builder: (context, state) => const AgenciesListPage(),
      ),
      GoRoute(
        path: AppRoutes.agencyDetail,
        builder: (context, state) {
          final agencyId = state.pathParameters['agencyId']!;
          return AgencyDetailPage(agencyId: agencyId);
        },
      ),
      GoRoute(
        path: AppRoutes.addStaff,
        builder: (context, state) {
          final agencyId = state.pathParameters['agencyId']!;
          return AddStaffPage(agencyId: agencyId);
        },
      ),
      // --- service provider routes ---
      GoRoute(
        path: AppRoutes.serviceProviders,
        builder: (context, state) => const ServiceProvidersHomePage(),
      ),
      GoRoute(
        path: AppRoutes.cabProviders,
        builder: (context, state) => const CabProvidersListPage(),
      ),
      GoRoute(
        path: AppRoutes.stayProviders,
        builder: (context, state) => const StayProvidersListPage(),
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
