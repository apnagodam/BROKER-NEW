import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/core/utils/string_constants.dart';
import 'package:ag_broker/domain/entities/matched_orders_model.dart';
import 'package:ag_broker/domain/entities/quality_params_model.dart';
import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/common/auth_providers.dart';
import 'package:ag_broker/presentation/common/buy_bottomsheet.dart';
import 'package:ag_broker/presentation/common/sell_bottomsheet.dart';
import 'package:ag_broker/presentation/common/widgets/audio_widget.dart';
import 'package:ag_broker/presentation/features/bids/buyer_list.dart';
import 'package:ag_broker/presentation/features/bids/seller_list.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/capability_profile.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/enums.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/generator.dart';
// import 'package:thermal_printer/esc_pos_utils_platform/src/pos_styles.dart';

import '../../../domain/entities/stack_sell_list_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';
import 'package:maps_launcher/maps_launcher.dart';
// import 'package:thermal_printer/thermal_printer.dart';
import 'dart:async';
// import 'package:ag_broker/core/utils/printer_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {   
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Trigger initial data fetch only once after first frame
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Use PrinterHelper for discovery/connection when needed.
        // Do not auto-start discovery here; let the user initiate scanning.

        ref.read(sbtStateProvider.notifier).fetchSbtProducts();
        ref.read(stackStateProvider.notifier).fetchStackSellList();
        ref.read(authStateProvider.notifier).getUserDetails();
      });
    }
  }

  @override
  void dispose() {
    // stop any ongoing discovery and disconnect via PrinterHelper
    // PrinterHelper.instance.stopDiscovery();
    // try {
    //   if (PrinterHelper.instance.isConnected) {
    //     PrinterHelper.instance.disconnect();
    //   }
    // } catch (e) {
    //   debugPrint('Error disconnecting printer: $e');
    // }

    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final localizations = AppLocalizations.of(context)!;
        final sbtProduct = ref.watch(sbtStateProvider);
        final stackSellList = ref.watch(stackStateProvider);
        return Scaffold(
          floatingActionButton: AudioWidget(),
          appBar: AppBar(
            title: Text(
              "${localizations.appTitle}, ${SharedPreferencesService.userDetails?.name}",
            ),
            // actions: [
            //   IconButton(
            //     tooltip: 'Select Printer',
            //     icon: Icon(Icons.print),
            //     onPressed: () => _showPrinterSelection(context),
            //   ),
            // ],
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            bottom: TabBar( 
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.local_shipping),
                  text: localizations.delivery,
                ),
                Tab(
                  icon: Icon(Icons.fire_truck),
                  text: localizations.truckLoad,
                ),
              ],
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
            ),
          ),
          drawer: _buildDrawer(context, ref, localizations),
          body: TabBarView(
            controller: _tabController,
            children: [  
              // Delivery Tab
              RefreshIndicator(
                child: ref.watch(sbtStateProvider).isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        children: (sbtProduct.sbtProductData?.data ?? [])
                            .map((e) => _buildSbtCard(e, localizations))
                            .toList(),
                      ),
                onRefresh: () {
                  return ref.read(sbtStateProvider.notifier).fetchSbtProducts();
                },
              ),
              // Truck Load Tab
              RefreshIndicator(
                child: ref.watch(stackStateProvider).isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(  
                        itemCount:
                            (stackSellList.stackSellData?.data ?? []).length,
                        itemBuilder: (context, index) => _buildDeliveryCard(
                          (stackSellList.stackSellData?.data ?? [])[index],
                          localizations,
                          index,
                        ),
                        separatorBuilder: (context, index) =>
                            Divider(height: 8, thickness: 1),
                      ),
                onRefresh: () {
                  return ref
                      .read(stackStateProvider.notifier)
                      .fetchStackSellList();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showPrinterSelection(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         title: Text('Select Printer'),
  //         content: StreamBuilder<List<dynamic>>(
  //           stream: PrinterHelper.instance.devicesStream,
  //           initialData: PrinterHelper.instance.devices,
  //           builder: (context, snapshot) {
  //             final list = snapshot.data ?? [];
  //             if (list.isEmpty) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.search_off, color: Colors.grey),
  //                     SizedBox(width: 8),
  //                     Expanded(
  //                       child: Text(
  //                         'No printers found.',
  //                         style: TextStyle(color: Colors.grey[700]),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }

  //             return ConstrainedBox(
  //               constraints: BoxConstraints(maxHeight: 320),
  //               child: ListView.separated(
  //                 shrinkWrap: true,
  //                 itemCount: list.length,
  //                 separatorBuilder: (c, i) => Divider(height: 1),
  //                 itemBuilder: (context, index) {
  //                   final d = list[index];
  //                   final isConnected =
  //                       PrinterHelper.instance.isConnected &&
  //                       (PrinterHelper.instance.connectedName ==
  //                           (d.name ?? d.address));

  //                   return Container(
  //                     margin: const EdgeInsets.symmetric(
  //                       horizontal: 4,
  //                       vertical: 6,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(8),
  //                       border: Border.all(
  //                         color: Theme.of(
  //                           context,
  //                         ).dividerColor.withOpacity(0.6),
  //                       ),
  //                     ),
  //                     child: ListTile(
  //                       contentPadding: EdgeInsets.symmetric(
  //                         horizontal: 12,
  //                         vertical: 8,
  //                       ),
  //                       leading: CircleAvatar(
  //                         backgroundColor: Theme.of(
  //                           context,
  //                         ).primaryColor.withOpacity(0.1),
  //                         child: Icon(
  //                           Icons.print,
  //                           color: Theme.of(context).primaryColor,
  //                         ),
  //                       ),
  //                       title: Text(
  //                         d.name ?? d.address ?? 'Unknown',
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                       ),
  //                       subtitle: Text(d.address ?? ''),
  //                       trailing: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           if (isConnected)
  //                             Container(
  //                               margin: EdgeInsets.only(right: 8),
  //                               child: Chip(
  //                                 label: Text(
  //                                   'Connected',
  //                                   style: TextStyle(color: Colors.white),
  //                                 ),
  //                                 backgroundColor: Colors.green.shade700,
  //                               ),
  //                             ),
  //                           TextButton(
  //                             onPressed: () async {
  //                               if (isConnected) {
  //                                 await PrinterHelper.instance.disconnect();
  //                               } else {
  //                                 final ok = await PrinterHelper.instance
  //                                     .connect(d, isBle: false);
  //                                 if (ok) {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(
  //                                       content: Text(
  //                                         'Connected to ${d.name ?? d.address}',
  //                                       ),
  //                                     ),
  //                                   );
  //                                 } else {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(
  //                                       content: Text('Failed to connect'),
  //                                     ),
  //                                   );
  //                                 }
  //                               }
  //                               setState(() {});
  //                             },
  //                             child: Text(
  //                               isConnected ? 'Disconnect' : 'Connect',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       onTap: () async {
  //                         // quick tap toggles connect/disconnect
  //                         if (isConnected) {
  //                           await PrinterHelper.instance.disconnect();
  //                         } else {
  //                           final ok = await PrinterHelper.instance.connect(
  //                             d,
  //                             isBle: false,
  //                           );
  //                           if (ok) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: Text(
  //                                   'Connected to ${d.name ?? d.address}',
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                         }
  //                         setState(() {});
  //                       },
  //                     ),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               final ok = await PrinterHelper.instance
  //                   .printTestTicketWithPaper(
  //                     type: PrinterType.bluetooth,
  //                     paperSize: PaperSize.mm58,
  //                   );
  //               if (ok) {
  //                 ScaffoldMessenger.of(
  //                   context,
  //                 ).showSnackBar(SnackBar(content: Text('Print job sent')));
  //               } else {
  //                 ScaffoldMessenger.of(
  //                   context,
  //                 ).showSnackBar(SnackBar(content: Text('Print failed')));
  //               }
  //             },
  //             child: Text('Print'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await PrinterHelper.instance.startDiscovery(isBle: false);
  //               setState(() {});
  //             },
  //             child: Text('Scan'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await PrinterHelper.instance.stopDiscovery();
  //               Navigator.of(ctx).pop();
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildDeliveryCard(
    Datum data,
    AppLocalizations localizations,
    int index,
  ) => Card(  
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(8),
      side: BorderSide(color: Colors.amber.shade900),
    ),
    margin: EdgeInsets.all(10),
    child: InkWell(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(  
                      kDebugMode
                          ? Constants.testApiBaseUrl +
                                data.commodityPath +
                                data.commodityImage
                          : (Constants.apiBaseUrl +
                                data.commodityPath +
                                data.commodityImage),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(  
                              TextSpan(
                                text: "${data.commodityName}  ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: localizations.tapToPunchOrder,

                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${localizations.stackNo} ${data.stackNumber}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text.rich(TextSpan(text: "${data.warehouseName}")),
                    SizedBox(height: 10),
                    HtmlWidget('''
  ${data.bidTime}
  '''),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsetsGeometry.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${localizations.bestBuyer} \n${data.bestBuyerPrice ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     '${localizations.myPrice} \n0',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Text(
                    '${localizations.sellerPrice} \n${data.sellerPrice}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        GoRouter.of(context).push('/stack-details', extra: index);
      },
    ),
  );

  Widget _buildSbtCard(SbtProduct data, AppLocalizations localizations) => Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: Colors.amber.shade900, width: 2),
    ),
    margin: EdgeInsets.all(10),
    surfaceTintColor: Colors.white,
    child: Padding(   
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title with district
          Text.rich(   
            TextSpan(  
              text: "${data.commodity} ",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.amber.shade900,
              ),
              children: [],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text.rich(
            TextSpan(  
              text: "${data.district}",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 12),

          // Buyer/Seller best prices
          Row(  
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceRow(
                label: localizations.bestBuyer,
                value: '${data.bestBuyer}',
              ),
              _buildPriceRow(  
                label: localizations.bestSeller,
                value: data.bestSeller.toString(),
              ),
            ],
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bid Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data.date ?? ''),
            ],
          ),
          SizedBox(height: 10),

          // Tap for details + Icon and Label
          Row(  
            mainAxisAlignment: MainAxisAlignment.center,
            children: [    
              // Icon(  
              //   data.data?[mainIndex]
              //               .sbtType
              //               .toString() ==
              //           "2"
              //       ? Icons.factory
              //       : data.data?[mainIndex]
              //                   .sbtType
              //                   .toString() ==
              //               "1"
              //           ? Icons.warehouse
              //           : Icons.store,
              //   size: 30,
              //   color: data
              //               .data?[
              //                   mainIndex]
              //               .sbtType
              //               .toString() ==
              //           "2"
              //       ? Colors
              //           .amber.shade900
              //       : data
              //                   .data?[
              //                       mainIndex]
              //                   .sbtType
              //                   .toString() ==
              //               "1"
              //           ? ColorConstant
              //               .maingreen
              //           : ColorConstant
              //               .red500,
              // ),
              SizedBox(width: 8),
              // Text(  
              //   data.data?[mainIndex]
              //               .sbtType
              //               .toString() ==
              //           "2"
              //       ? "Outside Warehouse"
              //           .tr
              //       : data
              //                   .data?[
              //                       mainIndex]
              //                   .sbtType
              //                   .toString() ==
              //               "1"
              //           ? 'Warehouse'.tr
              //           : "Outside Warehouse"
              //               .tr,
              //   style: TextStyle(
              //     fontWeight:
              //         FontWeight.bold,
              //     fontSize:
              //         Adaptive.sp(17),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 10),

          SizedBox(    
            width: double.infinity,
            child: ElevatedButton(   
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(   
                localizations.order,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                showModalBottomSheet(  
                  context: context,
                  isDismissible: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  useSafeArea: true,

                  backgroundColor: Colors.white,
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref
                          .read(bidsStateProvider.notifier)
                          .fetchTradeList("${data.productId}");

                      ref
                          .read(bidsStateProvider.notifier)
                          .fetchQualityParams("${data.productId}");
                      ref
                          .read(sbtStateProvider.notifier)
                          .getDeliveryCenters(data.productId.toString());
                      ref
                          .read(sbtStateProvider.notifier)
                          .getMatchedOrders(data.productId.toString());
                    });
                    return Consumer(
                      builder: (context, ref, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).viewInsets.top,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: _orderBottomSheet(
                            data,
                            localizations,
                            ref.watch(bidsStateProvider).qualityParamsData,
                            matchedOrders: ref
                                .watch(sbtStateProvider)
                                .matchedOrdersData,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );

  Widget _orderBottomSheet(
    SbtProduct data,
    AppLocalizations localizations,
    QualityParamsModel? qualityParamsModel, {   
    SbtMatchedOrderResponse? matchedOrders,
  }) => Consumer(
    builder: ((context, ref, child) => Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with back button
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  tooltip: localizations.close,
                ),
                Expanded(
                  child: Text(
                    "${data.commodity}- ${data.district}",
                    textAlign: TextAlign.center,
                    style: TextStyle(  
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 48), // Balance the back button width
              ],
            ),
            Divider(),
            Card(
              color: Colors.grey.shade200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${localizations.bestBuyer}: ${data.bestBuyer}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${localizations.bestSeller}: ${data.bestSeller}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(bidsStateProvider.notifier)
                          .fetchBuySellTerms("${data.productId}", "2");
                      await ref
                          .read(bidsStateProvider.notifier)
                          .fetchClientList();
                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => BuyBottomsheet(sbtData: data),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(localizations.buy),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(bidsStateProvider.notifier)
                          .fetchBuySellTerms("${data.productId}", "2");
                      await ref
                          .read(bidsStateProvider.notifier)
                          .fetchClientList();

                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SellBottomsheet(sbtData: data),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(localizations.sell),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                localizations.buyer,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            Container( 
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: ref.watch(bidsStateProvider).isLoadingTradeList
                  ? Center(child: CircularProgressIndicator())
                  : (ref.watch(bidsStateProvider).tradeListData?.buyerData ??
                            [])
                        .isEmpty
                  ? Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Center(child: Text(localizations.noBids)),
                    )
                  : ListView.separated(
                      itemCount: ref
                          .watch(bidsStateProvider)
                          .tradeListData!
                          .buyerData!
                          .length,
                      itemBuilder: (context, index) => BuyerList(
                        data: ref
                            .watch(bidsStateProvider)
                            .tradeListData!
                            .buyerData![index],
                        index: index,
                        productId: "${data.productId}",
                        commodityId: "${data.commodityId}",
                        commodityName: data.commodity,
                        districtName: data.district,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                localizations.seller,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
            ),
            Container(  
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: ref.watch(bidsStateProvider).isLoadingTradeList
                  ? Center(child: CircularProgressIndicator())
                  : (ref.watch(bidsStateProvider).tradeListData?.sellerData ??
                            [])
                        .isEmpty
                  ? Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Center(child: Text(localizations.noBids)),
                    )
                  : ListView.separated(
                      itemCount: ref
                          .watch(bidsStateProvider)
                          .tradeListData!
                          .sellerData!
                          .length,
                      itemBuilder: (context, index) => SellerList(
                        data: ref
                            .watch(bidsStateProvider)
                            .tradeListData!
                            .sellerData![index],
                        index: index,
                        productId: "${data.productId}",
                        commodityId: "${data.commodityId}",
                        commodityName: data.commodity,
                        districtName: data.district,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
            ),

            _matchedOrdersLayout(localizations, "${data.productId}"),
            SizedBox(height: 10),
            Text(
              localizations.qualityParameters,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            _qualityParamsLayout(localizations, qualityParamsModel),
            SizedBox(height: 10),
            Text(
              localizations.deliveryCenters,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            _deliveryCentersLayout(localizations, data.productId.toString()),
          ],
        ),
      ),
    )),
  );
  Widget _qualityParamsLayout(
    AppLocalizations localizations,
    QualityParamsModel? qualityParamsModel,
  ) {
    if (ref.watch(bidsStateProvider).isLoadingQualityParams) {
      return Center(child: CircularProgressIndicator());
    }
    if (ref.watch(bidsStateProvider).qualityParamsData?.data == null ||
        (ref.watch(bidsStateProvider).qualityParamsData?.data ?? []).isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.noQualityParametersAvailable,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                columnSpacing: 20,
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                dataTextStyle: TextStyle(fontSize: 15, color: Colors.black87),
                columns: [
                  DataColumn(
                    label: Expanded(
                      child: Text(  
                        localizations.parameter,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  DataColumn(label: Text(localizations.min), numeric: true),
                  DataColumn(label: Text(localizations.max), numeric: true),
                ],
                rows: ref
                    .watch(bidsStateProvider)
                    .qualityParamsData!
                    .data!
                    .map(
                      (param) => DataRow(
                        cells: [
                          DataCell(Text(param.parameters?.parameter ?? 'N/A')),
                          DataCell(Text(param.min?.toString() ?? '-')),
                          DataCell(Text(param.max?.toString() ?? '-')),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRow({required String label, required String value}) {
    return Column(
      children: [
        Text(label),
        SizedBox(width: 6),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _deliveryCentersLayout(
    AppLocalizations localizations,
    String productId,
  ) {
    if (ref.watch(sbtStateProvider).isDeliveryLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (ref.watch(sbtStateProvider).deliveryCentersData?.data == null ||
        ref.watch(sbtStateProvider).deliveryCentersData!.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.noDataAvailable,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: ref.watch(sbtStateProvider).deliveryCentersData!.data!.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final center = ref
            .watch(sbtStateProvider)
            .deliveryCentersData!
            .data![index];
        return Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warehouse Name and Locate Button
                Row(
                  children: [
                    Icon(
                      Icons.warehouse,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Expanded( 
                      child: Text(
                        center.warehouseName ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    if (center.warehouseAddress != null &&
                        center.warehouseAddress!.isNotEmpty)
                      InkWell(  
                        onTap: () {
                          MapsLauncher.launchQuery(center.warehouseAddress!);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_searching,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(  
                              localizations.locate,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                decorationColor: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),

                // Image and Video Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (center.image != null && center.image!.isNotEmpty)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showImageDialog(
                              context,
                              center.path,
                              center.image,
                            );
                          },
                          icon: Icon(Icons.image, size: 20),
                          label: Text(localizations.viewImage),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (center.image != null &&
                        center.image!.isNotEmpty &&
                        center.video != null &&
                        center.video.toString().isNotEmpty)
                      SizedBox(width: 12),
                    if (center.video != null &&
                        center.video.toString().isNotEmpty)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showVideoDialog(
                              context,
                              center.path,
                              center.video,
                            );
                          },
                          icon: Icon(Icons.video_library, size: 20),
                          label: Text(localizations.viewVideo),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if ((center.image != null && center.image!.isNotEmpty) ||
                    (center.video != null &&
                        center.video.toString().isNotEmpty))
                  SizedBox(height: 12),

                // Address
                if (center.warehouseAddress != null &&
                    center.warehouseAddress!.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          center.warehouseAddress!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 12),

                // Charges Header
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.charges,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Content (HTML with charges details)
                if (center.content != null && center.content!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: HtmlWidget(
                      center.content!,
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _matchedOrdersLayout(
    AppLocalizations localizations,
    String productId,
  ) {
    // Fetch matched orders only if not already loaded for this product
    var matchedOrders = ref.watch(sbtStateProvider).matchedOrdersData;
    if (matchedOrders?.tradeOrderData == null ||
        matchedOrders!.tradeOrderData!.isEmpty) {
      return Column(
        children: [ 
          SizedBox(height: 10),
          Text(
            localizations.matchedOrders,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                localizations.noMatchedOrders,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [  
        SizedBox(height: 10),
        Text(
          localizations.matchedOrders,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 10),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: matchedOrders.tradeOrderData!.length,
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final order = matchedOrders.tradeOrderData![index];
            final userFirm = SharedPreferencesService.userDetails?.name ?? '';
            return Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deal Type Header
                    Center(
                      child: Text(
                        userFirm.toLowerCase() == order.buyer?.toLowerCase()
                            ? '${localizations.buy} Deal'
                            : userFirm.toLowerCase() ==
                                  order.seller?.toLowerCase()
                            ? '${localizations.sell} Deal'
                            : 'Deal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              userFirm.toLowerCase() ==
                                  order.buyer?.toLowerCase()
                              ? Theme.of(context).primaryColor
                              : Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 12),

                    // Order ID
                    Text(
                      '${localizations.orderId}: ${order.orderId ?? 'N/A'}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Date and Expiry Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${localizations.date}: ${order.date ?? 'N/A'}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${localizations.expiryDate}: ${order.expiryDate ?? 'N/A'}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 12),

                    // Commodity and District
                    Text.rich(
                      TextSpan(
                        text: '${order.commodity ?? 'N/A'}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: ' - ${order.district ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 12),

                    // Rate and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              localizations.rate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '₹${order.rate?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              localizations.quantity,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${order.qty ?? '0'} ${localizations.qtl}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 12),

                    // Pending Quantity
                    Text(
                      '${localizations.pendingQuantity}: ${order.pendingQty.toStringAsFixed(0)} ${localizations.qtl}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    final userDetails = SharedPreferencesService.userDetails;
    final phoneNumber = SharedPreferencesService.phoneNumber;
    final power =
        ref.watch(authStateProvider).userDetails?.userDetails?.power ?? '0.0';
    final primary = Theme.of(context).primaryColor;

    final int memberType =
        int.tryParse(
          ref
                  .watch(authStateProvider)
                  .userDetails
                  ?.userDetails
                  ?.memberType
                  ?.toString() ??
              '1',
        ) ??
        1;

    return Drawer(
      child: Column(
        children: [
          // ── Profile Header ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: primary,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  child: Icon(Icons.person, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userDetails?.name ?? localizations.appTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phoneNumber != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '+91 $phoneNumber',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Power ${StringConstants.rupeeSymbol} $power',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Menu Items ─────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 6, bottom: 8),
              children: [
                // ── Dashboard / Home ──────────────────────────────────────────
                _drawerTile(  
                  context,  
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  iconColor: primary,
                  onTap: () => Navigator.of(context).pop(),
                ),

                const SizedBox(height: 2),

                // ── PROFILE ───────────────────────────────────────────────────
                _drawerExpandable(  
                  context,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  iconColor: primary,
                  children: [
                    _drawerSubTile( 
                      context,
                      label: localizations.profile,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/profile');
                      },
                    ),
                    _drawerSubTile(  
                      context,
                      label: localizations.brokerageProfile,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/brokerage-profile');
                      },
                    ),
                  ],
                ),

                // ── HISTORY ───────────────────────────────────────────────────
                _drawerTile(  
                  context,
                  icon: Icons.history_outlined,
                  label: localizations.bidsHistory,
                  iconColor: Colors.indigo.shade700,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/home/bids-history');
                  },
                ),

                const SizedBox(height: 2),

                // ── MEMBERS ───────────────────────────────────────────────────
                _drawerExpandable(
                  context,
                  icon: Icons.people_outline,
                  label: 'Members',
                  iconColor: primary,
                  children: [
                    // Client List — all roles
                    _drawerSubTile(  
                      context,
                      label: localizations.lpClientList,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/lp-clients');
                      },
                    ),

                    // Authorised Person — TM (2) and STCM (3)
                    if (memberType == 2 || memberType == 3)
                      _drawerSubTile(  
                        context,
                        label: 'Authorised Person',
                        onTap: () {  
                          Navigator.of(context).pop();
                          context.go('/home/authorised-person');
                        },
                      ),

                    // Trading Member — STCM (3) only
                    if (memberType == 3)
                      _drawerSubTile(  
                        context,
                        label: 'Trading Member',
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/home/trading-member');
                        },
                      ),

                    // Add Security — TM (2) only
                    if (memberType == 2)
                      _drawerSubTile(   
                        context,
                        label: 'Add Security',
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/home/add-security');
                        },
                      ),

                    // TM Fees — TM (2) only
                    if (memberType == 2)
                      _drawerSubTile(   
                        context,
                        label: 'TM Fees',
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go('/home/tm-fees');
                        },
                      ),
                  ],
                ),

                // ── MARGIN FUNDING — STCM (3) only ───────────────────────────
                if (memberType == 3)
                  _drawerExpandable(  
                    context,
                    icon: Icons.percent_outlined,
                    label: 'Margin Funding',
                    iconColor: Colors.green.shade700,
                    children: [
                      _drawerSubTile(
                        context,
                        label: 'Schemes',
                        onTap: () {   
                          Navigator.of(context).pop();
                          context.go('/home/margin-funding-schemes');
                        },
                      ),
                      _drawerSubTile( 
                        context,
                        label: 'Margin Funding Limit',
                        onTap: () { 
                          Navigator.of(context).pop();
                          context.go('/home/margin-funding-limit');
                        },
                      ),
                      _drawerSubTile(     
                        context, 
                        label: 'Margin Funding Request',
                        onTap: () {    
                          Navigator.of(context).pop();
                          context.go('/home/margin-funding-request');
                        },
                      ),
                    ],
                  ),

                // ── WALLET ────────────────────────────────────────────────────
                _drawerExpandable(   
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Wallet',
                  iconColor: Colors.orange.shade800,
                  children: [
                    // Brokerage Wallet Statement — all roles
                    _drawerSubTile(  
                      context,
                      label: localizations.walletStatement,
                      onTap: () {   
                        Navigator.of(context).pop();
                        context.go('/home/wallet-statement');
                      },
                    ),

                    // Trade Power Statement — TM (2) and STCM (3) only
                    if (memberType == 2 || memberType == 3)
                      _drawerSubTile(  
                        context,
                        label: 'Trade Power Statement',
                        onTap: () { 
                          Navigator.of(context).pop();
                          context.go('/home/trade-power-statement');
                        },
                      ),

                    // Withdrawal Request — all roles
                    _drawerSubTile(  
                      context,    
                      label: localizations.withdrawalRequest,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/withdrawal-request');
                      },
                    ),
                  ],
                ),

                // ── SBT PRODUCTS (all roles) ──────────────────────────────────
                _drawerExpandable(  
                  context,
                  icon: Icons.verified_outlined,
                  label: 'SBT Product',
                  iconColor: Colors.green.shade800,
                  children: [
                    _drawerSubTile(  
                      context,
                      label: 'SBT Secure Product',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/sbt-secure-product');
                      },
                    ),
                    _drawerSubTile(
                      context,
                      label: 'SBT Unsecure Product',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go('/home/sbt-unsecure-product');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // ── SETTINGS ──────────────────────────────────────────────────
                _drawerTile(
                  context,
                  icon: Icons.language_outlined,
                  label: localizations.changeLanguage,
                  iconColor: Colors.blueGrey.shade700,
                  subtitle: ref.watch(localeProvider).languageCode == 'en'
                      ? localizations.english
                      : localizations.hindi,
                  onTap: () {
                    Navigator.of(context).pop();
                    _showLanguageDialog(context, ref, localizations);
                  },
                ),
              ],
            ),
          ),

          // ── Logout ────────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                ),
                title: Text(
                  localizations.logout,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {  
                  Navigator.of(context).pop();
                  await ref.read(authStateProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper: expandable group tile ────────────────────────────────────────────
  Widget _drawerExpandable(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Theme(   
      // Remove the default ExpansionTile dividers
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        childrenPadding: EdgeInsets.zero,
        dense: true,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        iconColor: Colors.grey.shade600,
        collapsedIconColor: Colors.grey.shade400,
        children: children,
      ),
    );
  }

  // ── Helper: sub-tile inside an expandable ────────────────────────────────────
  Widget _drawerSubTile(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final primary = Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: 64,
          right: 16,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          children: [
            Container(  
              width: 6, 
              height: 6,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(  
                fontSize: 13,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: group label ───────────────────────────────────────────────────
  // Widget _drawerGroupLabel(String label) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16, top: 8, bottom: 2, right: 16),
  //     child: Row(
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 10,
  //             fontWeight: FontWeight.w700,
  //             color: Colors.grey.shade500,
  //             letterSpacing: 1.2,
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(child: Divider(height: 1, color: Colors.grey.shade300)),
  //       ],
  //     ),
  //   );
  // }

  // ── Helper: tile ──────────────────────────────────────────────────────────
  Widget _drawerTile( 
    BuildContext context, {  
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      leading: Container(      
        width: 36,
        height: 36,
        decoration: BoxDecoration(  
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(   
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(   
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            )
          : null,
      trailing: Icon( 
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(  
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    showDialog(    
      context: context,
      builder: (BuildContext context) {  
        return AlertDialog(    
          title: Text(localizations.selectLanguage),
          content: Column(  
            mainAxisSize: MainAxisSize.min,
            children: [  
              ListTile( 
                leading: Icon(Icons.language),
                title: Text(localizations.english),
                onTap: () async { 
                  await ref  
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en'));

                  await ref.watch(sbtStateProvider.notifier).fetchSbtProducts();
                  await ref
                      .watch(stackStateProvider.notifier)
                      .fetchStackSellList();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(  
                leading: Icon(Icons.language),
                title: Text(localizations.hindi),
                onTap: () async {
                  await ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('hi'));

                  await ref.read(sbtStateProvider.notifier).fetchSbtProducts();
                  await ref
                      .read(stackStateProvider.notifier)
                      .fetchStackSellList();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context, String? path, String? image) {
    if (image == null || image.isEmpty) return;

    final localizations = AppLocalizations.of(context)!;
    final imageUrl = path != null && path.isNotEmpty ? '$path$image' : image;

    showDialog(   
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [  
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Image
              Expanded(
                child: InteractiveViewer(
                  child: Image.network( 
                    "${DioClient.baseUrl}$imageUrl",
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(  
                        child: Column(   
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 50),
                            SizedBox(height: 10),
                            Text(
                              localizations.failedToLoadImage,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoDialog(BuildContext context, String? path, dynamic video) {
    if (video == null || video.toString().isEmpty) return;

    final videoUrl = path != null && path.isNotEmpty
        ? '${Constants.testApiBaseUrl}$path${video.toString()}'
        : video.toString();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _VideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }
}

class _VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerScreen({required this.videoUrl});

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {   
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {  
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();

      setState(() {  
        _isInitialized  = true;
      });

      _controller.play();
    } catch (e) {   
      setState(() {   
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {   
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      backgroundColor: Colors.black,
      appBar: AppBar( 
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.videoPlayer,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(    
        child: _hasError   
            ? Column(           
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  Icon(Icons.error, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(   
                    AppLocalizations.of(context)!.errorOccurred,
                    style: TextStyle(   
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(      
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(     
                      _errorMessage ?? AppLocalizations.of(context)!.unknown,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(    
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.goBack),
                  ),
                ],
              )
            : !_isInitialized
            ? CircularProgressIndicator(color: Colors.white)
            : Column(   
                mainAxisAlignment: MainAxisAlignment.center,
                children: [  
                  Expanded(     
                    child: AspectRatio( 
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  SizedBox(height: 20),
                  VideoProgressIndicator(      
                    _controller,  
                    allowScrubbing: true,
                    colors: VideoProgressColors(      
                      playedColor: Theme.of(context).primaryColor,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(   
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      IconButton( 
                        icon: Icon(    
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 64,
                          color: Colors.white,
                        ),
                        onPressed: () {  
                          setState(() {    
                            if (_controller.value.isPlaying) {  
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ValueListenableBuilder(       

                    valueListenable: _controller,
                    builder: (context, VideoPlayerValue value, child) {   
                      final position = value.position;  
                      final duration = value.duration;
                      return Text(
                        '${_formatDuration(position)} / ${_formatDuration(duration)}',
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  String _formatDuration(Duration duration) {      
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
 
    if (hours > 0) {    
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
