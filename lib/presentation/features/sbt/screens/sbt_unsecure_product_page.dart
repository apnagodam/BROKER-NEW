import 'package:flutter/material.dart';

class SbtUnsecureProduct {
  final int srNo;
  final String commodity;
  final String factoryName;
  final String state;
  final String district;
  final String location;
  final String address;
  final double lowerCircuit;
  final double upperCircuit;
  final double quantityLimit;
  final int deliveryDays;
  final String expiryDate;
  final double sellerMargin;
  final double buyerMargin;
  final double creditLimit;
  final double labour;
  final double dhalta;
  final String shipToName;
  final String shipToGST;

  const SbtUnsecureProduct({
    required this.srNo,
    required this.commodity,
    required this.factoryName,
    required this.state,
    required this.district,
    required this.location,
    required this.address,
    required this.lowerCircuit,
    required this.upperCircuit,
    required this.quantityLimit,
    required this.deliveryDays,
    required this.expiryDate,
    required this.sellerMargin,
    required this.buyerMargin,
    required this.creditLimit,
    required this.labour,
    required this.dhalta,
    this.shipToName = '',
    this.shipToGST = '',
  });
}

const List<SbtUnsecureProduct> _sampleProducts = [
  SbtUnsecureProduct(
    srNo: 1,
    commodity: 'Feed Barley',
    factoryName: 'Khatu Manda - Old barley (Khatu Manda - Old barley)',
    state: 'Rajasthan',
    district: 'Jaipur',
    location: 'Jaipur, (जयपुर,), 332402',
    address: 'Madini Manda, Tehsil-Dataramgarh (मदिनी मंडा, तहसील - दातारामगढ़)',
    lowerCircuit: 2100,
    upperCircuit: 2500,
    quantityLimit: 1500,
    deliveryDays: 5,
    expiryDate: '6-3-2026',
    sellerMargin: 0,
    buyerMargin: 0,
    creditLimit: 0,
    labour: 0,
    dhalta: 0,
    shipToName: '',
    shipToGST: '',
  ),
  SbtUnsecureProduct(
    srNo: 2,
    commodity: '0.5% FF - Oil Quality Ground Nut',
    factoryName: 'Rajasthan Groundnut (राजस्थान मूंगफली)',
    state: 'Rajasthan',
    district: 'Jodhpur',
    location: 'AAU, (Rajasthan), 342311',
    address: 'R K Warehouse, AAU, Phalodi (R K Warehouse, AAU, Phalodi)',
    lowerCircuit: 5000,
    upperCircuit: 8000,
    quantityLimit: 2000,
    deliveryDays: 5,
    expiryDate: '30-4-2026',
    sellerMargin: 8,
    buyerMargin: 8,
    creditLimit: 1,
    labour: 12,
    dhalta: 0,
    shipToName: 'R K Warehouse, AAU',
    shipToGST: '',
  ),
];

class SbtUnsecureProductPage extends StatefulWidget {
  const SbtUnsecureProductPage({super.key});

  @override
  State<SbtUnsecureProductPage> createState() => _SbtUnsecureProductPageState();
}

class _SbtUnsecureProductPageState extends State<SbtUnsecureProductPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SbtUnsecureProduct> _filtered = _sampleProducts;

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
            p.district.toLowerCase().contains(query) ||
            p.state.toLowerCase().contains(query) ||
            p.factoryName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQualityParameters(BuildContext context, SbtUnsecureProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _QualityParamsSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'SBT Unsecure Products',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B3F00),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Breadcrumb
          Container(
            width: double.infinity,
            color: const Color(0xFF7B3F00).withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: const [
                Icon(Icons.home_outlined, size: 14, color: Color(0xFF7B3F00)),
                SizedBox(width: 4),
                Text('Home', style: TextStyle(fontSize: 12, color: Color(0xFF7B3F00))),
                Text(' / ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  'SBT Unsecure Products',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B3F00),
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
                hintText: 'Search commodity, district, state...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7B3F00)),
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
                  borderSide: const BorderSide(color: Color(0xFF7B3F00), width: 1.5),
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
                    child: Text('No products found.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final p = _filtered[index];
                      return _ProductCard(
                        product: p,
                        onViewQuality: () => _showQualityParameters(context, p),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final SbtUnsecureProduct product;
  final VoidCallback onViewQuality;

  const _ProductCard({required this.product, required this.onViewQuality});

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFF7B3F00),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 15,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onViewQuality,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF7B3F00)),
                        SizedBox(width: 4),
                        Text(
                          'Quality',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7B3F00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Factory & Location row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabelValue(
                        icon: Icons.factory_outlined,
                        label: 'Factory',
                        value: product.factoryName,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LabelValue(
                        icon: Icons.location_city_outlined,
                        label: 'State / District',
                        value: '${product.state} / ${product.district}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Address
                _LabelValue(
                  icon: Icons.place_outlined,
                  label: 'Address',
                  value: product.address,
                ),
                const SizedBox(height: 10),

                // Circuit prices
                Row(
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
                const SizedBox(height: 10),

                // Info grid row 1
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

                // Info grid row 2
                Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.credit_card_outlined,
                        label: 'Credit Limit',
                        value: '₹${product.creditLimit.toInt()}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Info grid row 3
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.engineering_outlined,
                        label: 'Labour (₹)',
                        value: '₹${product.labour.toInt()}',
                        highlight: product.labour > 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.percent_outlined,
                        label: 'Dhalta (%)',
                        value: '${product.dhalta.toInt()}%',
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (product.shipToName.isNotEmpty)
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.warehouse_outlined,
                          label: 'Ship To',
                          value: product.shipToName,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
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

class _QualityParamsSheet extends StatelessWidget {
  final SbtUnsecureProduct product;

  const _QualityParamsSheet({required this.product});

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Quality Parameters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7B3F00),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.commodity,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF7B3F00).withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                _QualityRow(label: 'Location', value: product.location),
                const Divider(height: 16),
                _QualityRow(label: 'Full Address', value: product.address),
                const Divider(height: 16),
                _QualityRow(label: 'Commodity', value: product.commodity),
                const Divider(height: 16),
                _QualityRow(label: 'Factory Name', value: product.factoryName),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF7B3F00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF333333), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LabelValue({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF7B3F00)),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text( 
                value,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
              ),
            ],
          ),
        ),
      ],
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
                Text(label, style: TextStyle(fontSize: 10, color: textColor.withValues(alpha: 0.7))),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
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
        border: highlight ? Border.all(color: const Color(0xFFFFCC02), width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF7B3F00)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          Text( 
            value, 
            style: TextStyle(  
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: highlight ? const Color(0xFFE65100) : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}