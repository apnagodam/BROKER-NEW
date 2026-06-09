import 'package:ag_broker/core/theme/app_theme.dart';
import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/notification_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/features/Tm_fees_page.dart';
import 'package:ag_broker/presentation/features/add_security_page.dart';
import 'package:ag_broker/presentation/features/auth/login/login_page.dart';
import 'package:ag_broker/presentation/features/auth/login/otp_verification_page.dart';
import 'package:ag_broker/presentation/features/bids/bids_history_page.dart';
import 'package:ag_broker/presentation/features/home/home_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/add_lp_client_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/lp_client_list_page.dart';
import 'package:ag_broker/presentation/features/members/authorized_person_page.dart';
import 'package:ag_broker/presentation/features/profile/brokerage_profile.dart';
import 'package:ag_broker/presentation/features/profile/profile_page.dart';
import 'package:ag_broker/presentation/features/sbt/screens/sbt_secure_product_page.dart';
import 'package:ag_broker/presentation/features/sbt/screens/sbt_unsecure_product_page.dart';
import 'package:ag_broker/presentation/features/truck_load/truck_load_details_screen.dart';
import 'package:ag_broker/presentation/features/wallet/trade_power_statement.dart';
import 'package:ag_broker/presentation/features/wallet/wallet_statement_page.dart';
import 'package:ag_broker/presentation/features/wallet/withdrawal_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:in_app_update/in_app_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await SharedPreferencesService.init();
  InAppUpdate.checkForUpdate().then((updateInfo) {
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {}
        });
      } else if (updateInfo.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.completeFlexibleUpdate();
          }
        });
      }
    }
  });
  runApp(ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(
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
    GoRoute(
      path: '/stack-details',
      builder: (context, state) {
        final stackData = state.extra as int;
        return TruckLoadDetailsScreen(index: stackData);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
      routes: [
        // ── Profile ─────────────────────────────────────────────────────
        GoRoute(path: 'profile', builder: (context, state) => ProfilePage()),
        GoRoute(
          path: 'brokerage-profile',
          builder: (context, state) => BrokerageProfile(),
        ),
        GoRoute(
          path: 'bids-history',
          builder: (context, state) => BidsHistoryPage(),
        ),

        // ── LP Clients ───────────────────────────────────────────────────
        GoRoute(
          path: 'lp-clients',
          builder: (context, state) => const LpClientListPage(),
        ),
        GoRoute(
          path: 'lp-clients/add',
          builder: (context, state) => const AddLpClientPage(),
        ),

        // ── Wallet ───────────────────────────────────────────────────────
        GoRoute(
          path: 'wallet-statement',
          builder: (context, state) => WalletStatementPage(),
        ),
        GoRoute(
          path: 'withdrawal-request',
          builder: (context, state) => WithdrawalRequestPage(),
        ),
        GoRoute(
          path: 'trade-power-statement',
          builder: (context, state) => const TradePowerStatementPage(),
        ),

        // ── Members ──────────────────────────────────────────────────────
        GoRoute(
          path: 'authorised-person',
          builder: (context, state) => const AuthorisedPersonPage(),
        ),
        GoRoute(
          path: 'lp-clients',
          builder: (context, state) => const LpClientListPage(),
        ),
        GoRoute(
          path: 'tm-fees',
          builder: (context, state) => const TmFeesPage(),
        ),
        GoRoute(
          path: 'add-security',
          builder: (context, state) => const AddSecurityPage(),
        ),
        GoRoute(
          path: 'sbt-secure-product',
          builder: (context, state) => const SbtSecureProductPage(),
        ),
        GoRoute(
          path: 'sbt-unsecure-product',
          builder: (context, state) => const SbtUnsecureProductPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AG Broker',
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
