import 'package:ag_broker/core/theme/app_theme.dart';
import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/notification_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/features/auth/login/login_page.dart';
import 'package:ag_broker/presentation/features/auth/otp_verification_page.dart';
import 'package:ag_broker/presentation/features/bids/bids_history_page.dart';
import 'package:ag_broker/presentation/features/home/home_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/add_lp_client_page.dart';
import 'package:ag_broker/presentation/features/lp_clients/lp_client_list_page.dart';
import 'package:ag_broker/presentation/features/profile/brokerage_profile.dart';
import 'package:ag_broker/presentation/features/profile/profile_page.dart';
import 'package:ag_broker/presentation/features/truck_load/truck_load_details_screen.dart';
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
        // Perform immediate update
        InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            //App Update successful
          }
        });
      } else if (updateInfo.flexibleUpdateAllowed) {
        //Perform flexible update
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            //App Update successful
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
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      routes: [],
    ),
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
        GoRoute(
          path: 'lp-clients/add',
          builder: (context, state) => const AddLpClientPage(),
        ),
        GoRoute(
          path: 'lp-clients',
          builder: (context, state) => const LpClientListPage(),
        ),
        GoRoute(path: 'profile', builder: (context, state) => ProfilePage()),
        GoRoute(
          path: 'bids-history',
          builder: (context, state) => BidsHistoryPage(),
        ),
        GoRoute(
          path: 'brokerage-profile',
          builder: (context, state) => BrokerageProfile(),
        ),
        GoRoute(
          path: 'wallet-statement',
          builder: (context, state) => WalletStatementPage(),
        ),
        GoRoute(
          path: 'withdrawal-request',
          builder: (context, state) => WithdrawalRequestPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current locale from the provider
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'AG Broker',
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
