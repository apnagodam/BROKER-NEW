import 'dart:ui';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart';
import 'package:ag_broker/domain/entities/deals_model.dart';
import 'package:ag_broker/domain/entities/quality_params_model.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/bids_repository.dart';

class BidsRepositoryImpl extends BidsRepository {
  final DioClient _dioClient;

  BidsRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);

  @override
  Future<TradeListModel> getTradeList(String productId) async {
    try {
      final response = await _dioClient.dio.get(
        Constants.getTradeList,
        queryParameters: {"product_id": productId},
      );
      return TradeListModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch Trade List: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBuySellTerms(
    String productId,
    String userType,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        Constants.buySellTerms,
        queryParameters: {"product_id": productId, "user_type": userType},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch Buy Sell Terms: $e');
    }
  }

  @override
  Future<ClientListModel> getClientList() async {
    try {
      final response = await _dioClient.dio.get(Constants.getClientList);
      return ClientListModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch Client List: $e');
    }
  }

  @override
  Future<QualityParamsModel> getQualityParams(String productId) async {
    try {
      final response = await _dioClient.dio.post(
        Constants.getQualityParams,
        queryParameters: {"product_id": productId},
      );
      return QualityParamsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch Client List: $e');
    }
  }

  @override
  Future<DealsModel> getDealsList() async {
    try {
      final response = await _dioClient.dio.post(Constants.dealsHistory);
      return DealsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch Deals List: $e');
    }
  }
}
