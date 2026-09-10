import 'package:ag_broker/domain/entities/lp_client_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/lp_client_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LpClientListPage extends ConsumerStatefulWidget {
  const LpClientListPage({super.key});

  @override
  _LpClientListPageState createState() => _LpClientListPageState();
}

class _LpClientListPageState extends ConsumerState<LpClientListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch client list when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchClientList();
    });
  }

  void _fetchClientList() {
    final locale = Localizations.localeOf(context);
    ref.read(lpClientStateProvider(locale).notifier).fetchLpClientList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final clientState = ref.watch(lpClientStateProvider(locale));
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
          localizations.lpClientList,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () {
              context.push('/home/lp-clients/add');
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              localizations.addLpClient,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: clientState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : clientState.error != null
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
                      clientState.error!,
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
                      _fetchClientList();    
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
          : clientState.clientList == null ||
                clientState.clientList!.data == null ||
                clientState.clientList!.data!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [  
                  Icon(  
                    Icons.people_outline,
                    size: 64,  
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.noDataAvailable,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {   
                _fetchClientList();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clientState.clientList!.data!.length,
                itemBuilder: (context, index) {
                  final client = clientState.clientList!.data![index];
                  return _buildClientCard(context, client);
                },
              ),
            ),
    );
  }

  Widget _buildClientCard(BuildContext context, LpClient client) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
        },
        child: Padding(   
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Name and Status Chips
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Icon
                  Container(   
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and Constitution
                  Expanded(
                    child: Column(   
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name?.toString() ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(      
                          client.constitution?.toString() ?? 'N/A',
                          style: TextStyle(    
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildApprovalChip(   
                    context,
                    localizations.approved,
                    client.approveBy,
                  ),
                  _buildApprovalChip(   
                    context,
                    localizations.verified,
                    client.verifyBy,
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 12),

              // Contact Information in Grid
              _buildInfoSection(context, localizations, client),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(   
    BuildContext context,
    AppLocalizations localizations,
    LpClient client,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(  
              child: _buildInfoItem(  
                Icons.phone_outlined,
                localizations.phone,
                client.phone?.toString() ?? 'N/A',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(  
              child: _buildInfoItem(    
                Icons.badge_outlined,
                localizations.userId,
                client.userId?.toString() ?? 'N/A',
              ),
            ),
          ],
        ),
        if (client.panNumber != null || client.aadharNumber != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [   
              if (client.panNumber != null)
                Expanded(    
                  child: _buildInfoItem(    
                    Icons.credit_card,
                    localizations.pan,
                    client.panNumber.toString(),
                  ),
                ),
              if (client.panNumber != null && client.aadharNumber != null)
                const SizedBox(width: 12),
              if (client.aadharNumber != null)
                Expanded(
                  child: _buildInfoItem(
                    Icons.fingerprint,
                    localizations.aadhar,
                    client.aadharNumber.toString(),
                  ),
                ),
            ],
          ),
        ],
        if (client.gstNumber != null) ...[
          const SizedBox(height: 12),
          _buildInfoItem(   
            Icons.receipt_long_outlined,
            localizations.gst,
            client.gstNumber.toString(),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(   
      padding: const EdgeInsets.all(10),
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
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(  
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(  
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalChip(BuildContext context, String label, dynamic value) {
    final bool hasValue = value != null;
    return Chip(
      avatar: Icon(  
        hasValue ? Icons.check_circle : Icons.cancel,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(  
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: hasValue ? Colors.green : Colors.red.shade400,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
