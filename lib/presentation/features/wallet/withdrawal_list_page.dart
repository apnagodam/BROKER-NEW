import 'package:ag_broker/domain/entities/withdrawal_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/withdrawal_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class WithdrawalListPage extends ConsumerStatefulWidget {
  const WithdrawalListPage({super.key});

  @override
  ConsumerState<WithdrawalListPage> createState() => _WithdrawalListPageState();
}

class _WithdrawalListPageState extends ConsumerState<WithdrawalListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch withdrawal list when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = Localizations.localeOf(context);
      ref.read(withdrawalStateProvider(locale).notifier).fetchWithdrawalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final withdrawalState = ref.watch(withdrawalStateProvider(locale));
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          localizations.withdrawalHistory,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: withdrawalState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : withdrawalState.error != null
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
                      withdrawalState.error!,
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
                      ref
                          .read(withdrawalStateProvider(locale).notifier)
                          .fetchWithdrawalList();
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
          : withdrawalState.withdrawalList == null ||
                withdrawalState.withdrawalList!.data == null ||
                withdrawalState.withdrawalList!.data!.isEmpty
          ? Center(
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
                    localizations.noWithdrawalRequests,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(withdrawalStateProvider(locale).notifier)
                    .fetchWithdrawalList();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: withdrawalState.withdrawalList!.data!.length,
                itemBuilder: (context, index) {
                  final withdrawal =
                      withdrawalState.withdrawalList!.data![index];
                  return _buildWithdrawalCard(context, withdrawal);
                },
              ),
            ),
    );
  }

  Widget _buildWithdrawalCard(BuildContext context, WithdrawalData withdrawal) {
    final status = _getStatusInfo(withdrawal.status);
    final createdDate = _formatDate(withdrawal.createdAt.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showWithdrawalDetails(context, withdrawal);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: status['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      status['icon'],
                      color: status['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Amount and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${_formatAmount(withdrawal.requestedAmount ?? "0")}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'WRR: ${withdrawal.wrr ?? '-'}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: status['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status['color'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Bank Details
              Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      withdrawal.bankName ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    createdDate,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawalDetails(BuildContext context, WithdrawalData withdrawal) {
    final status = _getStatusInfo(withdrawal.status);
    final localizations = AppLocalizations.of(context)!;

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
        child: SingleChildScrollView(
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
                      color: status['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      status['icon'],
                      color: status['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(  
                          localizations.withdrawalDetails,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          status['label'],
                          style: TextStyle(
                            fontSize: 14,
                            color: status['color'],
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

              // Requested Amount
              _buildDetailRow(
                localizations.requestedAmount,
                '₹${_formatAmount(withdrawal.requestedAmount ?? "0")}',
                isHighlight: true,
              ),
              const Divider(height: 24),

              // WRR
              _buildDetailRow(
                localizations.wrr,
                withdrawal.wrr?.toString() ?? '-',
              ),
              const SizedBox(height: 12),

              // Bank Details Section
              Text(   
                localizations.bankDetails,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                localizations.bankName,
                withdrawal.bankName ?? '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                localizations.accountNumber,
                withdrawal.accountNumber ?? '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                localizations.ifscCode,
                withdrawal.ifscCode ?? '-',
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                localizations.branch,
                withdrawal.bankBranch ?? '-',
              ),
              const Divider(height: 24),

              // Approved Amount (if available)
              if (withdrawal.approvedAmount != null &&
                  withdrawal.approvedAmount != '0.00')
                Column(
                  children: [
                    _buildDetailRow(
                      localizations.approvedAmount,
                      '₹${_formatAmount(withdrawal.approvedAmount ?? "0")}',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              // Reference Number (if available)
              if (withdrawal.referenceNo != null &&
                  withdrawal.referenceNo!.isNotEmpty)
                Column(
                  children: [
                    _buildDetailRow(
                      localizations.referenceNumber,
                      withdrawal.referenceNo ?? '-',
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              // Dates
              _buildDetailRow(
                localizations.requestedDate,
                _formatDate(withdrawal.createdAt.toString()),
              ),
              const SizedBox(height: 12),

              if (withdrawal.approvedDate != null)
                _buildDetailRow(
                  localizations.approvedDate,
                  _formatDate(withdrawal.approvedDate.toString()),
                ),

              // Remark (if available)
              if (withdrawal.remark != null && withdrawal.remark!.isNotEmpty)
                Column(
                  children: [
                    const Divider(height: 24),
                    Text(
                      localizations.remark,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      withdrawal.remark ?? '-',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
            ],
          ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight
                  ? Theme.of(context).primaryColor
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatusInfo(dynamic status) {
    switch (status.toString()) {
      case '0':
        return {
          'label': 'Rejected',
          'color': Colors.red,
          'icon': Icons.pending,
        };
      case '1':
        return {
          'label': 'Pending',
          'color': Colors.orange,
          'icon': Icons.check_circle,
        };

      case '2':
        return {
          'label': 'Approved',
          'color': Colors.green,
          'icon': Icons.done_all,
        };
      default:
        return {
          'label': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
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
