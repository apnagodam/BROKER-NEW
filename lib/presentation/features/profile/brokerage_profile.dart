import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ag_broker/l10n/app_localizations.dart';

class BrokerageProfile extends ConsumerStatefulWidget {
  const BrokerageProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BrokerageProfileState();
}

class _BrokerageProfileState extends ConsumerState<BrokerageProfile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).getBrokerage();
      ref.read(authStateProvider.notifier).getUserDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brokerage = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.brokerageProfile),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              brokerage.isBrokerageLoading
                  ? Center(child: CircularProgressIndicator())
                  : brokerage.brokerageResponse != null
                  ? HtmlWidget(brokerage.brokerageResponse?['data'] ?? '')
                  : Text(
                      AppLocalizations.of(
                        context,
                      )!.noBrokerageInformationAvailable,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
