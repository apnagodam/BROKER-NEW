import 'package:flutter/material.dart';

// ─── Dummy model (replace with real API model later) ──────────────────────────
class AuthorisedPerson {
  final String uniqueId;
  final String name;
  final String phone;
  final String status;
  final double brokerageWalletBalance;
  final String date;
  // KYC details
  final String proUserName;
  final String tradingMemberName;
  final String clearingMemberName;
  final String state;
  final String district;
  final String pinCode;
  final String address;
  final String email;
  final String virtualAccount;
  final String virtualAccountNumber;
  final String upi;
  final String paymentApi;
  final String bankName;
  final String accountNo;
  final String ifscCode;
  final String bankBranchAddress;
  final String priceAlertWhatsApp;
  final String commodity;
  final String aadharNo;
  final String panCardNo;

  const AuthorisedPerson({
    required this.uniqueId,
    required this.name,
    required this.phone,
    required this.status,
    required this.brokerageWalletBalance,
    required this.date,
    this.proUserName = 'NA',
    this.tradingMemberName = 'NA',
    this.clearingMemberName = 'NA',
    this.state = 'NA',
    this.district = 'NA',
    this.pinCode = 'NA',
    this.address = 'NA',
    this.email = 'NA',
    this.virtualAccount = 'No',
    this.virtualAccountNumber = 'NA',
    this.upi = 'NA',
    this.paymentApi = 'No',
    this.bankName = 'NA',
    this.accountNo = 'NA',
    this.ifscCode = 'NA',
    this.bankBranchAddress = 'NA',
    this.priceAlertWhatsApp = 'No',
    this.commodity = 'NA',
    this.aadharNo = 'NA',
    this.panCardNo = 'NA',
  });
}

// ─── Dummy data (replace with API call later) ─────────────────────────────────
final _dummyList = [
  AuthorisedPerson(
    uniqueId: '8||23||967||577',
    name: 'Mukesh Kumar',
    phone: '9772771267',
    status: 'Verified',
    brokerageWalletBalance: 0.00,
    date: '21-Dec-2021',
    proUserName: 'NA (NA)',
    tradingMemberName: 'CLPL Trading Member (5020001108)',
    clearingMemberName: 'Chiraag Logistics Private Limited',
    state: 'Rajasthan',
    district: 'Sikar',
    pinCode: '332402',
    address: 'Ward No. - 8 Mandha, Sikar',
    email: 'NA',
    bankName: 'Punjab National Bank',
    accountNo: '906000100326724',
    ifscCode: 'PUNB0090600',
    aadharNo: '427244751394',
    panCardNo: 'FTIPK1832C',
  ),
  AuthorisedPerson(
    uniqueId: '8||14||967||612',
    name: 'Mukesh Kulwal',
    phone: '9414063548',
    status: 'Verified',
    brokerageWalletBalance: 18581.40,
    date: '18-Feb-2022',
  ),
  AuthorisedPerson(
    uniqueId: '8||18||967||646',
    name: 'Sarwar Singh',
    phone: '7378037632',
    status: 'Verified',
    brokerageWalletBalance: 0.00,
    date: '14-Apr-2022',
  ),
  AuthorisedPerson(
    uniqueId: '8||14||967||928',
    name: 'Ranjeet',
    phone: '9414857096',
    status: 'Verified',
    brokerageWalletBalance: 0.00,
    date: '09-Dec-2025',
  ),
  AuthorisedPerson(
    uniqueId: '8||14||967||933',
    name: 'Birbal',
    phone: '9414054962',
    status: 'Verified',
    brokerageWalletBalance: 0.00,
    date: '29-Dec-2025',
  ),
];

// ─── Main Page ────────────────────────────────────────────────────────────────
class AuthorisedPersonPage extends StatefulWidget {
  const AuthorisedPersonPage({super.key});

  @override
  State<AuthorisedPersonPage> createState() => _AuthorisedPersonPageState();
}

class _AuthorisedPersonPageState extends State<AuthorisedPersonPage>
   {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    
  }

  @override
  void dispose() {
  
    _searchController.dispose();
    super.dispose();
  }

  List<AuthorisedPerson> get _filtered => _dummyList
      .where(
        (p) =>
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.phone.contains(_searchQuery) ||
            p.uniqueId.contains(_searchQuery),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
     appBar: AppBar(
  title: const Text('Authorised Person'),
  centerTitle: true,
  backgroundColor: primary,
  foregroundColor: Colors.white,
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAuthorisedPersonPage(),
            ),
          );
        },
        icon: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
          size: 18,
        ),
        label: const Text(
          'Add Person',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
),
    body: _ListTab(
  persons: _filtered,
  searchController: _searchController,
  onSearch: (q) => setState(() => _searchQuery = q),
),
    );
  }
}

// ─── LIST TAB ─────────────────────────────────────────────────────────────────
class _ListTab extends StatelessWidget {
  final List<AuthorisedPerson> persons;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _ListTab({
    required this.persons,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search by name, phone or ID…',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: primary),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        searchController.clear();
                        onSearch('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Showing ${persons.length} entries',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ),
        Expanded(
          child: persons.isEmpty
              ? Center(
                  child: Text(
                    'No records found',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  itemCount: persons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _PersonCard(person: persons[index], index: index),
                ),
        ),
      ],
    );
  }
}

// ─── Person Card ──────────────────────────────────────────────────────────────
class _PersonCard extends StatelessWidget {
  final AuthorisedPerson person;
  final int index;

  const _PersonCard({required this.person, required this.index});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isVerified = person.status == 'Verified';

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
            // Row 1: Serial + name + status
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    person.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isVerified
                          ? Colors.green.shade300
                          : Colors.orange.shade300,
                    ),
                  ),
                  child: Text(
                    person.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isVerified
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 2: ID + phone
            Row(
              children: [
                Icon(Icons.fingerprint, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    person.uniqueId,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
                Icon(
                  Icons.phone_outlined,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  person.phone,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Row 3: Wallet balance + date
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  '₹ ${person.brokerageWalletBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: person.brokerageWalletBalance > 0
                        ? Colors.green.shade700
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  person.date,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // View More Details button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showKycDetail(context, person),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('View More Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKycDetail(BuildContext context, AuthorisedPerson person) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _KycDetailSheet(person: person),
    );
  }
}

// ─── KYC Detail Bottom Sheet ──────────────────────────────────────────────────
class _KycDetailSheet extends StatelessWidget {
  final AuthorisedPerson person;
  const _KycDetailSheet({required this.person});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Icon(Icons.verified_user_outlined, color: primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'View Broker KYC',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          // Name banner
          Container(
            width: double.infinity,
            color: primary.withValues(alpha: 0.06),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Name: ${person.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: primary,
              ),
            ),
          ),
          // KYC fields
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _kycSection('Member Info', [
                  _KycField('Pro User Name', person.proUserName),
                  _KycField('Trading Member Name', person.tradingMemberName),
                  _KycField('Clearing Member Name', person.clearingMemberName),
                ]),
                _kycSection('Address', [
                  _KycField('State', person.state),
                  _KycField('District', person.district),
                  _KycField('PinCode', person.pinCode),
                  _KycField('Address', person.address),
                  _KycField('Email', person.email),
                ]),
                _kycSection('Payment Info', [
                  _KycField('Virtual Account', person.virtualAccount),
                  _KycField(
                    'Virtual Account Number',
                    person.virtualAccountNumber,
                  ),
                  _KycField('UPI', person.upi),
                  _KycField('Payment Api', person.paymentApi),
                  _KycField('Price Alert WhatsApp', person.priceAlertWhatsApp),
                  _KycField('Commodity', person.commodity),
                ]),
                _kycSection('Bank Details', [
                  _KycField('Bank Name', person.bankName),
                  _KycField('Account No', person.accountNo),
                  _KycField('IFSC Code', person.ifscCode),
                  _KycField('Bank Branch Address', person.bankBranchAddress),
                ]),
                _kycSection('KYC Documents', [
                  _KycField('Aadhar No', person.aadharNo),
                  _KycField('Pan Card No', person.panCardNo),
                ]),
                // Broker Map User List
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Text(
                    'Broker Map User List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade200),
                    columnWidths: const {
                      0: FixedColumnWidth(30),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: primary),
                        children: [
                          _tableHeader('#'),
                          _tableHeader('User Name'),
                          _tableHeader('Phone'),
                          _tableHeader('Clearing Member'),
                        ],
                      ),
                      // Empty state row
                      TableRow(
                        children: [
                          const SizedBox(height: 36),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'No data',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(),
                          const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kycSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: fields),
        ),
      ],
    );
  }

  Widget _tableHeader(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

class _KycField extends StatelessWidget {
  final String label;
  final String value;
  const _KycField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
// divider handled by container
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 148,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                ': ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}

// ─── FORM TAB ─────────────────────────────────────────────────────────────────
class _FormTab extends StatefulWidget {
  const _FormTab();

  @override
  State<_FormTab> createState() => _FormTabState();
}

class _FormTabState extends State<_FormTab> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _bankAccountCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _branchAddrCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _aadharCtrl = TextEditingController();

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBank;
  String _priceAlert = 'No';
  String _memberType = 'Authorized Person';

  final _states = ['Rajasthan', 'Gujarat', 'Maharashtra', 'Uttar Pradesh'];
  final _districts = ['Sikar', 'Jaipur', 'Jodhpur', 'Bikaner'];
  final _banks = [
    'Punjab National Bank',
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
  ];
  final _memberTypes = [
    'Authorized Person',
    'Trading Member',
    'Clearing Member',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _ageCtrl.dispose();
    _pincodeCtrl.dispose();
    _addressCtrl.dispose();
    _bankAccountCtrl.dispose();
    _ifscCtrl.dispose();
    _branchAddrCtrl.dispose();
    _panCtrl.dispose();
    _aadharCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _sectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            children: [
              _row([
                _field(
                  'Authorized Person Name *',
                  _nameCtrl,
                  hint: 'Enter Full Broker Name',
                  required: true,
                ),
                _field(
                  'Email',
                  _emailCtrl,
                  hint: 'Enter Email Id',
                  keyboardType: TextInputType.emailAddress,
                ),
              ]),
              _row([
                _field(
                  'Mobile No *',
                  _mobileCtrl,
                  hint: 'Enter Mobile No',
                  keyboardType: TextInputType.phone,
                  required: true,
                ),
                _field(
                  'Age',
                  _ageCtrl,
                  hint: 'Enter Age',
                  keyboardType: TextInputType.number,
                ),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Address Details',
            icon: Icons.location_on_outlined,
            children: [
              _row([
                _dropdown(
                  'State *',
                  _states,
                  _selectedState,
                  (v) => setState(() => _selectedState = v),
                  required: true,
                ),
                _dropdown(
                  'District *',
                  _districts,
                  _selectedDistrict,
                  (v) => setState(() => _selectedDistrict = v),
                  required: true,
                ),
              ]),
              _row([
                _field(
                  'PinCode *',
                  _pincodeCtrl,
                  hint: 'Enter pincode',
                  keyboardType: TextInputType.number,
                  required: true,
                ),
                _field(
                  'Full Address *',
                  _addressCtrl,
                  hint: 'Enter Full Address',
                  required: true,
                ),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Bank Details',
            icon: Icons.account_balance_outlined,
            children: [
              _row([
                _dropdown(
                  'Bank Name',
                  _banks,
                  _selectedBank,
                  (v) => setState(() => _selectedBank = v),
                ),
                _field(
                  'Bank Account No.',
                  _bankAccountCtrl,
                  hint: 'Enter Bank Account No',
                  keyboardType: TextInputType.number,
                ),
              ]),
              _row([
                _field('Bank IFSC Code', _ifscCtrl, hint: 'Enter IFSC'),
                _field(
                  'Bank Branch Address',
                  _branchAddrCtrl,
                  hint: 'Enter branch_address',
                ),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'KYC Documents',
            icon: Icons.badge_outlined,
            children: [
              _row([
                _field('Pan Card No', _panCtrl, hint: 'Enter PanCard No'),
                _field(
                  'Aadhar Card No',
                  _aadharCtrl,
                  hint: 'Enter Aadhar Card No',
                  keyboardType: TextInputType.number,
                ),
              ]),
              _row([
                _uploadField('Aadhar Image'),
                _uploadField('Pancard Image'),
              ]),
              _row([
                _uploadField('Passport Size Image'),
                _uploadField('Passbook Image'),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Other Settings',
            icon: Icons.settings_outlined,
            children: [
              _row([
                _dropdownStr(
                  'Price Alert WhatsApp *',
                  ['No', 'Yes'],
                  _priceAlert,
                  (v) => setState(() => _priceAlert = v!),
                ),
                _dropdownStr(
                  'Member Type *',
                  _memberTypes,
                  _memberType,
                  (v) => setState(() => _memberType = v!),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Saved successfully!'),
                      backgroundColor: primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Add / Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final primary = Theme.of(context).primaryColor;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(List<Widget> children) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map(
            (w) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: w,
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
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
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    ],
  );

  Widget _dropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    bool required = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        hint: Text(
          'Select',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: required ? (v) => v == null ? 'Required' : null : null,
      ),
    ],
  );

  Widget _dropdownStr(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );

  Widget _uploadField(String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      InkWell(
        onTap: () {        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                Icons.upload_file_outlined,
                size: 16,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Text(
                'Choose File',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class AddAuthorisedPersonPage extends StatelessWidget {
  const AddAuthorisedPersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Authorised Person'),
      ),
      body: const _FormTab(),
    );
  }
}
