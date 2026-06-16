import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class MarginFundingScheme {
  final int? id;
  final double loanPerTotalAmount;
  final double interestRate;
  final double processingFee;
  final String tenorType;
  final int tenor;
  final String restType;

  MarginFundingScheme({
    this.id,
    required this.loanPerTotalAmount,
    required this.interestRate,
    required this.processingFee,
    required this.tenorType,
    required this.tenor,
    required this.restType,
  });

  MarginFundingScheme copyWith({
    int? id,
    double? loanPerTotalAmount,
    double? interestRate,
    double? processingFee,
    String? tenorType,
    int? tenor,
    String? restType,
  }) {
    return MarginFundingScheme(
      id: id ?? this.id,
      loanPerTotalAmount: loanPerTotalAmount ?? this.loanPerTotalAmount,
      interestRate: interestRate ?? this.interestRate,
      processingFee: processingFee ?? this.processingFee,
      tenorType: tenorType ?? this.tenorType,
      tenor: tenor ?? this.tenor,
      restType: restType ?? this.restType,
    );
  }
}

// ── Page ──────────────────────────────────────────────────────────────────────

class MarginFundingSchemesPage extends StatefulWidget {
  const MarginFundingSchemesPage({super.key});

  @override
  State<MarginFundingSchemesPage> createState() =>
      _MarginFundingSchemesPageState();
}

class _MarginFundingSchemesPageState extends State<MarginFundingSchemesPage> {
  // TODO: Replace with real API data via Riverpod provider
  final List<MarginFundingScheme> _schemes = [
    MarginFundingScheme(
      id: 1,
      loanPerTotalAmount: 80,
      interestRate: 12,
      processingFee: 1,
      tenorType: 'Long Terms',
      tenor: 9,
      restType: 'Monthly',
    ),
    MarginFundingScheme(
      id: 2,
      loanPerTotalAmount: 70,
      interestRate: 12,
      processingFee: 1,
      tenorType: 'Long Terms',
      tenor: 9,
      restType: 'Monthly',
    ),
  ];

  // ── Delete ──────────────────────────────────────────────────────────────────

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Scheme'),
        content: const Text('Are you sure you want to delete this scheme?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _schemes.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Scheme deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Add / Edit bottom sheet ─────────────────────────────────────────────────

  void _openSchemeSheet({MarginFundingScheme? existing, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _SchemeFormSheet(
        existing: existing,
        onSubmit: (scheme) {
          setState(() {
            if (index != null) {
              _schemes[index] = scheme.copyWith(id: existing?.id);
            } else {
              _schemes.add(
                  scheme.copyWith(id: _schemes.length + 1));
            }
          });
        },
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Margin Funding Schemes'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon( 
              onPressed: () => _openSchemeSheet(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Scheme'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                elevation: 0,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: _schemes.isEmpty
          ? _emptyState(primary)
          : _schemeList(primary),
    );
  }

  Widget _emptyState(Color primary) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.percent_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No schemes yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add Scheme" to create one',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );

  Widget _schemeList(Color primary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header card ───────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.percent_outlined, color: primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Margin Funding Scheme List',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text( 
                    '${_schemes.length} ${_schemes.length == 1 ? 'scheme' : 'schemes'}',
                    style: const TextStyle( 
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(  
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              itemCount: _schemes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _schemeCard(_schemes[index], index, primary),
            ),
          ),
        ],
      );

  Widget _schemeCard(MarginFundingScheme s, int index, Color primary) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Sr. No. + action buttons ────────────────────────────
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Scheme #${s.id ?? index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const Spacer(),
                // Edit
                IconButton(
                  onPressed: () =>
                      _openSchemeSheet(existing: s, index: index),
                  icon: Icon(Icons.edit_outlined,
                      color: Colors.teal.shade700, size: 20),
                  tooltip: 'Edit',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                      minWidth: 36, minHeight: 36),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.teal.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete
                IconButton(
                  onPressed: () => _confirmDelete(index),
                  icon: Icon(Icons.delete_outline,
                      color: Colors.red.shade700, size: 20),
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                      minWidth: 36, minHeight: 36),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Row 2: key metrics ──────────────────────────────────────────
            Row(
              children: [
                _metricChip(
                  label: 'Loan Amount',
                  value: '${s.loanPerTotalAmount.toStringAsFixed(0)}%',
                  color: primary,
                ),
                const SizedBox(width: 8),
                _metricChip(
                  label: 'Interest Rate',
                  value: '${s.interestRate.toStringAsFixed(0)}%',
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 8),
                _metricChip(
                  label: 'Processing Fee',
                  value: '${s.processingFee.toStringAsFixed(0)}%',
                  color: Colors.indigo.shade700,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Row 3: tenor info ───────────────────────────────────────────
            Row(
              children: [
                _infoTile(
                    Icons.access_time_outlined, 'Tenor Type', s.tenorType),
                const SizedBox(width: 8),
                _infoTile(Icons.calendar_today_outlined, 'Tenor',
                    '${s.tenor} Months'),
                const SizedBox(width: 8),
                _infoTile(
                    Icons.autorenew_outlined, 'Rest Type', s.restType),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(
      {required String label,
      required String value,
      required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                Text(label,
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey.shade500)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Form Bottom Sheet ─────────────────────────────────────────────────────────

class _SchemeFormSheet extends StatefulWidget {
  final MarginFundingScheme? existing;
  final void Function(MarginFundingScheme) onSubmit;

  const _SchemeFormSheet({this.existing, required this.onSubmit});

  @override
  State<_SchemeFormSheet> createState() => _SchemeFormSheetState();
}

class _SchemeFormSheetState extends State<_SchemeFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _interestRateCtrl;
  late final TextEditingController _processingFeeCtrl;
  late final TextEditingController _loanAmountCtrl;
  late final TextEditingController _tenorCtrl;

  String? _tenorType;
  String? _restType;
  bool _isSubmitting = false;

  static const _tenorTypes = ['Month', 'Long Terms', 'Short Terms'];
  static const _restTypes = ['Monthly', 'Quarterly', 'Half Yearly', 'Yearly'];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _interestRateCtrl =
        TextEditingController(text: e != null ? '${e.interestRate}' : '');
    _processingFeeCtrl =
        TextEditingController(text: e != null ? '${e.processingFee}' : '');
    _loanAmountCtrl =
        TextEditingController(text: e != null ? '${e.loanPerTotalAmount}' : '');
    _tenorCtrl =
        TextEditingController(text: e != null ? '${e.tenor}' : '');

    // Map stored value back to dropdown option
    if (e != null) {
      _tenorType = _tenorTypes.contains(e.tenorType) ? e.tenorType : 'Month';
      _restType = _restTypes.contains(e.restType) ? e.restType : 'Monthly';
    }
  }

  @override
  void dispose() {
    _interestRateCtrl.dispose();
    _processingFeeCtrl.dispose();
    _loanAmountCtrl.dispose();
    _tenorCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 600));

    final scheme = MarginFundingScheme(
      loanPerTotalAmount: double.parse(_loanAmountCtrl.text),
      interestRate: double.parse(_interestRateCtrl.text),
      processingFee: double.parse(_processingFeeCtrl.text),
      tenorType: _tenorType!,
      tenor: int.parse(_tenorCtrl.text),
      restType: _restType!,
    );

    if (mounted) {
      widget.onSubmit(scheme);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(_isEdit ? 'Scheme updated' : 'Scheme added'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title bar ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEdit
                          ? 'Edit Margin Funding Scheme'
                          : 'Add Margin Funding Scheme',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),

              // ── Interest Rate ─────────────────────────────────────────────
              _fieldLabel('Interest Rate (%)', required: true),
              _buildNumberField(
                controller: _interestRateCtrl,
                hint: 'e.g. 12',
                validator: _required,
              ),
              const SizedBox(height: 14),

              // ── Processing Fee ────────────────────────────────────────────
              _fieldLabel('Processing Fee (%)', required: true),
              _buildNumberField(
                controller: _processingFeeCtrl,
                hint: 'e.g. 1',
                validator: _required,
              ),
              const SizedBox(height: 14),

              // ── Loan per Total Amount ─────────────────────────────────────
              _fieldLabel('Loan per Total Amount (%)', required: true),
              _buildNumberField(
                controller: _loanAmountCtrl,
                hint: 'e.g. 80',
                validator: _required,
              ),
              const SizedBox(height: 14),

              // ── Tenor Type ────────────────────────────────────────────────
              _fieldLabel('Tenor Type', required: true),
              _buildDropdown(
                value: _tenorType,
                items: _tenorTypes,
                hint: 'Select',
                onChanged: (v) => setState(() => _tenorType = v),
                validator: (v) =>
                    v == null ? 'Please select tenor type' : null,
              ),
              const SizedBox(height: 14),

              // ── Tenor ─────────────────────────────────────────────────────
              _fieldLabel('Tenor', required: true),
              _buildNumberField(
                controller: _tenorCtrl,
                hint: 'e.g. 9',
                validator: _required,
                isDecimal: false,
              ),
              const SizedBox(height: 14),

              // ── Rest Type ─────────────────────────────────────────────────
              _fieldLabel('Rest Type', required: true),
              _buildDropdown(
                value: _restType,
                items: _restTypes,
                hint: 'Select',
                onChanged: (v) => setState(() => _restType = v),
                validator: (v) =>
                    v == null ? 'Please select rest type' : null,
              ),
              const SizedBox(height: 24),

              // ── Submit ────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(_isEdit ? 'Update' : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Form helpers ─────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87),
          children: required
              ? const [
                  TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red))
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    bool isDecimal = true,
  }) {
    return TextFormField(
      controller: controller, 
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            isDecimal ? RegExp(r'[\d.]') : RegExp(r'\d')),
      ],
      decoration: _inputDecoration(hint),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hint),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(  
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(  
        borderRadius: BorderRadius.circular(8), 
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  String? _required(String? v) => 
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;
}