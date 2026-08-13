class Constants {
  static const String appName = 'Broker';
  static const String apiBaseUrl = 'https://apnagodam.com/';
  static const String testApiBaseUrl = 'https://demoaws.apnagodam.com/';

  //Auth Endpoints
  static const String sendOtp = 'api/apna_send_otp';
  static const String verifyOtp = 'api/apna_verify_otp';
  static const String getBrokerage = 'lp_api/apna_lp_brokerage';
  static const String getUserDetails = 'lp_api/apna_lp_user_details';

  //SBT Endpoints
  static const String sbtProducts = 'lp_api/apna_lp_sbt_product_list';

  static const String getTradeList = 'lp_api/sbt_trade_list';
  static const String buySellTerms = 'lp_api/sbt_factory_terms';

  static const String getClientList = 'lp_api/get_buyer_seller_list';
  static const String getMatchedOrders = 'lp_api/sbt_trade_order_list';
  static const String getQualityParams = 'lp_api/product-quality-parameter';

  static const String saveTrade = 'lp_api/sbt_trade_save';

  static const String deleteBid = 'lp_api/sbt_trade_order_cancelled';

  static const String getDelieryCenters = 'lp_api/product-delivery-center';
  static const String editBid = 'lp_api/sbt_trade_edit';

  //stack endpoints
  static const String stackSellList = 'lp_api/apna_lp_stack_sell_list';
  static const String postStackBid =
      'lp_api/v1_apna_lp_update_bid'; //'lp_api/v1_apna_lp_update_bid';
  static const String stackSellTerms = 'lp_api/get_stack_sell_terms';

  //deals endpoints
  static const String dealsHistory = '/lp_api/apna_lp_deals';

  //wallet endpoints
  static const String walletStatement = 'lp_api/apna_lp_wallet_statement';
  static const String withdrawRequest = 'lp_api/apna_lp_withdrawal_request';
  static const String getWithdrawList = 'lp_api/get_apna_lp_withdrawal_request';

  //LP Client endpoints
  static const String lpClientList = 'lp_api/apna_lp_client_list';
  static const String addLpClient = 'lp_api/apna_lp_add_client';

  //Outward & Deals Endpoints
  static const String runningDeals = 'lp_api/brokerRunningDeals';
  static const String deliveredDeals = 'lp_api/lp-delivered-deals';
  static const String orderOutwardRequest = 'lp_api/getBrokerOutWardRequest';
  static const String buyerOutwardRequest = 'lp_api/brokerOutWardRequest';
  static const String rejectOutwardRequest = 'lp_api/rejectBrokerOutWardRequest';
  static const String saveAccessLog = 'lp_api/save_access_log';
}
