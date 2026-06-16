import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart' as client;
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ref.watch(stackStateProvider.notifier).fetchStackSellList();
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    // Cache the data once - use ref.read to avoid rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(bidsStateProvider.notifier).fetchClientList();
      clientsList = ref.watch(bidsStateProvider).clientListData?.data ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          localizations.stackSellBidding,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2E7D32),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(  
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Stack Details Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stack Number Header
                        Text(
                          '${localizations.stackNo} - ${ref.watch(stackStateProvider).stackSellData?.data?[widget.index].stackNumber ?? ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Divider Line
                        Container(height: 2, color: Colors.white),
                        SizedBox(height: 16),

                        // Terminal Name
                        Text(
                          localizations.terminalName(
                            ref
                                    .watch(stackStateProvider)
                                    .stackSellData
                                    ?.data?[widget.index]
                                    .warehouseName ??
                                '',
                          ),
                          style: TextStyle(  
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),

                        // Divider
                        Container(height: 1, color: Colors.white),
                        SizedBox(height: 16),

                        // Commodity
                        Text(
                          localizations.commodityLabel(
                            ref
                                    .watch(stackStateProvider)
                                    .stackSellData
                                    ?.data?[widget.index]
                                    .commodityName ??
                                '',
                          ),
                          style: TextStyle(   
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),

                        // Divider
                        Container(height: 1, color: Colors.white),
                        SizedBox(height: 16),

                        // Warehouse Address
                        Text(
                          localizations.warehouseAddress(
                            ref
                                    .watch(stackStateProvider)
                                    .stackSellData
                                    ?.data?[widget.index]
                                    .warehouseAddress ??
                                '',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),

                        // Divider
                        Container(height: 1, color: Colors.white),
                        SizedBox(height: 16),

                        // Quantity and Seller Price Row
                        Row(
                          children: [
                            // Quantity
                            Expanded(
                              child: Text(
                                '${localizations.quantityQtl} : ${ref.watch(stackStateProvider).stackSellData?.data?[widget.index].quantity}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Vertical Divider
                            Container(  
                              width: 2,
                              height: 40,
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                            ),

                            // Seller Price
                            Expanded(
                              child: Text(
                                localizations.sellerPriceLabel(
                                  ref
                                          .watch(stackStateProvider)
                                          .stackSellData
                                          ?.data?[widget.index]
                                          .sellerPrice
                                          ?.toString() ??
                                      '',
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bid Input Section
                Row(
                  children: [ 
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Ensure no client is pre-selected when opening dialog
                              ref
                                  .read(bidsStateProvider.notifier)
                                  .setClient(null);
                              setState(() {});
                              // Wait for dialog to be dismissed, then clear selection
                              await NavigationService.showDialogGlobal(
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(localizations.submitBid),
                                    content: bidSubmitLayout(localizations),
                                  );
                                },
                              );

                              // Clear selected client when dialog is dismissed
                              ref
                                  .read(bidsStateProvider.notifier)
                                  .setClient(null);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              localizations.addBid,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                if (ref.read(bidsStateProvider).isLoadingTradeList) ...[
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 16),
                ] else // Bid History Section
                if (ref
                            .watch(stackStateProvider)
                            .stackSellData
                            ?.data?[widget.index]
                            .stackBuySellConver !=
                        null &&
                    ref
                        .watch(stackStateProvider)
                        .stackSellData!
                        .data![widget.index]
                        .stackBuySellConver!
                        .isNotEmpty)
                  Card( 
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(  
                            localizations.bidHistory,
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          ...ref
                              .watch(stackStateProvider)
                              .stackSellData!
                              .data![widget.index]
                              .stackBuySellConver!
                              .map((bid) {
                                // Check if this bid belongs to the current user
                                final currentUserId = SharedPreferencesService
                                    .userDetails
                                    ?.userId;
                                final isMyBid =
                                    currentUserId != null &&
                                    bid.userId.toString() ==
                                        currentUserId.toString();
                                final isMyName =
                                    bid.userName != null &&
                                    bid.userName ==
                                        SharedPreferencesService
                                            .userDetails
                                            ?.name;
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(  
                                      color: isMyBid
                                          ? Colors.amber.shade900
                                          : Colors.grey.shade300,
                                      width: isMyBid ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [  
                                      Padding(
                                        padding: EdgeInsetsGeometry.all(10),
                                        child: Column(  
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [ 
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${localizations.price}: ₹${bid.price}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                            0xFF2E7D32,
                                                          ),
                                                        ),
                                                      ),
                                                      if (isMyBid) ...[
                                                        SizedBox(width: 8),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                              0xFF2E7D32,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            localizations
                                                                .yourBid,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                if (bid.status != null)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: bid.status == 1
                                                          ? Colors
                                                                .green
                                                                .shade100
                                                          : Colors
                                                                .grey
                                                                .shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      bid.status == 1
                                                          ? localizations.active
                                                          : localizations
                                                                .inactive,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: bid.status == 1
                                                            ? Colors
                                                                  .green
                                                                  .shade800
                                                            : Colors
                                                                  .grey
                                                                  .shade700,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            if (bid.createdAt != null) ...[
                                              SizedBox(height: 4),
                                              Text(    
                                                '${localizations.date}: ${bid.createdAt}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],

                                            SizedBox(height: 4),
                                            Text(  
                                              !isMyBid
                                                  ? "${localizations.buyer} ${ref.watch(stackStateProvider).stackSellData!.data![widget.index].stackBuySellConver!.indexOf(bid) + 1}"
                                                  : '${localizations.unknown}: ${isMyName ? "${localizations.buyer} ${ref.watch(stackStateProvider).stackSellData!.data![widget.index].stackBuySellConver!.indexOf(bid) + 1} " : bid.userName ?? '${localizations.unknown} ${ref.watch(stackStateProvider).stackSellData!.data![widget.index].stackBuySellConver!.indexOf(bid) + 1}'}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isMyBid)
                                        Container(  
                                          width: double.infinity,
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                            color: Colors.amber.shade900,
                                          ),
                                          child: Text(
                                            localizations.myBid,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              })
                              ,
                        ],
                      ),
                    ),
                  ),

                if (ref 
                            .watch(stackStateProvider)
                            .stackSellData
                            ?.data?[widget.index]
                            .stackBuySellConver !=
                        null &&
                    ref
                        .watch(stackStateProvider)
                        .stackSellData!
                        .data![widget.index]
                        .stackBuySellConver!
                        .isNotEmpty)
                  SizedBox(height: 16),

                // Add Bid Button
              ],
            ),
          ),
        ),
        onRefresh: () {  
          return ref.watch(stackStateProvider.notifier).fetchStackSellList();
        },
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
}
