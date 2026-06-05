import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Broker'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSent;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @welcomeToBrokerApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Broker App'**
  String get welcomeToBrokerApp;

  /// No description provided for @enterPhoneToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneToContinue;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP sent to'**
  String get enterOtpSentTo;

  /// No description provided for @welcomeToAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appTitle} - Your trusted broker platform'**
  String welcomeToAppDescription(Object appTitle);

  /// No description provided for @brokerServices.
  ///
  /// In en, this message translates to:
  /// **'Broker Services'**
  String get brokerServices;

  /// No description provided for @brokerServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Access various broker services'**
  String get brokerServicesDescription;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with notifications'**
  String get notificationsDescription;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your profile'**
  String get profileDescription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'App settings and preferences'**
  String get settingsDescription;

  /// No description provided for @notificationWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get notificationWelcome;

  /// No description provided for @notificationLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You are logged in!'**
  String get notificationLoggedIn;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @bankInformation.
  ///
  /// In en, this message translates to:
  /// **'Bank Information'**
  String get bankInformation;

  /// No description provided for @availableBanks.
  ///
  /// In en, this message translates to:
  /// **'Available Banks'**
  String get availableBanks;

  /// No description provided for @statusInformation.
  ///
  /// In en, this message translates to:
  /// **'Status Information'**
  String get statusInformation;

  /// No description provided for @uniqueId.
  ///
  /// In en, this message translates to:
  /// **'Unique ID'**
  String get uniqueId;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active Status'**
  String get activeStatus;

  /// No description provided for @approvalStatus.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get approvalStatus;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noBanksAvailable.
  ///
  /// In en, this message translates to:
  /// **'No banks available'**
  String get noBanksAvailable;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @pleaseEnterCompleteOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete 6-digit OTP'**
  String get pleaseEnterCompleteOtp;

  /// No description provided for @otpResentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccessfully;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @truckLoad.
  ///
  /// In en, this message translates to:
  /// **'Truck Load'**
  String get truckLoad;

  /// No description provided for @truckLoadServices.
  ///
  /// In en, this message translates to:
  /// **'Truck Load Services'**
  String get truckLoadServices;

  /// No description provided for @truckLoadServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Handle full truck load bookings and logistics'**
  String get truckLoadServicesDescription;

  /// No description provided for @bestBuyer.
  ///
  /// In en, this message translates to:
  /// **'Best Buyer'**
  String get bestBuyer;

  /// No description provided for @bestSeller.
  ///
  /// In en, this message translates to:
  /// **'Best Seller'**
  String get bestSeller;

  /// No description provided for @sellerPrice.
  ///
  /// In en, this message translates to:
  /// **'Seller Price'**
  String get sellerPrice;

  /// No description provided for @myPrice.
  ///
  /// In en, this message translates to:
  /// **'My Price'**
  String get myPrice;

  /// No description provided for @failedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get failedToSendOtp;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @failedToFetchSbtProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch SBT products'**
  String get failedToFetchSbtProducts;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpiredMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get noInternetConnectionMessage;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get serverErrorMessage;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get networkError;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please try again.'**
  String get requestTimeout;

  /// No description provided for @resourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get resourceNotFound;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please log in again.'**
  String get authenticationFailed;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @tapToPunchOrder.
  ///
  /// In en, this message translates to:
  /// **'Tap to punch order'**
  String get tapToPunchOrder;

  /// No description provided for @stackNo.
  ///
  /// In en, this message translates to:
  /// **'Stack No.'**
  String get stackNo;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @noBids.
  ///
  /// In en, this message translates to:
  /// **'No Bids'**
  String get noBids;

  /// No description provided for @qualityParameters.
  ///
  /// In en, this message translates to:
  /// **'Quality Parameters'**
  String get qualityParameters;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectClient.
  ///
  /// In en, this message translates to:
  /// **'Select Client'**
  String get selectClient;

  /// No description provided for @selectAClient.
  ///
  /// In en, this message translates to:
  /// **'Select a client'**
  String get selectAClient;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceQtl.
  ///
  /// In en, this message translates to:
  /// **'Price (₹/Qtl)'**
  String get priceQtl;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @priceMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get priceMustBeGreaterThanZero;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityQtl.
  ///
  /// In en, this message translates to:
  /// **'Quantity (Qtl)'**
  String get quantityQtl;

  /// No description provided for @qtl.
  ///
  /// In en, this message translates to:
  /// **'Qtl'**
  String get qtl;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// No description provided for @pleaseEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get pleaseEnterQuantity;

  /// No description provided for @quantityMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityMustBeGreaterThanZero;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @submitOrder.
  ///
  /// In en, this message translates to:
  /// **'Submit Order'**
  String get submitOrder;

  /// No description provided for @pleaseSelectAClient.
  ///
  /// In en, this message translates to:
  /// **'Please select a client'**
  String get pleaseSelectAClient;

  /// No description provided for @failedToSubmitBid.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit bid: {error}'**
  String failedToSubmitBid(Object error);

  /// No description provided for @noQualityParametersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No quality parameters available'**
  String get noQualityParametersAvailable;

  /// No description provided for @parameter.
  ///
  /// In en, this message translates to:
  /// **'Parameter'**
  String get parameter;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @areYouSureDeleteBid.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this bid?'**
  String get areYouSureDeleteBid;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @matchedOrders.
  ///
  /// In en, this message translates to:
  /// **'Matched Orders'**
  String get matchedOrders;

  /// No description provided for @noMatchedOrders.
  ///
  /// In en, this message translates to:
  /// **'No matched orders available'**
  String get noMatchedOrders;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @pendingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Pending Quantity'**
  String get pendingQuantity;

  /// No description provided for @deliveryCenters.
  ///
  /// In en, this message translates to:
  /// **'Delivery Centers'**
  String get deliveryCenters;

  /// No description provided for @viewImage.
  ///
  /// In en, this message translates to:
  /// **'View Image'**
  String get viewImage;

  /// No description provided for @viewVideo.
  ///
  /// In en, this message translates to:
  /// **'View Video'**
  String get viewVideo;

  /// No description provided for @charges.
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get charges;

  /// No description provided for @locate.
  ///
  /// In en, this message translates to:
  /// **'Locate'**
  String get locate;

  /// No description provided for @stackSellBidding.
  ///
  /// In en, this message translates to:
  /// **'Stack Sell Bidding'**
  String get stackSellBidding;

  /// No description provided for @videoPlayer.
  ///
  /// In en, this message translates to:
  /// **'Video Player'**
  String get videoPlayer;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @terminalName.
  ///
  /// In en, this message translates to:
  /// **'Terminal Name : {name}'**
  String terminalName(Object name);

  /// No description provided for @commodityLabel.
  ///
  /// In en, this message translates to:
  /// **'Commodity : {commodity}'**
  String commodityLabel(Object commodity);

  /// No description provided for @warehouseAddress.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Address : {address}'**
  String warehouseAddress(Object address);

  /// No description provided for @sellerPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Seller price (Rs):- {price}'**
  String sellerPriceLabel(Object price);

  /// No description provided for @addBid.
  ///
  /// In en, this message translates to:
  /// **'Add Bid'**
  String get addBid;

  /// No description provided for @bidHistory.
  ///
  /// In en, this message translates to:
  /// **'Bid History'**
  String get bidHistory;

  /// No description provided for @yourBid.
  ///
  /// In en, this message translates to:
  /// **'Your Bid'**
  String get yourBid;

  /// No description provided for @myBid.
  ///
  /// In en, this message translates to:
  /// **'My Bid'**
  String get myBid;

  /// No description provided for @enterYourBidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Bid Amount'**
  String get enterYourBidAmount;

  /// No description provided for @enterBidAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter bid amount (₹)'**
  String get enterBidAmountHint;

  /// No description provided for @pleaseEnterBidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter bid amount'**
  String get pleaseEnterBidAmount;

  /// No description provided for @bidAmountMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Bid amount must be greater than zero'**
  String get bidAmountMustBeGreaterThanZero;

  /// No description provided for @submitBid.
  ///
  /// In en, this message translates to:
  /// **'Submit Bid'**
  String get submitBid;

  /// No description provided for @bidsHistory.
  ///
  /// In en, this message translates to:
  /// **'Bids History'**
  String get bidsHistory;

  /// No description provided for @commodity.
  ///
  /// In en, this message translates to:
  /// **'Commodity'**
  String get commodity;

  /// No description provided for @dealQty.
  ///
  /// In en, this message translates to:
  /// **'Deal Qty'**
  String get dealQty;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @noBuyDeals.
  ///
  /// In en, this message translates to:
  /// **'No Buy Deals'**
  String get noBuyDeals;

  /// No description provided for @noSellDeals.
  ///
  /// In en, this message translates to:
  /// **'No Sell Deals'**
  String get noSellDeals;

  /// No description provided for @yourBuyDealsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your buy deals will appear here'**
  String get yourBuyDealsWillAppearHere;

  /// No description provided for @yourSellDealsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your sell deals will appear here'**
  String get yourSellDealsWillAppearHere;

  /// No description provided for @errorLoadingBids.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Bids'**
  String get errorLoadingBids;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @quintal.
  ///
  /// In en, this message translates to:
  /// **'Qt'**
  String get quintal;

  /// No description provided for @orderMatching.
  ///
  /// In en, this message translates to:
  /// **'Order Matching Date'**
  String get orderMatching;

  /// No description provided for @brokerageProfile.
  ///
  /// In en, this message translates to:
  /// **'Brokerage Profile'**
  String get brokerageProfile;

  /// No description provided for @noBrokerageInformationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No brokerage information available.'**
  String get noBrokerageInformationAvailable;

  /// No description provided for @failedToFetchBrokerage.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch brokerage'**
  String get failedToFetchBrokerage;

  /// No description provided for @failedToSubmitBuyOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit buy order: {error}'**
  String failedToSubmitBuyOrder(Object error);

  /// No description provided for @failedToSubmitSellOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit sell order: {error}'**
  String failedToSubmitSellOrder(Object error);

  /// No description provided for @editBid.
  ///
  /// In en, this message translates to:
  /// **'Edit Bid'**
  String get editBid;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @failedToConnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect'**
  String get failedToConnect;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Print failed'**
  String get printFailed;

  /// No description provided for @printJobSent.
  ///
  /// In en, this message translates to:
  /// **'Print job sent'**
  String get printJobSent;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @selectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Select Printer'**
  String get selectPrinter;

  /// No description provided for @tradeSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Trade saved successfully'**
  String get tradeSavedSuccessfully;

  /// No description provided for @bidEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Bid edited successfully'**
  String get bidEditedSuccessfully;

  /// No description provided for @walletStatement.
  ///
  /// In en, this message translates to:
  /// **'Wallet Statement'**
  String get walletStatement;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening Balance'**
  String get openingBalance;

  /// No description provided for @closingBalance.
  ///
  /// In en, this message translates to:
  /// **'Closing Balance'**
  String get closingBalance;

  /// No description provided for @noTransactionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No transactions available'**
  String get noTransactionsAvailable;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @narration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get narration;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @withdrawalRequest.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Request'**
  String get withdrawalRequest;

  /// No description provided for @withdrawalHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal History'**
  String get withdrawalHistory;

  /// No description provided for @withdrawalAmount.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Amount'**
  String get withdrawalAmount;

  /// No description provided for @enterWithdrawalInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you wish to withdraw from your wallet'**
  String get enterWithdrawalInfo;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @viewWithdrawalHistory.
  ///
  /// In en, this message translates to:
  /// **'View Withdrawal History'**
  String get viewWithdrawalHistory;

  /// No description provided for @noWithdrawalRequests.
  ///
  /// In en, this message translates to:
  /// **'No Withdrawal Requests'**
  String get noWithdrawalRequests;

  /// No description provided for @withdrawalDetails.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Details'**
  String get withdrawalDetails;

  /// No description provided for @requestedAmount.
  ///
  /// In en, this message translates to:
  /// **'Requested Amount'**
  String get requestedAmount;

  /// No description provided for @wrr.
  ///
  /// In en, this message translates to:
  /// **'WRR'**
  String get wrr;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @approvedAmount.
  ///
  /// In en, this message translates to:
  /// **'Approved Amount'**
  String get approvedAmount;

  /// No description provided for @requestedDate.
  ///
  /// In en, this message translates to:
  /// **'Requested Date'**
  String get requestedDate;

  /// No description provided for @approvedDate.
  ///
  /// In en, this message translates to:
  /// **'Approved Date'**
  String get approvedDate;

  /// No description provided for @remark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get remark;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get statusProcessed;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @amountMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountMustBeGreaterThanZero;

  /// No description provided for @withdrawalRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted successfully'**
  String get withdrawalRequestSubmitted;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @lpClientList.
  ///
  /// In en, this message translates to:
  /// **'Broker Client List'**
  String get lpClientList;

  /// No description provided for @lpClients.
  ///
  /// In en, this message translates to:
  /// **'Broker Clients'**
  String get lpClients;

  /// No description provided for @addLpClient.
  ///
  /// In en, this message translates to:
  /// **'Add Broker Client'**
  String get addLpClient;

  /// No description provided for @constitution.
  ///
  /// In en, this message translates to:
  /// **'Constitution'**
  String get constitution;

  /// No description provided for @constitutionRequired.
  ///
  /// In en, this message translates to:
  /// **'Constitution is required'**
  String get constitutionRequired;

  /// No description provided for @enterConstitutionNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter constitution number'**
  String get enterConstitutionNumber;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @enterClientName.
  ///
  /// In en, this message translates to:
  /// **'Enter client name'**
  String get enterClientName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneRequired;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneMustBe10Digits.
  ///
  /// In en, this message translates to:
  /// **'Phone must be 10 digits'**
  String get phoneMustBe10Digits;

  /// No description provided for @bidStatus.
  ///
  /// In en, this message translates to:
  /// **'Bid Status'**
  String get bidStatus;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @documentsOptional.
  ///
  /// In en, this message translates to:
  /// **'Documents (Optional)'**
  String get documentsOptional;

  /// No description provided for @aadharFront.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Front'**
  String get aadharFront;

  /// No description provided for @aadharBack.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Back'**
  String get aadharBack;

  /// No description provided for @panCard.
  ///
  /// In en, this message translates to:
  /// **'PAN Card'**
  String get panCard;

  /// No description provided for @gstCertificate.
  ///
  /// In en, this message translates to:
  /// **'GST Certificate/ Bill'**
  String get gstCertificate;

  /// No description provided for @imageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image selected'**
  String get imageSelected;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(Object error);

  /// No description provided for @clientAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client added successfully!'**
  String get clientAddedSuccessfully;

  /// No description provided for @failedToAddClient.
  ///
  /// In en, this message translates to:
  /// **'Failed to add client'**
  String get failedToAddClient;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @pan.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get pan;

  /// No description provided for @aadhar.
  ///
  /// In en, this message translates to:
  /// **'Aadhar'**
  String get aadhar;

  /// No description provided for @gst.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get gst;

  /// No description provided for @approvedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved By'**
  String get approvedBy;

  /// No description provided for @verifiedBy.
  ///
  /// In en, this message translates to:
  /// **'Verified By'**
  String get verifiedBy;

  /// No description provided for @selectConstitution.
  ///
  /// In en, this message translates to:
  /// **'Select Constitution'**
  String get selectConstitution;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @proprietorship.
  ///
  /// In en, this message translates to:
  /// **'Proprietorship'**
  String get proprietorship;

  /// No description provided for @partnership.
  ///
  /// In en, this message translates to:
  /// **'Partnership'**
  String get partnership;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
