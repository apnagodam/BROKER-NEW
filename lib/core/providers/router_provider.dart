import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/presentation/features/Tm_fees_page.dart';
import 'package:ag_broker/presentation/features/add_security_page.dart';
import 'package:ag_broker/presentation/features/members/authorized_person_page.dart';
import 'package:ag_broker/presentation/features/members/member_hub_page.dart';
import 'package:ag_broker/presentation/features/profile/brokerage_profile.dart';
import 'package:ag_broker/presentation/features/wallet/trade_power_statement.dart';
import 'package:ag_broker/presentation/marging/scheme_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ag_broker/presentation/features/auth/login/login_page.dart';
import 'package:ag_broker/presentation/features/auth/login/otp_verification_page.dart';
import 'package:ag_broker/presentation/features/home/home_page.dart';
import 'package:ag_broker/presentation/features/profile/profile_page.dart';
import 'package:ag_broker/presentation/features/truck_load/truck_load_details_screen.dart';
import 'package:ag_broker/presentation/features/lp_clients/lp_client_list_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/add_lp_client_page.dart';
import 'package:ag_broker/presentation/features/bids/bids_history_page.dart';
import 'package:ag_broker/presentation/features/wallet/wallet_hub_page.dart';
import 'package:ag_broker/presentation/features/wallet/wallet_statement_page.dart';
import 'package:ag_broker/presentation/features/deals/running_deals_page.dart';
import 'package:ag_broker/presentation/features/deals/delivered_deals_page.dart';
import 'package:ag_broker/presentation/features/wallet/withdrawal_request_page.dart';

// ── Helper to resolve memberType from SharedPreferences ──────────────────────
int _getMemberType() => SharedPreferencesService.memberType;

/// Provides GoRouter instance for app navigation
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
          final userId = int.tryParse(state.uri.queryParameters['userId'] ?? '') ??
              (state.extra is Map ? (state.extra as Map)['userId'] as int? ?? 0 : 0);
          final userName = state.uri.queryParameters['userName'] ??
              (state.extra is Map ? (state.extra as Map)['userName'] as String? ?? '' : '');
          final memberTypeName = state.uri.queryParameters['memberTypeName'] ??
              (state.extra is Map ? (state.extra as Map)['memberTypeName'] as String? ?? '' : '');
          return OtpVerificationPage(
            phoneNumber: phoneNumber,
            userId: userId,
            userName: userName,
            memberTypeName: memberTypeName,
          );
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

      // ── Profile ────────────────────────────────────────────────────────────
      GoRoute(
        path: '/home/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/home/brokerage-profile',
        builder: (context, state) => const BrokerageProfile(),
      ),
      GoRoute(
        path: '/home/bids-history',
        builder: (context, state) => BidsHistoryPage(),
      ),

      GoRoute(
        path: '/home/running-deals',
        builder: (context, state) => const RunningDealsPage(),
      ),
      GoRoute(
        path: '/home/delivered-deals',
        builder: (context, state) => const DeliveredDealsPage(),
      ),
      GoRoute(
        path: '/running-deals',
        builder: (context, state) => const RunningDealsPage(),
      ),
      GoRoute(
        path: '/delivered-deals',
        builder: (context, state) => const DeliveredDealsPage(),
      ),

      // ── LP Clients ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/home/lp-clients',
        builder: (context, state) => const LpClientListPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddLpClientPage(),
          ),
        ],
      ),

      // ── Wallet hub + sub-screens ───────────────────────────────────────────
      GoRoute(
        path: '/home/wallet',
        builder: (context, state) =>
            WalletHubPage(memberType: _getMemberType()),
      ),
      GoRoute(
        path: '/home/wallet-statement',
        builder: (context, state) => const WalletStatementPage(),
      ),
      GoRoute(
        path: '/home/withdrawal-request',
        builder: (context, state) => const WithdrawalRequestPage(),
      ),
      GoRoute(
        path: '/home/trade-power-statement',
        builder: (context, state) => const TradePowerStatementPage(),
      ),

      // ── Members hub + sub-screens ──────────────────────────────────────────
      GoRoute(
        path: '/home/members',
        builder: (context, state) =>
            MembersHubPage(memberType: _getMemberType()),
      ),
      GoRoute(
        path: '/home/authorised-person',
        builder: (context, state) => const AuthorisedPersonPage(),
      ),
      GoRoute(
        path: '/home/tm-fees',
        builder: (context, state) => const TmFeesPage(),
      ),
      GoRoute( 
        path: '/home/add-security',
        builder: (context, state) => const AddSecurityPage(),
      ),

      // ── Margin Funding (STCM — memberType 3) ──────────────────────────────
    GoRoute(
  path: '/home/margin-funding-schemes',
  builder: (context, state) => const MarginFundingSchemesPage(),
),
      GoRoute(
        path: '/home/margin-funding-limit',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Margin Funding Limit'),
      ),
      GoRoute(  
        path: '/home/margin-funding-request',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Margin Funding Request'),
      ),
    ],
    redirect: (context, state) {   
      final isLoggedIn = SharedPreferencesService.isLoggedIn;
      final isLoginRoute =
          state.uri.path == '/login' || state.uri.path == '/otp-verification';

      if (isLoggedIn && isLoginRoute) return '/home';
      if (!isLoggedIn && !isLoginRoute) return '/login';

      return null;
    },
  );
});

// ── Temporary placeholder — replace with real pages when ready ───────────────
class _PlaceholderPage extends StatelessWidget {
  final String title; 
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar( 
        title: Text(title),
        centerTitle: true,  
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center( 
        child: Column(       
          mainAxisSize: MainAxisSize.min,
          children: [   
            Icon(Icons.construction_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(       
              title, 
              style: const TextStyle(  
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(      
              'Coming soon', 
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}