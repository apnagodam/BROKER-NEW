import 'package:flutter/material.dart';

class SbtSecureProduct {
  final int srNo;
  final String commodity;
  final String district;
  final double lowerCircuit;
  final double upperCircuit;
  final double quantityLimit;
  final int deliveryDays;
  final String expiryDate;
  final double penalty;
  final double sellerMargin;
  final double buyerMargin;

  const SbtSecureProduct({
    required this.srNo,
    required this.commodity,
    required this.district,
    required this.lowerCircuit,
    required this.upperCircuit,
    required this.quantityLimit,
    required this.deliveryDays,
    required this.expiryDate,
    required this.penalty,
    required this.sellerMargin,
    required this.buyerMargin,
  });
}

const List<SbtSecureProduct> _sampleProducts = [
  SbtSecureProduct(
    srNo: 1,
    commodity: 'Chana',
    district: 'Ajmer',
    lowerCircuit: 5200,
    upperCircuit: 5800,
    quantityLimit: 5000,
    deliveryDays: 7,
    expiryDate: '24-3-2026',
    penalty: 3,
    sellerMargin: 8,
    buyerMargin: 8,
  ),
  SbtSecureProduct(
    srNo: 2,
    commodity: 'Maize',
    district: 'Madhepura',
    lowerCircuit: 1850,
    upperCircuit: 2050,
    quantityLimit: 20000,
    deliveryDays: 5,
    expiryDate: '21-05-2026',
    penalty: 1,
    sellerMargin: 0,
    buyerMargin: 0,
  ),
  SbtSecureProduct(
    srNo: 3,
    commodity: 'Maize',
    district: 'Khagaria',
    lowerCircuit: 1850,
    upperCircuit: 2050,
    quantityLimit: 20000,
    deliveryDays: 5,
    expiryDate: '30-5-2026',
    penalty: 1,
    sellerMargin: 0,
    buyerMargin: 0,
  ),
  SbtSecureProduct(
    srNo: 4,
    commodity: 'Maize',
    district: 'Bhagalpur',
    lowerCircuit: 1850,
    upperCircuit: 2050,
    quantityLimit: 20000,
    deliveryDays: 5,
    expiryDate: '30-5-2026',
    penalty: 1,
    sellerMargin: 0,
    buyerMargin: 0,
  ),
  SbtSecureProduct(
    srNo: 5,
    commodity: 'Maize',
    district: 'Begusarai',
    lowerCircuit: 1850,
    upperCircuit: 2050,
    quantityLimit: 20000,
    deliveryDays: 5,
    expiryDate: '30-5-2026',
    penalty: 1,
    sellerMargin: 0,
    buyerMargin: 0,
  ),
];

class SbtSecureProductPage extends StatefulWidget {
  const SbtSecureProductPage({super.key});

  @override
  State<SbtSecureProductPage> createState() => _SbtSecureProductPageState();
}

class _SbtSecureProductPageState extends State<SbtSecureProductPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SbtSecureProduct> _filtered = _sampleProducts;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _sampleProducts.where((p) {
        return p.commodity.toLowerCase().contains(query) ||
            p.district.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'SBT Secure Products',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A6B3C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Breadcrumb
          Container(
            width: double.infinity,
            color: const Color(0xFF1A6B3C).withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Icon(Icons.home_outlined, size: 14, color: Color(0xFF1A6B3C)),
                SizedBox(width: 4),
                Text('Home', style: TextStyle(fontSize: 12, color: Color(0xFF1A6B3C))),
                Text(' / ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  'SBT Secure Products',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A6B3C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by commodity or district...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1A6B3C)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                        },
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
                  borderSide: const BorderSide(color: Color(0xFF1A6B3C), width: 1.5),
                ),
              ),
            ),
          ),

          // Count label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${_filtered.length} of ${_sampleProducts.length} entries',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),

          // Cards list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final p = _filtered[index];
                      return _ProductCard(product: p);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final SbtSecureProduct product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6B3C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${product.srNo}',
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
                    product.commodity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      product.district,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Circuit prices
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _CircuitBox(
                    label: 'Lower Circuit',
                    value: '₹${product.lowerCircuit.toInt()}/QTL',
                    color: const Color(0xFFE8F5E9),
                    textColor: const Color(0xFF2E7D32),
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _CircuitBox(
                    label: 'Upper Circuit',
                    value: '₹${product.upperCircuit.toInt()}/QTL',
                    color: const Color(0xFFFFF3E0),
                    textColor: const Color(0xFFE65100),
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ),

          // Details grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.inventory_2_outlined,
                        label: 'Qty Limit',
                        value: '${product.quantityLimit.toInt()} QTL',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.local_shipping_outlined,
                        label: 'Delivery',
                        value: '${product.deliveryDays} Days',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.calendar_today_outlined,
                        label: 'Expiry',
                        value: product.expiryDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.gavel_outlined,
                        label: 'Penalty',
                        value: '${product.penalty.toInt()}%',
                        highlight: product.penalty > 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.store_outlined,
                        label: 'Seller Margin',
                        value: '${product.sellerMargin.toInt()}%',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.shopping_cart_outlined,
                        label: 'Buyer Margin',
                        value: '${product.buyerMargin.toInt()}%',
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
                  style: TextStyle(fontSize: 10, color: textColor.withValues(alpha: 0.7)),
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
          Icon(icon, size: 13, color: const Color(0xFF1A6B3C)),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight ? const Color(0xFFE65100) : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}