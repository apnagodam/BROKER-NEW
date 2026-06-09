import 'package:ag_broker/domain/entities/user_details_model.dart';
import 'package:ag_broker/domain/entities/wallet_statement_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:ag_broker/presentation/common/widgets/gradient_info_card.dart';
import 'package:ag_broker/presentation/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WalletStatementPage extends ConsumerStatefulWidget {
  const WalletStatementPage({super.key});

  @override
  _WalletStatementPageState createState() => _WalletStatementPageState();
}

class _WalletStatementPageState extends ConsumerState<WalletStatementPage> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    // Initialize with default date range (last 30 days)
    _toDate = DateTime.now();
    _fromDate = _toDate!.subtract(const Duration(days: 30));

    // Fetch wallet statement when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWalletStatement();
      ref.read(authStateProvider.notifier).getUserDetails();
    });
  }

  void _fetchWalletStatement() {
    final locale = Localizations.localeOf(context);
    final fromDateStr = DateFormat('yyyy-MM-dd').format(_fromDate!);
    final toDateStr = DateFormat('yyyy-MM-dd').format(_toDate!);
    ref
        .read(walletStateProvider(locale).notifier)
        .fetchWalletStatement(fromDateStr, toDateStr);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final walletState = ref.watch(walletStateProvider(locale));
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          localizations.walletStatement,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: walletState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : walletState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.errorOccurred,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      walletState.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _fetchWalletStatement();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(localizations.retry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : walletState.walletStatement == null
          ? Center(
              child: Text(
                localizations.noDataAvailable,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _fetchWalletStatement();
              },
              child: Column(
                children: [
                  // Date Selector
                  _buildDateSelector(context),

                  // Power Section
                  _buildPowerSectionWithLoading(context),

                  // Balance Cards
                  _buildBalanceSection(context, walletState.walletStatement),

                  // Transactions List
                  Expanded(
                    child: _buildTransactionsList(
                      context,
                      walletState.walletStatement!,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Container(   
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              context,
              'From Date',
              _fromDate!,
              () => _selectFromDate(context),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: _buildDateField(
              context,
              'To Date',
              _toDate!,
              () => _selectToDate(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime date,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate!,
      firstDate: DateTime(2020),
      lastDate: _toDate!,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
      _fetchWalletStatement();
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate!,
      firstDate: _fromDate!,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
      _fetchWalletStatement();
    }
  }

  Widget _buildPowerSectionWithLoading(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final localizations = AppLocalizations.of(context)!;

    if (authState.isLoading) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        ),
      );
    }

    if (authState.error != null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                authState.error!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    if (authState.userDetails?.userDetails == null) {
      return const SizedBox.shrink();
    }

    return _buildPowerSection(authState.userDetails!, localizations);
  }

  Widget _buildBalanceSection(
    BuildContext context,
    WalletStatementModel? statement,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceCard(
                localizations.openingBalance,
                '₹${_formatAmount("${statement?.openingBalance ?? "0"}")}',
                Icons.account_balance_wallet_outlined,
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildBalanceCard(
                localizations.closingBalance,
                '₹${_formatAmount("${statement?.closingBalance ?? "0"}")}',
                Icons.account_balance,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSection(
    UserDetailsModel userDetails,
    AppLocalizations localizations,
  ) {
    final power = userDetails.userDetails?.power ?? 0;

    return GradientInfoCard(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      gradientColors: [Colors.orange.shade700, Colors.orange.shade600],
      shadowColor: Colors.orange.withValues(alpha: 0.3),
      icon: Icons.flash_on,
      label: 'Power',
      value: _formatAmount(power.toString()),
    );
  }

  Widget _buildBalanceCard(String label, String amount, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    WalletStatementModel statement,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final transactions = statement.data ?? [];

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.noTransactionsAvailable,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(context, transaction);
      },
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionData transaction,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final isCredit = transaction.type?.toString().toLowerCase() == 'credit';
    final date = _formatDate(transaction.date.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(context, transaction);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Transaction Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCredit
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Transaction Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.label ?? localizations.unknown,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction.referenceNo ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isCredit ? '+' : '-'} ₹${_formatAmount(transaction.amount ?? "0")}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCredit ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${localizations.balance}: ₹${_formatAmount(transaction.balance ?? "0")}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    TransactionData transaction,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final isCredit = transaction.type?.toString().toLowerCase() == 'credit';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCredit ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCredit ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.transactionDetails,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        transaction.type ?? localizations.unknown,
                        style: TextStyle(
                          fontSize: 14,
                          color: isCredit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount
            _buildDetailRow(
              localizations.amount,
              '₹${_formatAmount(transaction.amount ?? "0")}',
              isHighlight: true,
            ),
            const Divider(height: 24),

            // Label
            _buildDetailRow(
              localizations.label,
              transaction.label ?? localizations.unknown,
            ),
            const SizedBox(height: 12),

            // Reference Number
            _buildDetailRow(
              localizations.referenceNumber,
              transaction.referenceNo ?? '-',
            ),
            const SizedBox(height: 12),

            // Balance
            _buildDetailRow(
              localizations.balance,
              '₹${_formatAmount(transaction.balance ?? "0")}',
            ),
            const SizedBox(height: 12),

            // Date
            _buildDetailRow(
              localizations.date,
              _formatDate(transaction.date.toString()),
            ),
            const SizedBox(height: 12),

            // Narration
            const Divider(height: 24),
            Text(
              localizations.narration,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              transaction.narration ?? localizations.noDataAvailable,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text( 
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 18 : 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight
                ? Theme.of(context).primaryColor
                : Colors.black87,
          ),
        ),
      ],
    );
  }

  String _formatAmount(String amount) {
    try {
      final double value = double.parse(amount);
      final formatter = NumberFormat('#,##,##0.00', 'en_IN');
      return formatter.format(value);
    } catch (e) {
      return amount;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
