import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ag_broker/presentation/features/auth/login/login_page.dart';
import 'package:ag_broker/presentation/features/auth/otp_verification_page.dart';
import 'package:ag_broker/presentation/features/home/home_page.dart';
import 'package:ag_broker/presentation/features/profile/profile_page.dart';
import 'package:ag_broker/presentation/features/truck_load/truck_load_details_screen.dart';
import 'package:ag_broker/presentation/features/lp_clients/lp_client_list_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/add_lp_client_page.dart';

/// Provides GoRouter instance for app navigation
/// This is a keepAlive provider as routing should persist throughout app lifecycle
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: SharedPreferencesService.isLoggedIn ? '/home' : '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return SharedPreferencesService.isLoggedIn ? HomePage() : LoginPage();
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationPage(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
      GoRoute(
        path: '/stack-details',
        builder: (context, state) {
          final stackData = state.extra as int;
          return TruckLoadDetailsScreen(index: stackData);
        },
      ),
      GoRoute(
        path: '/home/lp-clients',
        builder: (context, state) => const LpClientListPage(),
        routes: [
          GoRoute(
            path: '/home/lp-clients/add',
            builder: (context, state) => const AddLpClientPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = SharedPreferencesService.isLoggedIn;
      final isLoginRoute =
          state.uri.path == '/login' || state.uri.path == '/otp-verification';

      // Redirect to home if logged in and trying to access login
      if (isLoggedIn && isLoginRoute) {
        return '/home';
      }

      // Redirect to login if not logged in and trying to access protected routes
      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      return null;
    },
  );
});
