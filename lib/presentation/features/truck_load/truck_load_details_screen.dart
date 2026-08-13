import 'package:ag_broker/domain/entities/running_deal_model.dart';
import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart' as client;
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
  final TextEditingController _bidAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<client.Datum>? clientsList;
  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

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

    final headerTitle = stackData != null
        ? "${stackData.commodityName} (${stackData.warehouseName} ( Stack No.${stackData.stackNumber} )${stackData.deliveryDays != null ? ' , Manda Delivery Days :- ${stackData.deliveryDays}' : ''})- ${stackData.warehouseName} ( Stack No.${stackData.stackNumber} )${stackData.deliveryDays != null ? ' , Manda Delivery Days :- ${stackData.deliveryDays}' : ''}"
        : "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.watch(stackStateProvider.notifier).fetchStackSellList(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Text Centered in Green
                Text(
                  headerTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),

                // Best Buyer : 0 | Best Seller : 0 Grey Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Best Buyer: ${stackData?.bestBuyerPrice ?? 0}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        "Best Seller: ${stackData?.sellerPrice ?? 0}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Buy & Sell Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openBidSubmitDialog(context, localizations),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Buy",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _openBidSubmitDialog(context, localizations),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Sell",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Buyer Section Header
                const Text(
                  "Buyer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _buildBuyerBidsList(context, stackData),
                ),
                const SizedBox(height: 20),

                // Seller Section Header
                const Text(
                  "Seller",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _buildSellerBidsList(context, stackData),
                ),
                const SizedBox(height: 20),

                // Matched Orders Section Header
                const Text(
                  "Matched Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMatchedOrdersCard(context, ref, stackData),

                const SizedBox(height: 16),
                _buildRunningDealsSection(context, ref),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBidSubmitDialog(
    BuildContext context,
    AppLocalizations localizations,
  ) async {
    ref.read(bidsStateProvider.notifier).setClient(null);
    setState(() {});
    await NavigationService.showDialogGlobal(
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.submitBid),
          content: bidSubmitLayout(localizations),
        );
      },
    );
    ref.read(bidsStateProvider.notifier).setClient(null);
  }

  Widget _buildBuyerBidsList(BuildContext context, Datum? stackData) {
    final list = stackData?.stackBuySellConver ?? [];
    if (list.isEmpty) {
      return const Center(
        child: Text(
          "No Bids",
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      );
    }
    return Column(
      children: list.map((bid) => _buildBidRow(context, bid)).toList(),
    );
  }

  Widget _buildSellerBidsList(BuildContext context, Datum? stackData) {
    // Return No Bids or Seller bids if segregated
    return const Center(
      child: Text(
        "No Bids",
        style: TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _buildBidRow(BuildContext context, dynamic bid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Price: ₹${bid.price}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          if (bid.userName != null)
            Text(
              "${bid.userName}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchedOrdersCard(
    BuildContext context,
    WidgetRef ref,
    Datum? stackData,
  ) {
    final runningDeals =
        ref.watch(stackStateProvider).runningDealsData?.data ?? [];
    RunningDealItem? matchedDeal;
    for (var deal in runningDeals) {
      if (stackData?.id != null && deal.productId == stackData?.id) {
        matchedDeal = deal;
        break;
      }
    }
    if (matchedDeal == null && runningDeals.isNotEmpty) {
      matchedDeal = runningDeals.first;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Deal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC62828),
              ),
            ),
          ),
          const Divider(height: 16),
          Text(
            "Order ID: ${matchedDeal?.orderId ?? 'SBT-11082026-6968'}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Date: ${matchedDeal?.orderMatchDate ?? '11 Aug 2026'}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Expiry Date: ${matchedDeal?.orderMatchDate ?? '17 Aug 2026'}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget bidSubmitLayout(AppLocalizations localizations) => Consumer(
    builder: (context, ref, child) => SingleChildScrollView(
      child: Column(  
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [   
                Text(   
                  localizations.enterYourBidAmount,
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                // Bid Amount Input
                TextFormField(   
                  controller: _bidAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.enterBidAmountHint,
                    prefixIcon: Icon(  
                      Icons.currency_rupee,
                      color: Color(0xFF2E7D32),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2E7D32)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {   
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterBidAmount;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return localizations.pleaseEnterValidNumber;
                    }
                    if (amount <= 0) {
                      return localizations.bidAmountMustBeGreaterThanZero;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Client selection dropdown
                Container(   
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(  
                    child: Builder(
                      builder: (context) {  
                        final clients =
                            ref.watch(bidsStateProvider).clientListData?.data ??
                            [];
                        final selectedFromState = ref
                            .watch(bidsStateProvider)
                            .selectedClient;
                        final dropdownValue =
                            (selectedFromState != null &&
                                clients.any(
                                  (c) => c.userId == selectedFromState.userId,
                                ))
                            ? clients.firstWhere(
                                (c) => c.userId == selectedFromState.userId,
                              )
                            : null;

                        return DropdownButton<client.Datum?>(
                          isExpanded: true,
                          hint: Text(localizations.selectAClient),
                          value: dropdownValue,
                          items: [  
                            DropdownMenuItem<client.Datum?>(   
                              value: null,
                              child: Text(localizations.selectAClient),
                            ),
                            ...clients.map((clientItem) {
                              return DropdownMenuItem<client.Datum?>(
                                value: clientItem,
                                child: Text(
                                  clientItem.name ?? localizations.unknown,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ],
                          onChanged: (client.Datum? newValue) {   
                            ref
                                .read(bidsStateProvider.notifier)
                                .setClient(newValue);
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Cancel and Submit Buttons
                // Submit Button
                ref.read(stackStateProvider).isTermsLoading
                    ? Center(child: CircularProgressIndicator())
                    : HtmlWidget(
                        ref.read(stackStateProvider).stackSellTerms?['data'] ??
                            '',
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                SizedBox(height: 16),
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _bidAmountController.clear();
                            });
                            if (NavigationService.isDialogShown) {  
                              NavigationService.goBack();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE0E0E0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text( 
                            localizations.cancel,
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(  
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _submitBid();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(  
                            localizations.submitBid,
                            style: TextStyle(   
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  void _submitBid() {
    final bidAmount = _bidAmountController.text;

    ref
        .watch(stackStateProvider.notifier)
        .postStackBid(
          stackId:
              "${ref.watch(stackStateProvider).stackSellData?.data?[widget.index].id ?? ''}",
          price: bidAmount,
          userId:
              "${ref.watch(bidsStateProvider).selectedClient?.userId ?? ''}",
        );

    setState(() {
      _bidAmountController.clear();
    });
  }

  Widget _buildRunningDealsSection(BuildContext context, WidgetRef ref) {
    final stackState = ref.watch(stackStateProvider);
    final runningDeals = stackState.runningDealsData?.data ?? [];
    if (runningDeals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.local_shipping, color: Color(0xFF2E7D32)),
                  SizedBox(width: 8),
                  Text(
                    "Running Deals",
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              ...runningDeals.map((deal) => _buildRunningDealTile(context, ref, deal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRunningDealTile(
    BuildContext context,
    WidgetRef ref,
    RunningDealItem deal,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Text(
                    "Order ID: ${deal.orderId}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
              if (deal.orderMatchDate.toString().isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Match: ${deal.orderMatchDate}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (deal.clientName.toString().isNotEmpty)
            Text(
              "Client: ${deal.clientName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Commodity: ${deal.commodity.isNotEmpty ? deal.commodity : deal.commodityName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Price: ₹${deal.price}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Weight: ${deal.weight} Qtl.",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Delivered: ${deal.deliveredWeight} Qtl.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          if (deal.brokeroutWardview.toString() == "1") ...[
            const SizedBox(height: 10),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showOutwardRequestDialog(context, ref, deal),
                    icon: const Icon(Icons.add_circle_outline, size: 14),
                    label: const Text(
                      "Send Outward Request",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showViewOutwardRequestsDialog(
                      context,
                      ref,
                      deal.orderId.toString(),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 14),
                    label: const Text(
                      "See Outward Requests",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showOutwardRequestDialog(
    BuildContext context,
    WidgetRef ref,
    RunningDealItem deal,
  ) {
    final formKey = GlobalKey<FormState>();
    final truckNumberController = TextEditingController(
      text: deal.truckNumber.toString(),
    );
    final driverNumberController = TextEditingController(
      text: deal.driverNumber.toString(),
    );
    final weightController = TextEditingController(
      text: deal.weight.toString(),
    );
    List<dynamic> existingRequests = [];
    bool isLoadingRequests = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (isLoadingRequests) {
              ref
                  .read(stackStateProvider.notifier)
                  .fetchOrderOutwardInfo(deal.orderId.toString())
                  .then((info) {
                    if (info != null) {
                      final list = info['Data'] ?? info['data'];
                      if (list is List) {
                        existingRequests = list;
                      }
                    }
                    setDialogState(() {
                      isLoadingRequests = false;
                    });
                  });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Add OutWard Request Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(dialogCtx).pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Order ID : - ${deal.orderId}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        if (existingRequests.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Outward Requests (${existingRequests.length}):",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...existingRequests.map((req) {
                                  final truck =
                                      req['truckNumber'] ??
                                      req['truck_number'] ??
                                      '';
                                  final driver =
                                      req['driverNumber'] ??
                                      req['driver_number'] ??
                                      '';
                                  final w =
                                      req['outwardWeight'] ??
                                      req['weight'] ??
                                      '';
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline,
                                          size: 14,
                                          color: Color(0xFF2E7D32),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            "Truck: $truck | Driver: $driver | Weight: $w QTL",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        Text(
                          "Truck Number*",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: truckNumberController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: "Enter Truck Number",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2E7D32),
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade700,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter Truck Number";
                            }
                            if (val.trim().length < 4) {
                              return "Please enter valid Truck Number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        Text(
                          "Driver Number*",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: driverNumberController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: "Driver Number",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2E7D32),
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade700,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter Driver Number";
                            }
                            final digits = val.trim().replaceAll(
                              RegExp(r'\D'),
                              '',
                            );
                            if (digits.length != 10) {
                              return "Please enter valid 10-digit mobile number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        Text(
                          "Weight (QTL.)*",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter OutWard Weight",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2E7D32),
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red.shade700,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Please enter Outward Weight";
                            }
                            final weightVal = double.tryParse(val.trim());
                            if (weightVal == null || weightVal <= 0) {
                              return "Please enter valid weight in Quintals";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.of(dialogCtx).pop();
                              final success = await ref
                                  .read(stackStateProvider.notifier)
                                  .submitBuyerOutwardRequest(
                                    orderId: deal.orderId.toString(),
                                    truckNumber: truckNumberController.text
                                        .trim()
                                        .toUpperCase(),
                                    driverNumber:
                                        driverNumberController.text.trim(),
                                    weight: weightController.text.trim(),
                                  );
                              if (success && context.mounted) {
                                _showViewOutwardRequestsDialog(
                                  context,
                                  ref,
                                  deal.orderId.toString(),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Add / Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showViewOutwardRequestsDialog(
    BuildContext context,
    WidgetRef ref,
    String orderId,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: ref
                      .read(stackStateProvider.notifier)
                      .fetchOrderOutwardInfo(orderId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 180,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      );
                    }

                    final data = snapshot.data;
                    final list =
                        (data != null && data['Data'] is List)
                            ? (data['Data'] as List)
                            : [];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                              child: Text(
                                "Outward Requests",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(dialogCtx).pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            "Order ID: $orderId",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                        const Divider(height: 20),
                        if (list.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                "No Outward Requests Found",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          )
                        else
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    list.map((item) {
                                      final reqId =
                                          item['id'] ?? item['requestId'] ?? '';
                                      final truck =
                                          item['truckNumber'] ??
                                          item['truck_number'] ??
                                          '-';
                                      final driver =
                                          item['driverNumber'] ??
                                          item['driver_number'] ??
                                          '-';
                                      final weight =
                                          item['outwardWeight'] ??
                                          item['weight'] ??
                                          '-';
                                      final createdAt =
                                          item['created_at'] ?? '';
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.local_shipping,
                                                      size: 16,
                                                      color: Color(0xFF2E7D32),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      "Truck: $truck",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "$weight QTL",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      color: Color(0xFF2E7D32),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      size: 14,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "Driver: $driver",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (reqId
                                                    .toString()
                                                    .isNotEmpty)
                                                  InkWell(
                                                    onTap: () {
                                                      _confirmRejectRequest(
                                                        context,
                                                        ref,
                                                        reqId.toString(),
                                                        truck.toString(),
                                                        () {
                                                          setDialogState(() {});
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade50,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors
                                                              .red
                                                              .shade200,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            size: 13,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            "Reject",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            if (createdAt.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Created: $createdAt",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmRejectRequest(
    BuildContext context,
    WidgetRef ref,
    String requestId,
    String truckNumber,
    VoidCallback onDone,
  ) {
    showDialog(
      context: context,
      builder: (confirmCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Reject Outward Request"),
          content: Text(
            "Are you sure you want to reject outward request for Truck $truckNumber?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(confirmCtx).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(confirmCtx).pop();
                final success = await ref
                    .read(stackStateProvider.notifier)
                    .rejectOutwardRequest(requestId);
                if (success) {
                  onDone();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }
}
