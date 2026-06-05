import 'package:ag_broker/domain/entities/delivery_centers_model.dart';
import 'package:ag_broker/domain/entities/matched_orders_model.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';

import '../../domain/entities/sbt_product.dart';

abstract class SbtRepository {
  Future<SbtProductResponse> getSbtProducts();

  Future<Map<String, dynamic>> saveTrade(
    String productId,
    String districtId,
    String commodity,
    String qty,
    String type,
    String price,
    String userId,
  );

  Future<Map<String, dynamic>> deleteBid(String orderId);

  Future<DeliveryCentersModel> getDeliveryCenters(String productId);

  Future<SbtMatchedOrderResponse> getMatchedOrders(String productId);

  Future<Map<String, dynamic>> editBid({
    String? productId,
    String? districtId,
    String? commodity,
    String? qty,
    String? type,
    String? price,
    String? tradeId,
    String? userId,
  });

  Future<TradeListModel> fetchTradeList(String productId);
}
