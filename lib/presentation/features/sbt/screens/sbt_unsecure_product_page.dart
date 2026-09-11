import 'package:ag_broker/core/utils/product_helper.dart';
import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/sbt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SbtUnsecureProductPage extends ConsumerStatefulWidget {
  const SbtUnsecureProductPage({super.key});

  @override
  ConsumerState<SbtUnsecureProductPage> createState() =>
      _SbtUnsecureProductPageState();
}

class _SbtUnsecureProductPageState
    extends ConsumerState<SbtUnsecureProductPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sbtState = ref.read(sbtStateProvider);
      if (sbtState.sbtProductData == null) {
        ref.read(sbtStateProvider.notifier).fetchSbtProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQualityParameters(BuildContext context, SbtProduct product) {
    if (product.productId != null) {
      ref
          .read(bidsStateProvider.notifier)
          .fetchQualityParams("${product.productId}");
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Consumer(
        builder: (context, ref, child) {
          final qualityData = ref.watch(bidsStateProvider).qualityParamsData;
          return _QualityParamsSheet(
            product: product,
            qualityParams: qualityData?.data,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final sbtState = ref.watch(sbtStateProvider);

    final allProducts = sbtState.sbtProductData?.data ?? [];
    // Filter for Factory (Unsecure) SBT products: sbt_type == 2 or factory
    final factoryProducts = allProducts.where((p) {
      return ProductHelper.isFactoryDelivery(
        p.sbtType,
        p.district?.toString(),
      );
    }).toList();

    final query = _searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? factoryProducts
        : factoryProducts.where((p) {
            final commodity = (p.commodity ?? '').toString().toLowerCase();
            final district = (p.district ?? '').toString().toLowerCase();
            return commodity.contains(query) || district.contains(query);
          }).toList();

    const Color primaryColor = Color(0xFFF25822); // Factory Orange

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
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
          localizations?.sbtUnsecureProduct ?? 'SBT Unsecure Products',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A6B3C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Breadcrumb

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by commodity or factory...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            ),
          ),


          Expanded(
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                await ref
                    .read(sbtStateProvider.notifier)
                    .fetchSbtProducts();
              },
              child: sbtState.isLoading && factoryProducts.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : sbtState.error != null && factoryProducts.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  sbtState.error!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => ref
                                      .read(sbtStateProvider.notifier)
                                      .fetchSbtProducts(),
                                  icon: const Icon(Icons.refresh),
                                  label: Text(
                                    localizations?.retry ?? 'Retry',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filtered.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.factory_outlined,
                                          size: 56,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          factoryProducts.isEmpty
                                              ? (localizations
                                                      ?.noDataAvailable ??
                                                  'No factory SBT products available.')
                                              : 'No matching products found.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 4, 16, 24),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final p = filtered[index];
                                return _ProductCard(
                                  product: p,
                                  index: index + 1,
                                  onViewQuality: () =>
                                      _showQualityParameters(context, p),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final SbtProduct product;
  final int index;
  final VoidCallback onViewQuality;

  const _ProductCard({
    required this.product,
    required this.index,
    required this.onViewQuality,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF25822);
    final cleanCommodity = ProductHelper.cleanCommodityName(
      product.commodity?.toString(),
      product.district?.toString(),
    );
    final cleanLocation = ProductHelper.extractLocation(
      product.district?.toString(),
    );
    final deliveryDays = ProductHelper.extractDeliveryDays(
      product.district?.toString(),
    );
    final scheduleTime = ProductHelper.formatBidTime(
      product.date,
      product.bidTime,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cleanCommodity.isNotEmpty
                        ? cleanCommodity
                        : (product.commodity?.toString() ?? '-'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: onViewQuality,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 10,
                //       vertical: 5,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: const [
                //         Icon(
                //           Icons.visibility_outlined,
                //           size: 14,
                //           color: primaryColor,
                //         ),
                //         SizedBox(width: 4),
                //         Text(
                //           'Quality',
                //           style: TextStyle(
                //             fontSize: 11,
                //             color: primaryColor,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Factory & Location row
                if (cleanLocation.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.factory_outlined,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          cleanLocation,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                // Circuit prices
                Row(
                  children: [
                    Expanded(
                      child: _CircuitBox(
                        label: 'Lower Circuit',
                        value: '₹${product.lowerCircuit ?? '-'}/QTL',
                        color: const Color(0xFFE8F5E9),
                        textColor: const Color(0xFF2E7D32),
                        icon: Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CircuitBox(
                        label: 'Upper Circuit',
                        value: '₹${product.upperCircuit ?? '-'}/QTL',
                        color: const Color(0xFFFFF3E0),
                        textColor: const Color(0xFFE65100),
                        icon: Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Full-width Bid Time Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bid Time: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          scheduleTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Details grid: Row 1 (Qty Limit, Delivery, LTP)
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.inventory_2_outlined,
                        label: 'Qty Limit',
                        value: '${product.quantityLimit ?? '-'} QTL',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.local_shipping_outlined,
                        label: 'Delivery',
                        value: deliveryDays,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.price_check_outlined,
                        label: 'LTP',
                        value: product.ltp != null
                            ? '₹${product.ltp}'
                            : '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Details grid: Row 2 (Best Buyer, Best Seller)
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.trending_up_rounded,
                        label: 'Best Buyer',
                        value: product.bestBuyer != null &&
                                '${product.bestBuyer}' != '0'
                            ? '₹${product.bestBuyer}'
                            : '-',
                        highlight: product.bestBuyer != null &&
                            '${product.bestBuyer}' != '0',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.trending_down_rounded,
                        label: 'Best Seller',
                        value: product.bestSeller != null &&
                                '${product.bestSeller}' != '0'
                            ? '₹${product.bestSeller}'
                            : '-',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircuitBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final IconData icon;

  const _CircuitBox({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF25822);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFF8E1) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: highlight
            ? Border.all(color: const Color(0xFFFFCC02), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: primaryColor),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight
                  ? const Color(0xFFE65100)
                  : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityParamsSheet extends StatelessWidget {
  final SbtProduct product;
  final List<dynamic>? qualityParams;

  const _QualityParamsSheet({
    required this.product,
    this.qualityParams,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF25822);
    final cleanCommodity = ProductHelper.cleanCommodityName(
      product.commodity?.toString(),
      product.district?.toString(),
    );
    final cleanLocation = ProductHelper.extractLocation(
      product.district?.toString(),
    );
    final deliveryDays = ProductHelper.extractDeliveryDays(
      product.district?.toString(),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quality & Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cleanCommodity.isNotEmpty
                ? cleanCommodity
                : (product.commodity?.toString() ?? ''),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                _QualityRow(label: 'Commodity', value: cleanCommodity),
                const Divider(height: 16),
                _QualityRow(
                  label: 'Factory / Location',
                  value: cleanLocation.isNotEmpty ? cleanLocation : '-',
                ),
                const Divider(height: 16),
                _QualityRow(
                  label: 'Circuits',
                  value:
                      '₹${product.lowerCircuit ?? '-'} - ₹${product.upperCircuit ?? '-'}',
                ),
                const Divider(height: 16),
                _QualityRow(
                  label: 'Quantity Limit',
                  value: '${product.quantityLimit ?? '-'} QTL',
                ),
                const Divider(height: 16),
                _QualityRow(
                  label: 'Delivery Terms',
                  value: deliveryDays,
                ),
                if (qualityParams != null && qualityParams!.isNotEmpty) ...[
                  const Divider(height: 16),
                  ...qualityParams!.map((param) {
                    final pName = param['parameter_name'] ?? param['name'] ?? '';
                    final pVal = param['value'] ?? param['parameter_value'] ?? '';
                    if (pName.toString().isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _QualityRow(
                        label: pName.toString(),
                        value: pVal.toString(),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityRow extends StatelessWidget {
  final String label;
  final String value;

  const _QualityRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}