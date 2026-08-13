import 'package:ag_broker/domain/entities/running_deal_model.dart';
import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';

abstract class StackRepository {
  Future<StackSellModel> getStackSellList();
  Future<Map<String, dynamic>> postStackBid({
    required String stackId,
    required String price,
    required String userId,
  });

  Future<Map<String, dynamic>> getStackSellTerms();

  Future<RunningDealsResponse> getRunningDeals();
  Future<RunningDealsResponse> getDeliveredDeals();
  Future<Map<String, dynamic>> getOrderOutwardRequest(String orderId);
  Future<Map<String, dynamic>> postBuyerOutwardRequest({
    required String orderId,
    required String truckNumber,
    required String driverNumber,
    required String weight,
  });
  Future<Map<String, dynamic>> rejectOutwardRequest(String requestId);
  Future<void> saveAccessLog(String pageName);
}
