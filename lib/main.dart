import 'package:ag_broker/core/providers/router_provider.dart';
import 'package:ag_broker/core/theme/app_theme.dart';
import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/notification_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/features/Tm_fees_page.dart';
import 'package:ag_broker/presentation/features/add_security_page.dart';
import 'package:ag_broker/presentation/features/auth/login/login_page.dart';
import 'package:ag_broker/presentation/features/auth/login/otp_verification_page.dart';
import 'package:ag_broker/presentation/features/deals/running_deals_page.dart';
import 'package:ag_broker/presentation/features/deals/delivered_deals_page.dart';
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
import 'package:ag_broker/presentation/marging/scheme_screen.dart';
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



// ── Temporary placeholder ─────────────────────────────────────────────────────
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
            Text(title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Coming soon',
                style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AG Broker',
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}