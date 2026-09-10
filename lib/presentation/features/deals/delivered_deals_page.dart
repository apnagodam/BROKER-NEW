import 'package:ag_broker/domain/entities/running_deal_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeliveredDealsPage extends ConsumerStatefulWidget {
  const DeliveredDealsPage({super.key});

  @override
  ConsumerState<DeliveredDealsPage> createState() => _DeliveredDealsPageState();
}

class _DeliveredDealsPageState extends ConsumerState<DeliveredDealsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stackStateProvider.notifier).fetchDeliveredDeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final stackState = ref.watch(stackStateProvider);
    final deliveredDeals = stackState.deliveredDealsData?.data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          localizations.deliveredDeals,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(stackStateProvider.notifier).fetchDeliveredDeals();
        },
        child: stackState.isDeliveredDealsLoading
            ? const Center(child: CircularProgressIndicator())
            : deliveredDeals.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                localizations.noDeliveredDeals,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton.icon(
                                onPressed: () {
                                  ref
                                      .read(stackStateProvider.notifier)
                                      .fetchDeliveredDeals();
                                },
                                icon: const Icon(Icons.refresh),
                                label: Text(localizations.retry),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
                                  side: const BorderSide(color: Color(0xFF2E7D32)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: deliveredDeals.length,
                    itemBuilder: (context, index) {
                      final item = deliveredDeals[index];
                      return _buildDealCard(context, ref, item, localizations);
                    },
                  ),
      ),
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    WidgetRef ref,
    RunningDealItem item,
    AppLocalizations localizations,
  ) {
    final isSell = item.dealType.toString().toLowerCase().contains('sell');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header: Order ID (Left) & BUY/SELL Badge (Right) ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.green.shade400,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tag,
                          size: 14,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${localizations.orderId}: ${item.orderId}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (item.dealType.toString().isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSell
                          ? Colors.orange.shade50
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSell
                            ? Colors.orange.shade300
                            : Colors.blue.shade300,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isSell
                          ? localizations.sellDeal
                          : localizations.buyDeal,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: isSell
                            ? Colors.orange.shade900
                            : Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // ── Match Date (Row 2) ──────────────────────────────────────────
            if (item.orderMatchDate.toString().isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 13,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${localizations.matchDate}: ${item.orderMatchDate}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 10),

            // ── Client Name & Warehouse ─────────────────────────────────────
            if (item.buyerName.toString().isNotEmpty &&
                item.sellerName.toString().isNotEmpty &&
                item.buyerName.toString() != item.sellerName.toString()) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 15,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: "${localizations.buyerClient}: ",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.buyerName}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 15,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                        ),
                        children: [
                          TextSpan(
                            text: "${localizations.sellerClient}: ",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.sellerName}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (item.clientName.toString().isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 15,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: "${localizations.client}: ",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.clientName}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (item.productName.toString().isNotEmpty) ...[
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warehouse_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "${item.productName}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // ── Deal Metrics Box ────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: localizations.commodity,
                          value:
                              "${item.commodity.toString().isNotEmpty ? item.commodity : item.commodityName}",
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          label: localizations.priceRupees,
                          value: "₹${item.price}",
                          valueColor: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: localizations.weightQtl,
                          value: "${item.weight} ${localizations.quintal}",
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          label: localizations.deliveredQty,
                          value:
                              "${item.deliveredWeight} ${localizations.quintal}",
                          valueColor: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (item.deliveryDays.toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${localizations.deliveryDaysLabel}: ${item.deliveryDays}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
