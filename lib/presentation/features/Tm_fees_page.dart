import 'package:flutter/material.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class TmUser {
  final String id;
  final String name;
  final String phone;

  const TmUser({required this.id, required this.name, required this.phone});

  String get displayName => '$name ($phone)';
}

class DealTypeFee {
  final String dealType;
  double buyFee;
  double sellFee;

  DealTypeFee({required this.dealType, required this.buyFee, required this.sellFee});
}

class ExistingCommission {
  final int sNo;
  final String user;
  final String dealType;
  final double buyCommission;
  final double sellCommission;

  const ExistingCommission({
    required this.sNo,
    required this.user,
    required this.dealType,
    required this.buyCommission,
    required this.sellCommission,
  });
}

// ─── Sample Data ─────────────────────────────────────────────────────────────

const List<TmUser> _sampleUsers = [
  TmUser(id: '1', name: 'Punia Trading Company', phone: '9414595409'),
  TmUser(id: '2', name: 'Anurag Traders', phone: '7488353866'),
  TmUser(id: '3', name: 'Deepak Trading', phone: '9570675930'),
  TmUser(id: '4', name: 'Sharma Enterprises', phone: '9876543210'),
];

List<DealTypeFee> _defaultFees() => [
      DealTypeFee(dealType: 'SBT Warehouse', buyFee: 1, sellFee: 1),
      DealTypeFee(dealType: 'SBT Factory', buyFee: 1, sellFee: 1),
      DealTypeFee(dealType: 'WBT Gatepass', buyFee: 0.50, sellFee: 0.50),
      DealTypeFee(dealType: 'WBT Stack Sell', buyFee: 0.50, sellFee: 0.50),
      DealTypeFee(dealType: 'F2f', buyFee: 0, sellFee: 0),
      DealTypeFee(dealType: 'Spot', buyFee: 1, sellFee: 1),
      DealTypeFee(dealType: 'Pots', buyFee: 0.50, sellFee: 0.50),
    ];

const List<ExistingCommission> _existingCommissions = [
  ExistingCommission(sNo: 29, user: 'Anurag Traders (7488353866)', dealType: 'Pots', buyCommission: 0.50, sellCommission: 0),
  ExistingCommission(sNo: 30, user: 'Anurag Traders (7488353866)', dealType: 'Spot', buyCommission: 1, sellCommission: 0),
  ExistingCommission(sNo: 31, user: 'Anurag Traders (7488353866)', dealType: 'F2f', buyCommission: 0, sellCommission: 0),
  ExistingCommission(sNo: 32, user: 'Anurag Traders (7488353866)', dealType: 'WBT Stack Sell', buyCommission: 0.50, sellCommission: 0),
  ExistingCommission(sNo: 33, user: 'Anurag Traders (7488353866)', dealType: 'WBT Gatepass', buyCommission: 0.50, sellCommission: 0),
  ExistingCommission(sNo: 34, user: 'Anurag Traders (7488353866)', dealType: 'SBT Factory', buyCommission: 1, sellCommission: 0),
  ExistingCommission(sNo: 35, user: 'Anurag Traders (7488353866)', dealType: 'SBT Warehouse', buyCommission: 1, sellCommission: 0),
  ExistingCommission(sNo: 8, user: 'Deepak Trading (9570675930)', dealType: 'WBT Gatepass', buyCommission: 0.50, sellCommission: 0.50),
  ExistingCommission(sNo: 9, user: 'Deepak Trading (9570675930)', dealType: 'SBT Warehouse', buyCommission: 1, sellCommission: 0.5),
  ExistingCommission(sNo: 10, user: 'Deepak Trading (9570675930)', dealType: 'SBT Factory', buyCommission: 1, sellCommission: 0.5),
];

// ─── Main Page ───────────────────────────────────────────────────────────────

class TmFeesPage extends StatefulWidget {
  const TmFeesPage({super.key});

  @override
  State<TmFeesPage> createState() => _TmFeesPageState();
}

class _TmFeesPageState extends State<TmFeesPage> {
  TmUser? _selectedUser;
  List<DealTypeFee> _fees = _defaultFees();
  final TextEditingController _searchController = TextEditingController();
  List<ExistingCommission> _filteredCommissions = _existingCommissions;

  static const _teal = Color(0xFF26C6C6);

  void _onUserSelected(TmUser user) {
    setState(() {
      _selectedUser = user;
      _fees = _defaultFees(); // reset / load from API
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filteredCommissions = _existingCommissions.where((c) {
        return c.user.toLowerCase().contains(query.toLowerCase()) ||
            c.dealType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _onSubmit() {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user first')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('TM Fees submitted for ${_selectedUser!.name}'),
        backgroundColor: _teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('TM Client Fees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
         backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Breadcrumb
          Row(
            children: const [
              Icon(Icons.home_outlined, size: 13, color: Color(0xFF26C6C6)),
              SizedBox(width: 4),
              Text('Home', style: TextStyle(fontSize: 12, color: Color(0xFF26C6C6))),
              Text(' / ', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('TM Client Fees', style: TextStyle(fontSize: 12, color: Color(0xFF26C6C6), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),

          // ── Section 1: User Selection + Fees Form ──
          _SectionCard(
            title: 'TM Client Fees',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Dropdown
                _UserDropdown(
                  users: _sampleUsers,
                  selectedUser: _selectedUser,
                  onSelected: _onUserSelected,
                ),
                const SizedBox(height: 20),

                // Fee table (only shown when user is selected)
                if (_selectedUser != null) ...[
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'User Wise TM Fees',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 12),
                  _FeesTable(fees: _fees),
                  const SizedBox(height: 20),
                ],

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Section 2: Existing Commission Data ──
          _SectionCard(
            title: 'Existing TM Commission Data',
            child: _ExistingCommissionSection(
              commissions: _filteredCommissions,
              searchController: _searchController,
              onSearch: _onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Card Wrapper ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

// ─── User Dropdown ───────────────────────────────────────────────────────────

class _UserDropdown extends StatelessWidget {
  final List<TmUser> users;
  final TmUser? selectedUser;
  final ValueChanged<TmUser> onSelected;

  const _UserDropdown({required this.users, required this.selectedUser, required this.onSelected});

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _UserPickerSheet(users: users, onSelected: (u) {
        Navigator.pop(context);
        onSelected(u);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('Users', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedUser?.displayName ?? 'Select User',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedUser != null ? const Color(0xFF333333) : Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── User Picker Bottom Sheet ────────────────────────────────────────────────

class _UserPickerSheet extends StatefulWidget {
  final List<TmUser> users;
  final ValueChanged<TmUser> onSelected;

  const _UserPickerSheet({required this.users, required this.onSelected});

  @override
  State<_UserPickerSheet> createState() => _UserPickerSheetState();
}

class _UserPickerSheetState extends State<_UserPickerSheet> {
  final TextEditingController _ctrl = TextEditingController();
  late List<TmUser> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.users;
    _ctrl.addListener(() {
      setState(() {
        _filtered = widget.users
            .where((u) => u.displayName.toLowerCase().contains(_ctrl.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Select User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Search user...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF26C6C6)),
                filled: true,
                fillColor: const Color(0xFFF4F6FA),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final u = _filtered[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF26C6C6).withValues(alpha: 0.15),
                      child: Text(u.name[0], style: const TextStyle(color: Color(0xFF26C6C6), fontWeight: FontWeight.bold)),
                    ),
                    title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(u.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    onTap: () => widget.onSelected(u),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fees Table ──────────────────────────────────────────────────────────────

class _FeesTable extends StatefulWidget {
  final List<DealTypeFee> fees;

  const _FeesTable({required this.fees});

  @override
  State<_FeesTable> createState() => _FeesTableState();
}

class _FeesTableState extends State<_FeesTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF26C6C6).withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('Deal Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF555555)))),
              Expanded(flex: 2, child: Text('Buy Fee (%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF555555)), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('Sell Fee (%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF555555)), textAlign: TextAlign.center)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ...widget.fees.asMap().entries.map((entry) {
          final i = entry.key;
          final fee = entry.value;
          return Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(fee.dealType, style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                ),
                Expanded(
                  flex: 2,
                  child: _FeeInput(
                    value: fee.buyFee,
                    onChanged: (v) => setState(() => fee.buyFee = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _FeeInput(
                    value: fee.sellFee,
                    onChanged: (v) => setState(() => fee.sellFee = v),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _FeeInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _FeeInput({required this.value, required this.onChanged});

  @override
  State<_FeeInput> createState() => _FeeInputState();
}

class _FeeInputState extends State<_FeeInput> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value == widget.value.truncateToDouble()
        ? widget.value.toInt().toString()
        : widget.value.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF26C6C6), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) widget.onChanged(parsed);
      },
    );
  }
}

// ─── Existing Commission Section ─────────────────────────────────────────────

class _ExistingCommissionSection extends StatelessWidget {
  final List<ExistingCommission> commissions;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _ExistingCommissionSection({
    required this.commissions,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        TextField(
          controller: searchController,
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Search user or deal type...',
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF26C6C6)),
            filled: true,
            fillColor: const Color(0xFFF4F6FA),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Showing ${commissions.length} of ${_existingCommissions.length} entries',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 12),

        if (commissions.isEmpty)
          const Center(child: Text('No records found.', style: TextStyle(color: Colors.grey)))
        else
          ...commissions.map((c) => _CommissionCard(commission: c)),
      ],
    );
  }
}

class _CommissionCard extends StatelessWidget {
  final ExistingCommission commission;

  const _CommissionCard({required this.commission});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FFFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF26C6C6).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // S.No badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF26C6C6).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${commission.sNo}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF26C6C6)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commission.user, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF333333))),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(commission.dealType, style: const TextStyle(fontSize: 11, color: Color(0xFF00838F), fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CommBadge(label: 'Buy', value: commission.buyCommission, color: const Color(0xFF2E7D32)),
              const SizedBox(height: 4),
              _CommBadge(label: 'Sell', value: commission.sellCommission, color: const Color(0xFFE65100)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommBadge extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _CommBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$value%',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}