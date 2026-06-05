import 'package:ag_broker/domain/entities/client_list_model.dart';
import 'package:ag_broker/domain/entities/deals_model.dart';
import 'package:ag_broker/domain/entities/quality_params_model.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';

abstract class BidsRepository {
  Future<TradeListModel> getTradeList(String productId);

  Future<Map<String, dynamic>> getBuySellTerms(
    String productId,
    String userType,
  );
  Future<ClientListModel> getClientList();
  Future<QualityParamsModel> getQualityParams(String productId);

  Future<DealsModel> getDealsList();
}
