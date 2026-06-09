import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MembersHubPage extends StatelessWidget {
  final int memberType;
  const MembersHubPage({super.key, required this.memberType});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    // Member (1): Client List only
    // TM (2): Client List, Authorised Person, Add Security
    // STCM (3): Client List, Authorised Person, Trading Member

    final List<_MemberItem> items = [
      // Client List — all roles
      _MemberItem(
        icon: Icons.people_outline,
        iconColor: primary,
        iconBg: primary.withValues(alpha: 0.1),
        title: 'Client List',
        subtitle: 'View & manage LP clients',
        route: '/home/lp-clients',
      ),

      // Authorised Person — TM (2) and STCM (3)
      if (memberType == 2 || memberType == 3)
        _MemberItem(
          icon: Icons.verified_user_outlined,
          iconColor: Colors.teal.shade800,
          iconBg: Colors.teal.shade50,
          title: 'Authorised Person',
          subtitle: 'Manage your authorised agents',
          route: '/home/authorised-person',
        ),

      // Add Security — TM (2) only
      if (memberType == 2)
        _MemberItem(
          icon: Icons.security_outlined,
          iconColor: Colors.red.shade800,
          iconBg: Colors.red.shade50,
          title: 'Add Security',
          subtitle: 'Pledge or add collateral',
          route: '/home/add-security',
        ),

      // Trading Member — STCM (3) only
      if (memberType == 3)
        _MemberItem(
          icon: Icons.account_balance_outlined,
          iconColor: Colors.deepPurple.shade700,
          iconBg: Colors.deepPurple.shade50,
          title: 'Trading Member',
          subtitle: 'View associated trading members',
          route: '/home/trading-member',
        ),

      // TM Fees — TM (2) only
      if (memberType == 2)
        _MemberItem(
          icon: Icons.currency_rupee_rounded,
          iconColor: Colors.orange.shade800,
          iconBg: Colors.orange.shade50,
          title: 'TM Fees',
          subtitle: 'Trading member fee details',
          route: '/home/tm-fees',
        ),

      // Margin Funding items — STCM (3) only
      if (memberType == 3) ...[
        _MemberItem(
          icon: Icons.percent_outlined,
          iconColor: Colors.green.shade700,
          iconBg: Colors.green.shade50,
          title: 'Schemes',
          subtitle: 'View margin funding schemes',
          route: '/home/margin-funding-schemes',
        ),
        _MemberItem(
          icon: Icons.credit_score_outlined,
          iconColor: Colors.green.shade700,
          iconBg: Colors.green.shade50,
          title: 'Margin Funding Limit',
          subtitle: 'Check your funding limits',
          route: '/home/margin-funding-limit',
        ),
        _MemberItem(
          icon: Icons.request_page_outlined,
          iconColor: Colors.green.shade700,
          iconBg: Colors.green.shade50,
          title: 'Margin Funding Request',
          subtitle: 'Submit a margin funding request',
          route: '/home/margin-funding-request',
        ),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No options available.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
            )
          : ListView.separated(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(item.icon, color: item.iconColor, size: 22),
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

class _MemberItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String route;

  const _MemberItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}