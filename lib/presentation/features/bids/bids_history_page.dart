import 'package:ag_broker/domain/entities/deals_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BidsHistoryPage extends ConsumerStatefulWidget {
  const BidsHistoryPage({super.key});

  @override
  _BidsHistoryPageState createState() => _BidsHistoryPageState();
}

class _BidsHistoryPageState extends ConsumerState<BidsHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch deals list when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bidsStateProvider.notifier).fetchDealsList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bidsState = ref.watch(bidsStateProvider);
    final localizations = AppLocalizations.of(context)!;

    // Filter deals by type
    final allDeals = bidsState.dealsListData?.orderData ?? [];
    final _ = allDeals
        .where((deal) => deal.dealType?.toString().toLowerCase() == 'buy')
        .toList();
    final _ = allDeals
        .where((deal) => deal.dealType?.toString().toLowerCase() == 'sell')
        .toList();

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
          localizations.bidsHistory,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 16),
                      SizedBox(width: 6),
                      Text(
                        localizations.buy,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sell_outlined, size: 16),
                      SizedBox(width: 6),
                      Text(
                        localizations.sell,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 2,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey.shade500,
            ),
          ),
        ),
      ),
      body: bidsState.isLoadingDeals
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : bidsState.error != null
          ? _buildErrorWidget(bidsState.error!, localizations)
          : TabBarView(
              controller: _tabController,
              children: [
                // Buy Tab
                _buildDealsList(
                  ref.watch(bidsStateProvider).buyList ?? [],
                  'buy',
                  localizations,
                ),
                // Sell Tab
                _buildDealsList(
                  ref.watch(bidsStateProvider).sellList ?? [],
                  'sell',
                  localizations,
                ),
              ],
            ),
    );
  }

  Widget _buildDealsList(
    List<OrderDatum> deals,
    String type,
    AppLocalizations localizations,
  ) {
    if (deals.isEmpty) {
      return _buildEmptyWidget(type, localizations);
    }

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      onRefresh: () => ref.read(bidsStateProvider.notifier).fetchDealsList(),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300 + (index * 50)),
            child: _buildBidCard(deals[index], type),
          );
        },
      ),
    );
  }

  Widget _buildBidCard(OrderDatum order, String type) {
    final localizations = AppLocalizations.of(context)!;
    final dealStatus = order.dealStatus?.toString() ?? '';
    final isComplete = dealStatus.toLowerCase() == 'complete';
    final isBuy = type.toLowerCase() == 'buy';

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isBuy
                              ? Colors.blue.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isBuy
                                ? Colors.blue.shade200
                                : Colors.orange.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isBuy
                                          ? Colors.blue.shade200
                                          : Colors.orange.shade200)
                                      .withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isBuy
                              ? Icons.shopping_bag_outlined
                              : Icons.sell_outlined,
                          color: isBuy
                              ? Colors.blue.shade700
                              : Colors.orange.shade700,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.orderId,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              order.orderId?.toString() ??
                                  localizations.notAvailable,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isComplete
                          ? Colors.green.shade300
                          : Colors.orange.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isComplete
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300)
                                .withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    dealStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isComplete
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Commodity & Product
                _buildSimpleRow(
                  localizations.commodity,
                  order.commodityName?.toString() ?? localizations.notAvailable,
                  Icons.grass_outlined,
                ),
                SizedBox(height: 12),
                _buildSimpleRow(
                  localizations.product,
                  order.productName?.toString() ?? localizations.notAvailable,
                  Icons.inventory_2_outlined,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Colors.grey.shade200),
                ),

                // Price and Quantities
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        localizations.price,
                        '₹${order.price?.toString() ?? '0'}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoBox(
                        localizations.dealQty,
                        '${order.dealQty?.toString() ?? '0'} ${localizations.quintal}',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoBox(
                        localizations.delivered,
                        '${order.delaverQty?.toString() ?? '0'} ${localizations.quintal}',
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Colors.grey.shade200),
                ),

                // Buyer and Seller
                _buildSimpleRow(
                  localizations.buyer,
                  order.buyerName?.toString() ?? localizations.notAvailable,
                  Icons.person_outline,
                ),
                SizedBox(height: 12),
                _buildSimpleRow(
                  localizations.seller,
                  order.sellerName?.toString() ?? localizations.notAvailable,
                  Icons.store_outlined,
                ),

                SizedBox(height: 16),

                // Order Matching Date
                _buildSimpleRow(
                  localizations.orderMatching,
                  _formatDate(order.orderMatchDate?.toString()),
                  Icons.access_time,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String type, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 72, color: Colors.grey.shade400),
            SizedBox(height: 20),
            Text(
              type == 'buy'
                  ? localizations.noBuyDeals
                  : localizations.noSellDeals,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              type == 'buy'
                  ? localizations.yourBuyDealsWillAppearHere
                  : localizations.yourSellDealsWillAppearHere,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 72, color: Colors.red.shade300),
            SizedBox(height: 20),
            Text(
              localizations.errorLoadingBids,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(bidsStateProvider.notifier).fetchDealsList();
              },
              icon: Icon(Icons.refresh, size: 18),
              label: Text(
                localizations.retry,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
  
}
