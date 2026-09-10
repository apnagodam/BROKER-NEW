import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart' as client;
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/features/truck_load/submit_bid_screen.dart';
import 'package:ag_broker/core/utils/product_helper.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TruckLoadDetailsScreen extends ConsumerStatefulWidget {
  final int index;

  const TruckLoadDetailsScreen({super.key, required this.index});

  @override
  ConsumerState<TruckLoadDetailsScreen> createState() =>
      _TruckLoadDetailsScreenState();
}

class _TruckLoadDetailsScreenState
    extends ConsumerState<TruckLoadDetailsScreen> {
  List<client.Datum>? clientsList;

  @override
  void initState() {
    // Cache the data once - use ref.read to avoid rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(bidsStateProvider.notifier).fetchClientList();
      clientsList = ref.read(bidsStateProvider).clientListData?.data ?? [];
      ref.read(stackStateProvider.notifier).fetchRunningDeals();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final stackData =
        ref.watch(stackStateProvider).stackSellData?.data?[widget.index];
    final bool isFactory = ProductHelper.isFactoryDelivery(
      null,
      "${stackData?.warehouseName ?? ''} ${stackData?.warehouseAddress ?? ''}",
    );
    final Color themeColor = ProductHelper.deliveryBorderColor(isFactory);
    final String cleanCommodity = ProductHelper.cleanCommodityName(
      stackData?.commodityName,
      stackData?.warehouseName,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
          localizations.stackSellBid,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(stackStateProvider.notifier).fetchStackSellList(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Card matching delivery type (Green for warehouse, Orange for factory)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stack No. Header with delivery type badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${localizations.stackNoWithDash} ${stackData?.stackNumber ?? ''}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isFactory
                                      ? localizations.factoryDelivery
                                      : localizations.warehouseDelivery,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 20),

                      // Terminal Name
                      Text(
                        localizations.terminalName(stackData?.warehouseName ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 20),

                      // Commodity Name (Deduplicated)
                      Text(
                        localizations.commodityLabel(cleanCommodity),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 20),

                      // Warehouse Address
                      Text(
                        localizations.warehouseAddress(stackData?.warehouseAddress ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      Divider(color: Colors.white24, height: 20),

                      // Quantity and Seller Price Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${localizations.quantityQuintal} : ${stackData?.quantity ?? ''}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.white24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localizations.sellerPriceLabel(
                                stackData?.sellerPrice?.toString() ?? '0',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Green Action Button "बोली जोड़ें" (Add Bid)
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _openBidSubmitScreen(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      localizations.addBid,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bid History Section Header "बोली इतिहास"
                Text(
                  localizations.bidHistory,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Bid History Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _buildBidHistorySection(context, stackData, localizations),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBidSubmitScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubmitBidScreen(index: widget.index),
      ),
    );
  }

  Widget _buildBidHistorySection(
    BuildContext context,
    Datum? stackData,
    AppLocalizations localizations,
  ) {
    final bids = stackData?.stackBuySellConver ?? [];
    if (bids.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            localizations.noBidHistoryAvailable,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return Column(
      children: bids.asMap().entries.map((entry) {
        final index = entry.key;
        final bid = entry.value;
        final buyerTitle = bid.userName != null && bid.userName.toString().isNotEmpty
            ? bid.userName.toString()
            : "${localizations.buyerClient} ${index + 1}";

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: index < bids.length - 1 ? 8 : 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${localizations.priceRupees}: ₹${bid.price ?? '0'}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (bid.createdAt != null && bid.createdAt.toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  "${localizations.matchDate}: ${bid.createdAt}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                buyerTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
