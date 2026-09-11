import 'package:ag_broker/domain/entities/client_list_model.dart' as client;
import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/core/utils/product_helper.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SubmitBidScreen extends ConsumerStatefulWidget {
  final int index;

  const SubmitBidScreen({super.key, required this.index});

  @override
  ConsumerState<SubmitBidScreen> createState() => _SubmitBidScreenState();
}

class _SubmitBidScreenState extends ConsumerState<SubmitBidScreen> {
  final TextEditingController _bidAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(bidsStateProvider.notifier).setClient(null);
      if (ref.read(stackStateProvider).stackSellTerms == null) {
        ref.read(stackStateProvider.notifier).fetchStackSellTerms();
      }
      await ref.read(bidsStateProvider.notifier).fetchClientList();
    });
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    final localizations = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedClient = ref.read(bidsStateProvider).selectedClient;
    if (selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.selectAClient),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final stackData =
        ref.read(stackStateProvider).stackSellData?.data?[widget.index];
    if (stackData == null) return;

    setState(() => _isSubmitting = true);
    try {
      final success = await ref.read(stackStateProvider.notifier).postStackBid(
            stackId: "${stackData.id ?? ''}",
            price: _bidAmountController.text.trim(),
            userId: "${selectedClient.userId ?? ''}",
          );

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final stackState = ref.watch(stackStateProvider);
    final stackData = stackState.stackSellData?.data?[widget.index];
    final bool isFactory = ProductHelper.isFactoryDelivery(
      null,
      "${stackData?.warehouseName ?? ''} ${stackData?.warehouseAddress ?? ''}",
    );
    final Color themeColor = ProductHelper.deliveryBorderColor(isFactory);
    final clients = ref.watch(bidsStateProvider).clientListData?.data ?? [];
    final selectedClient = ref.watch(bidsStateProvider).selectedClient;

    final dropdownValue = (selectedClient != null &&
            clients.any((c) => c.userId == selectedClient.userId))
        ? clients.firstWhere((c) => c.userId == selectedClient.userId)
        : null;

    final termsContent = stackState.stackSellTerms?['data'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.submitBid,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Stack Summary Card ──────────────────────────────────────────
            if (stackData != null)
              _buildStackSummaryCard(stackData, localizations, themeColor, isFactory),
            const SizedBox(height: 14),

            // ── Bid Input & Client Selection Card ───────────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bid Amount Header
                      Text(
                        localizations.enterYourBidAmount,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Bid Amount Input Field
                      TextFormField(
                        controller: _bidAmountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: localizations.enterBidAmountHint,
                          prefixIcon: const Icon(
                            Icons.currency_rupee,
                            color: Color(0xFF2E7D32),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF2E7D32)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF2E7D32),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.pleaseEnterBidAmount;
                          }
                          final amount = double.tryParse(value.trim());
                          if (amount == null) {
                            return localizations.pleaseEnterValidNumber;
                          }
                          if (amount <= 0) {
                            return localizations
                                .bidAmountMustBeGreaterThanZero;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Client Selection Dropdown
                      Text(
                        localizations.selectAClient,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<client.Datum?>(
                            isExpanded: true,
                            hint: Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  localizations.selectAClient,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            value: dropdownValue,
                            items: [
                              DropdownMenuItem<client.Datum?>(
                                value: null,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      localizations.selectAClient,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...clients.map((clientItem) {
                                return DropdownMenuItem<client.Datum?>(
                                  value: clientItem,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Color(0xFF2E7D32),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          clientItem.name ??
                                              localizations.unknown,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (clientItem.phone != null &&
                                          clientItem.phone
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          "(${clientItem.phone})",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            onChanged: (client.Datum? newValue) {
                              ref
                                  .read(bidsStateProvider.notifier)
                                  .setClient(newValue);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Terms and Conditions Section ────────────────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 20,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          localizations.termsAndConditions,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    if (stackState.isTermsLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      )
                    else if (termsContent != null &&
                        termsContent.toString().isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: HtmlWidget(
                          termsContent.toString(),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "${localizations.termsAndConditions} ${localizations.notAvailable.toLowerCase()}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // ── Sticky Bottom Action Bar ──────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localizations.cancel,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Submit Bid Button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitBid,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        disabledBackgroundColor: Colors.grey.shade400,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  localizations.submitBid,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStackSummaryCard(
    Datum stackData,
    AppLocalizations localizations,
    Color themeColor,
    bool isFactory,
  ) {
    final cleanCommodity = ProductHelper.cleanCommodityName(
      stackData.commodityName,
      stackData.warehouseName,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${localizations.stackNoWithDash} ${stackData.stackNumber ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isFactory
                          ? localizations.factoryDelivery
                          : localizations.warehouseDelivery,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.white.withAlpha(77), height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.commodity,
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cleanCommodity.isNotEmpty ? cleanCommodity : '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.white.withAlpha(77),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.sellerPriceTitle,
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹${stackData.sellerPrice ?? '-'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (stackData.warehouseName != null &&
              stackData.warehouseName.toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.warehouse_outlined,
                  size: 14,
                  color: Colors.white.withAlpha(204),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${stackData.warehouseName}${stackData.warehouseAddress != null && stackData.warehouseAddress.toString().isNotEmpty ? ' (${stackData.warehouseAddress})' : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 12,
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
}
