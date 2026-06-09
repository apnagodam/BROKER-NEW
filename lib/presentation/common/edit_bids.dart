import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditBidsScreen extends ConsumerStatefulWidget {
  const EditBidsScreen({
    super.key,
    required this.sbtData,
    required this.sbtSellData,
    required this.productId,
    required this.type,
    required this.commodityId,
    required this.commodityName,
    required this.districtName,
  });
  final BuyerDatum? sbtData;
  final SellerDatum? sbtSellData;
  final String productId;
  final String type;
  final String commodityId;
  final String commodityName;
  final String districtName;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditBidsScreenState();
}

class _EditBidsScreenState extends ConsumerState<EditBidsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? termsText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(bidsStateProvider.notifier)
          .fetchBuySellTerms(widget.productId, widget.type);

      // Cache the terms data after fetching
      final bidsState = ref.read(bidsStateProvider);
      setState(() {
        termsText = bidsState.buySellTerms?['data']
            .toString()
            .replaceAll('<p>', '')
            .replaceAll('</p>', '');
      });

      if (widget.sbtData != null) {
        _quantityController.text = widget.sbtData!.qty.toString();
        _priceController.text = widget.sbtData!.rate.toString();
      } else if (widget.sbtSellData != null) {
        _quantityController.text = widget.sbtSellData!.qty.toString();
        _priceController.text = widget.sbtSellData!.rate.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Form(
            key: _formKey,
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
                        localizations.editBid,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button width
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    localizations.product,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.commodityName} (${widget.districtName})",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(color: Colors.grey),

                SizedBox(height: 10),
                // Price TextField
                Text(
                  localizations.priceQtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),

                // Text(
                //   "Previous Rate: ${widget.sbtData?.rate.toString() ?? "0.0"}₹/Qtl ",
                //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                // ),
                // Text(
                //   "Previous weight: ${widget.sbtData?.qty.toString() ?? "0.0"} Qtl",
                //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.enterPrice,

                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Theme.of(context).primaryColor,
                    ),
                    suffixText: '₹/Qtl',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterPrice;
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return localizations.pleaseEnterValidNumber;
                    }
                    if (price <= 0) {
                      return localizations.priceMustBeGreaterThanZero;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Quantity TextField
                Text(
                  localizations.quantityQtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: localizations.enterQuantity,
                    prefixIcon: Icon(
                      Icons.inventory_2_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    suffixText: localizations.qtl,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
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
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseEnterQuantity;
                    }
                    final quantity = double.tryParse(value);
                    if (quantity == null) {
                      return localizations.pleaseEnterValidNumber;
                    }
                    if (quantity <= 0) {
                      return localizations.quantityMustBeGreaterThanZero;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                SizedBox(height: 10),
                Center(
                  child: Text(
                    localizations.termsAndConditions,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(termsText ?? ''),
                  ),
                ),
                SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Process the order
                        final quantity = _quantityController.text;
                        final price = _priceController.text;

                        try {
                          // Submit the trade and wait for it to complete
                          if (widget.sbtData != null) {
                            await ref
                                .watch(sbtStateProvider.notifier)
                                .editBid(
                                  productId: widget.productId,
                                  districtId: widget.sbtData?.districtId
                                      .toString(),
                                  commodity: widget.commodityId.toString(),
                                  qty: quantity,
                                  type: widget.type,
                                  price: price,
                                  tradeId: widget.sbtData?.tradeId.toString(),
                                  userId: widget.sbtData?.userId.toString(),
                                );
                          } else if (widget.sbtSellData != null) {
                            await ref
                                .watch(sbtStateProvider.notifier)
                                .editBid(
                                  productId: widget.productId,
                                  districtId: widget.sbtSellData?.districtId
                                      .toString(),
                                  commodity: widget.commodityId,
                                  qty: quantity,
                                  type: widget.type,
                                  price: price,
                                  tradeId: widget.sbtSellData?.tradeId
                                      .toString(),
                                  userId: widget.sbtSellData?.userId.toString(),
                                );
                          }

                          await ref
                              .watch(bidsStateProvider.notifier)
                              .fetchTradeList(widget.productId);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  localizations.failedToSubmitBid(e.toString()),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      localizations.submitOrder,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
