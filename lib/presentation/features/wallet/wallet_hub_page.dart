import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WalletHubPage extends StatelessWidget {
  final int memberType;
  const WalletHubPage({super.key, required this.memberType});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    // Member (1): Brokerage Wallet Statement, Withdrawal Request
    // TM (2): Brokerage Wallet Statement, Trade Power Statement, Withdrawal Request
    // STCM (3): Brokerage Wallet Statement, Trade Power Statement, Withdrawal Request

    final List<_WalletItem> items = [
      // Brokerage Wallet Statement — all roles
      _WalletItem(
        icon: Icons.receipt_long,
        iconColor: primary,
        iconBg: primary.withValues(alpha: 0.1),
        title: 'Brokerage Wallet Statement',
        subtitle: 'View all wallet transactions',
        route: '/home/wallet-statement',
      ),

      // Trade Power Statement — TM (2) and STCM (3) only
      if (memberType == 2 || memberType == 3)
        _WalletItem(
          icon: Icons.bar_chart_rounded,
          iconColor: Colors.blue.shade800,
          iconBg: Colors.blue.shade50,
          title: 'Trade Power Statement',
          subtitle: 'Track your trading power usage',
          route: '/home/trade-power-statement',
        ),

      // Withdrawal Request — all roles
      _WalletItem(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Colors.orange.shade800,
        iconBg: Colors.orange.shade50,
        title: 'Withdrawal Request',
        subtitle: 'Request payout to your bank',
        route: '/home/withdrawal-request',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Icon(Icons.chevron_right,
                  color: Colors.grey.shade400, size: 22),
              onTap: () => context.go(item.route),
            ),
          );
        },
      ),
    );
  }
}

class _WalletItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String route;

  const _WalletItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}