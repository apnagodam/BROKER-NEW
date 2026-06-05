import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellBottomsheet extends ConsumerStatefulWidget {
  const SellBottomsheet({
    super.key,
    required this.sbtData,
    this.initialPrice,
    this.initialQuantity,
    this.tradeIdToDelete,
  });
  final SbtProduct sbtData;
  final String? initialPrice;
  final String? initialQuantity;
  final String? tradeIdToDelete;

  @override
  ConsumerState<SellBottomsheet> createState() => _SellBottomsheetState();
}

class _SellBottomsheetState extends ConsumerState<SellBottomsheet> {
  Datum? selectedClient;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  String? termsText;
  List<Datum>? clientsList;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.initialQuantity ?? '',
    );
    _priceController = TextEditingController(text: widget.initialPrice ?? '');

    // Cache the data once during initialization to avoid rebuilds
    final bidsState = ref.read(bidsStateProvider);
    termsText = bidsState.buySellTerms?['data']
        .toString()
        .replaceAll('<p>', '')
        .replaceAll('</p>', '');
    clientsList = bidsState.clientListData?.data ?? [];
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
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
                          localizations.sell,
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
                      "${localizations.product}",
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
                    "${widget.sbtData.commodity}(${widget.sbtData.district})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(color: Colors.grey),

                  SizedBox(height: 10),
                  Text(
                    localizations.selectClient,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Client selection dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Datum>(
                        isExpanded: true,
                        hint: Text(localizations.selectAClient),
                        value: selectedClient,
                        items: (clientsList ?? []).map((client) {
                          return DropdownMenuItem<Datum>(
                            value: client,
                            child: Text(
                              client.name ?? localizations.unknown,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (Datum? newValue) {
                          setState(() {
                            selectedClient = newValue;
                          });
                        },
                      ),
                    ),
                  ),
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
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ),
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
                  SizedBox(height: 10),

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
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ),
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(termsText ?? ''),
                    ),
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(height: 20),

                  // Submit Button
                  Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(sbtStateProvider).isLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Remove focus from text fields
                                    FocusScope.of(context).unfocus();

                                    if (selectedClient == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            localizations.pleaseSelectAClient,
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                      return;
                                    }

                                    final quantity = _quantityController.text;
                                    final price = _priceController.text;

                                    try {
                                      await ref
                                          .read(sbtStateProvider.notifier)
                                          .saveTrade(
                                            productId: widget.sbtData.productId
                                                .toString(),
                                            districtId: widget
                                                .sbtData
                                                .districtId
                                                .toString(),
                                            commodity: widget
                                                .sbtData
                                                .commodityId
                                                .toString(),
                                            qty: quantity,
                                            type: '2',
                                            price: price,
                                            userId: "${selectedClient?.userId}",
                                          );
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.failedToSubmitSellOrder(
                                                e.toString(),
                                              ),
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
                          child: isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  localizations.submitOrder,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
