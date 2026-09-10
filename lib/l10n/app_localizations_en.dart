// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Broker';

  @override
  String get login => 'Login';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get verify => 'Verify';

  @override
  String get home => 'Home';

  @override
  String get welcome => 'Welcome';

  @override
  String get logout => 'Logout';

  @override
  String get otpSent => 'OTP sent successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get welcomeToBrokerApp => 'Welcome to Broker App';

  @override
  String get enterPhoneToContinue => 'Enter your phone number to continue';

  @override
  String get enterOtpSentTo => 'Enter the 6-digit OTP sent to';

  @override
  String welcomeToAppDescription(Object appTitle) {
    return 'Welcome to $appTitle - Your trusted broker platform';
  }

  @override
  String get brokerServices => 'Broker Services';

  @override
  String get brokerServicesDescription => 'Access various broker services';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDescription => 'Stay updated with notifications';

  @override
  String get profile => 'Profile';

  @override
  String get profileDescription => 'Manage your profile';

  @override
  String get settings => 'Settings';

  @override
  String get settingsDescription => 'App settings and preferences';

  @override
  String get notificationWelcome => 'Welcome';

  @override
  String get notificationLoggedIn => 'You are logged in!';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get bankInformation => 'Bank Information';

  @override
  String get availableBanks => 'Available Banks';

  @override
  String get statusInformation => 'Status Information';

  @override
  String get uniqueId => 'Unique ID';

  @override
  String get email => 'Email';

  @override
  String get age => 'Age';

  @override
  String get address => 'Address';

  @override
  String get bankName => 'Bank Name';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get activeStatus => 'Active Status';

  @override
  String get approvalStatus => 'Approval Status';

  @override
  String get verificationStatus => 'Verification Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get approved => 'Approved';

  @override
  String get pending => 'Pending';

  @override
  String get verified => 'Verified';

  @override
  String get unverified => 'Unverified';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get noBanksAvailable => 'No banks available';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिंदी';

  @override
  String get pleaseEnterCompleteOtp => 'Please enter complete 6-digit OTP';

  @override
  String get otpResentSuccessfully => 'OTP resent successfully';

  @override
  String get delivery => 'Delivery';

  @override
  String get truckLoad => 'Truck Load';

  @override
  String get truckLoadServices => 'Truck Load Services';

  @override
  String get truckLoadServicesDescription =>
      'Handle full truck load bookings and logistics';

  @override
  String get bestBuyer => 'Best Buyer';

  @override
  String get bestSeller => 'Best Seller';

  @override
  String get sellerPrice => 'Seller Price';

  @override
  String get myPrice => 'My Price';

  @override
  String get failedToSendOtp => 'Failed to send OTP';

  @override
  String get verificationFailed => 'Verification failed';

  @override
  String get failedToFetchSbtProducts => 'Failed to fetch SBT products';

  @override
  String get order => 'Order';

  @override
  String get pleaseEnterValidPhoneNumber =>
      'Please enter a valid 10-digit phone number';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get sessionExpired => 'Session Expired';

  @override
  String get sessionExpiredMessage =>
      'Your session has expired. Please log in again.';

  @override
  String get ok => 'OK';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get noInternetConnectionMessage =>
      'Please check your internet connection and try again.';

  @override
  String get serverError => 'Server Error';

  @override
  String get serverErrorMessage =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get networkError =>
      'No internet connection. Please check your network settings.';

  @override
  String get requestTimeout => 'Request timeout. Please try again.';

  @override
  String get resourceNotFound => 'Resource not found.';

  @override
  String get authenticationFailed =>
      'Authentication failed. Please log in again.';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get tapToPunchOrder => 'Tap to punch order';

  @override
  String get stackNo => 'Stack No.';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get buyer => 'Buyer';

  @override
  String get seller => 'Seller';

  @override
  String get noBids => 'No Bids';

  @override
  String get qualityParameters => 'Quality Parameters';

  @override
  String get product => 'Product';

  @override
  String get date => 'Date';

  @override
  String get selectClient => 'Select Client';

  @override
  String get selectAClient => 'Select a client';

  @override
  String get unknown => 'Unknown';

  @override
  String get price => 'Price';

  @override
  String get priceQtl => 'Price (₹/Qtl)';

  @override
  String get enterPrice => 'Enter price';

  @override
  String get pleaseEnterPrice => 'Please enter price';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get priceMustBeGreaterThanZero => 'Price must be greater than 0';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantityQtl => 'Quantity (Qtl)';

  @override
  String get qtl => 'Qtl';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get pleaseEnterQuantity => 'Please enter quantity';

  @override
  String get quantityMustBeGreaterThanZero => 'Quantity must be greater than 0';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get submitOrder => 'Submit Order';

  @override
  String get pleaseSelectAClient => 'Please select a client';

  @override
  String failedToSubmitBid(Object error) {
    return 'Failed to submit bid: $error';
  }

  @override
  String get noQualityParametersAvailable => 'No quality parameters available';

  @override
  String get parameter => 'Parameter';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get areYouSureDeleteBid => 'Are you sure you want to delete this bid?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get matchedOrders => 'Matched Orders';

  @override
  String get noMatchedOrders => 'No matched orders available';

  @override
  String get orderId => 'Order ID';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get rate => 'Rate';

  @override
  String get pendingQuantity => 'Pending Quantity';

  @override
  String get deliveryCenters => 'Delivery Centers';

  @override
  String get viewImage => 'View Image';

  @override
  String get viewVideo => 'View Video';

  @override
  String get charges => 'Charges';

  @override
  String get locate => 'Locate';

  @override
  String get stackSellBidding => 'Stack Sell Bidding';

  @override
  String get videoPlayer => 'Video Player';

  @override
  String get goBack => 'Go Back';

  @override
  String terminalName(Object name) {
    return 'Terminal Name : $name';
  }

  @override
  String commodityLabel(Object commodity) {
    return 'Commodity : $commodity';
  }

  @override
  String warehouseAddress(Object address) {
    return 'Warehouse Address : $address';
  }

  @override
  String sellerPriceLabel(Object price) {
    return 'Seller price (Rs):- $price';
  }

  @override
  String get addBid => 'Add Bid';

  @override
  String get bidHistory => 'Bid History';

  @override
  String get yourBid => 'Your Bid';

  @override
  String get myBid => 'My Bid';

  @override
  String get enterYourBidAmount => 'Enter Your Bid Amount';

  @override
  String get enterBidAmountHint => 'Enter bid amount (₹)';

  @override
  String get pleaseEnterBidAmount => 'Please enter bid amount';

  @override
  String get bidAmountMustBeGreaterThanZero =>
      'Bid amount must be greater than zero';

  @override
  String get submitBid => 'Submit Bid';

  @override
  String get bidsHistory => 'Bids History';

  @override
  String get commodity => 'Commodity';

  @override
  String get dealQty => 'Deal Qty';

  @override
  String get delivered => 'Delivered';

  @override
  String get noBuyDeals => 'No Buy Deals';

  @override
  String get noSellDeals => 'No Sell Deals';

  @override
  String get yourBuyDealsWillAppearHere => 'Your buy deals will appear here';

  @override
  String get yourSellDealsWillAppearHere => 'Your sell deals will appear here';

  @override
  String get errorLoadingBids => 'Error Loading Bids';

  @override
  String get notAvailable => 'N/A';

  @override
  String get quintal => 'Qt';

  @override
  String get orderMatching => 'Order Matching Date';

  @override
  String get brokerageProfile => 'Brokerage Profile';

  @override
  String get noBrokerageInformationAvailable =>
      'No brokerage information available.';

  @override
  String get failedToFetchBrokerage => 'Failed to fetch brokerage';

  @override
  String failedToSubmitBuyOrder(Object error) {
    return 'Failed to submit buy order: $error';
  }

  @override
  String failedToSubmitSellOrder(Object error) {
    return 'Failed to submit sell order: $error';
  }

  @override
  String get editBid => 'Edit Bid';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get failedToConnect => 'Failed to connect';

  @override
  String get failedToLoadImage => 'Failed to load image';

  @override
  String get print => 'Print';

  @override
  String get printFailed => 'Print failed';

  @override
  String get printJobSent => 'Print job sent';

  @override
  String get scan => 'Scan';

  @override
  String get selectPrinter => 'Select Printer';

  @override
  String get tradeSavedSuccessfully => 'Trade saved successfully';

  @override
  String get bidEditedSuccessfully => 'Bid edited successfully';

  @override
  String get walletStatement => 'Brokerage Wallet Statement';

  @override
  String get openingBalance => 'Opening Balance';

  @override
  String get closingBalance => 'Closing Balance';

  @override
  String get noTransactionsAvailable => 'No transactions available';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get label => 'Label';

  @override
  String get referenceNumber => 'Reference Number';

  @override
  String get balance => 'Balance';

  @override
  String get narration => 'Narration';

  @override
  String get amount => 'Amount';

  @override
  String get withdrawalRequest => 'Withdrawal Request';

  @override
  String get withdrawalHistory => 'Withdrawal History';

  @override
  String get withdrawalAmount => 'Withdrawal Amount';

  @override
  String get enterWithdrawalInfo =>
      'Enter the amount you wish to withdraw from your wallet';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get viewWithdrawalHistory => 'View Withdrawal History';

  @override
  String get noWithdrawalRequests => 'No Withdrawal Requests';

  @override
  String get withdrawalDetails => 'Withdrawal Details';

  @override
  String get requestedAmount => 'Requested Amount';

  @override
  String get wrr => 'WRR';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get branch => 'Branch';

  @override
  String get approvedAmount => 'Approved Amount';

  @override
  String get requestedDate => 'Requested Date';

  @override
  String get approvedDate => 'Approved Date';

  @override
  String get remark => 'Remark';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusProcessed => 'Processed';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get pleaseEnterAmount => 'Please enter amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get withdrawalRequestSubmitted =>
      'Withdrawal request submitted successfully';

  @override
  String get power => 'Power';

  @override
  String get fromDate => 'From Date';

  @override
  String get toDate => 'To Date';

  @override
  String get lpClientList => 'Broker Client List';

  @override
  String get lpClients => 'Broker Clients';

  @override
  String get addLpClient => 'Add Broker Client';

  @override
  String get constitution => 'Constitution';

  @override
  String get constitutionRequired => 'Constitution is required';

  @override
  String get enterConstitutionNumber => 'Enter constitution number';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get enterClientName => 'Enter client name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get phoneMustBe10Digits => 'Phone must be 10 digits';

  @override
  String get bidStatus => 'Bid Status';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get documentsOptional => 'Documents (Optional)';

  @override
  String get aadharFront => 'Aadhar Front';

  @override
  String get aadharBack => 'Aadhar Back';

  @override
  String get panCard => 'PAN Card';

  @override
  String get gstCertificate => 'GST Certificate/ Bill';

  @override
  String get imageSelected => 'Image selected';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get addClient => 'Add Client';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String errorPickingImage(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String get clientAddedSuccessfully => 'Client added successfully!';

  @override
  String get failedToAddClient => 'Failed to add client';

  @override
  String get userId => 'User ID';

  @override
  String get pan => 'PAN';

  @override
  String get aadhar => 'Aadhar';

  @override
  String get gst => 'GST';

  @override
  String get approvedBy => 'Approved By';

  @override
  String get verifiedBy => 'Verified By';

  @override
  String get selectConstitution => 'Select Constitution';

  @override
  String get individual => 'Individual';

  @override
  String get proprietorship => 'Proprietorship';

  @override
  String get partnership => 'Partnership';

  @override
  String get company => 'Company';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get myClientDeals => 'My Client Deals';

  @override
  String get runningDeals => 'Running Deals';

  @override
  String get deliveredDeals => 'Delivered Deals';

  @override
  String get members => 'Members';

  @override
  String get authorisedPerson => 'Authorised Person';

  @override
  String get tradingMember => 'Trading Member';

  @override
  String get addSecurity => 'Add Security';

  @override
  String get tmFees => 'TM Fees';

  @override
  String get marginFunding => 'Margin Funding';

  @override
  String get schemes => 'Schemes';

  @override
  String get marginFundingLimit => 'Margin Funding Limit';

  @override
  String get marginFundingRequest => 'Margin Funding Request';

  @override
  String get wallet => 'Wallet';

  @override
  String get tradePowerStatement => 'Trade Power Statement';

  @override
  String get sbtProduct => 'SBT Product';

  @override
  String get sbtSecureProduct => 'SBT Secure Product';

  @override
  String get sbtUnsecureProduct => 'SBT Unsecure Product';

  @override
  String get client => 'Client';

  @override
  String get outwardRequest => 'Outward Request';

  @override
  String get rejectOutward => 'Reject Outward';

  @override
  String get truckNo => 'Truck No.';

  @override
  String get driverNo => 'Driver No.';

  @override
  String get deliveryDaysLabel => 'Delivery Days';

  @override
  String get pendingQty => 'Pending (Qtl.)';

  @override
  String get deliveredQty => 'Delivered (Qtl.)';

  @override
  String get weightQtl => 'Weight (Qtl.)';

  @override
  String get priceRupees => 'Price (₹)';

  @override
  String get matchDate => 'Match Date';

  @override
  String get noRunningDeals => 'No running deals available';

  @override
  String get noDeliveredDeals => 'No delivered deals available';

  @override
  String get buyDeal => 'BUY';

  @override
  String get sellDeal => 'SELL';

  @override
  String get buyerClient => 'Buyer';

  @override
  String get sellerClient => 'Seller';

  @override
  String get tapToPlaceOrder => 'Tap to place order';

  @override
  String get stackNoWithDash => 'Stack No.-';

  @override
  String get stackSellBid => 'Stack Sell Bid';

  @override
  String get quantityQuintal => 'Quantity (Qtl)';

  @override
  String get highestBuyer => 'Best Buyer';

  @override
  String get sellerPriceTitle => 'Seller Price';

  @override
  String get noBidHistoryAvailable => 'No bid history available';

  @override
  String get factoryDelivery => 'Factory Delivery';

  @override
  String get warehouseDelivery => 'Warehouse Delivery';
}
