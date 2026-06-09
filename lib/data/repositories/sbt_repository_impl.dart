
import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/domain/entities/delivery_centers_model.dart';
import 'package:ag_broker/domain/entities/matched_orders_model.dart';
import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/sbt_repository.dart';
import 'package:flutter/material.dart';

class SbtRepositoryImpl implements SbtRepository {
  final DioClient _dioClient;

  SbtRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);

  @override
  Future<SbtProductResponse> getSbtProducts() async {
    try {
      final response = await _dioClient.dio.get(Constants.sbtProducts);
      return SbtProductResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch SBT products: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> saveTrade(
    String productId,
    String districtId,
    String commodity,
    String qty,
    String type,
    String price,
    String userId,
  ) async {
    try { 
      final response = await _dioClient.dio.post(
        Constants.saveTrade,
        queryParameters: {
          "product_id": productId,
          "district_id": districtId,
          "commodity": commodity,
          "qty": qty,
          "type": type,
          "price": price,
          "user_id": userId,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch SBT products: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteBid(String orderId) async {
    try {
      final response = await _dioClient.dio.get(
        Constants.deleteBid,
        queryParameters: {"order_id": orderId},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch SBT products: $e');
    }
  }

  @override
  Future<DeliveryCentersModel> getDeliveryCenters(String productId) {
    try {
      return _dioClient.dio
          .post(
            Constants.getDelieryCenters,
            queryParameters: {"product_id": productId},
          )
          .then((response) {
            return DeliveryCentersModel.fromJson(response.data);
          });
    } catch (e) {
      throw Exception('Failed to fetch delivery centers: $e');
    }
  }

  @override
  Future<SbtMatchedOrderResponse> getMatchedOrders(String productId) async {
    try {
      final response = await _dioClient.dio.post(
        Constants.getMatchedOrders,
        queryParameters: {"product_id": productId},
      );
      return SbtMatchedOrderResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch matched orders: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> editBid({
    String? productId,
    String? districtId,
    String? commodity,
    String? qty,
    String? type,
    String? price,
    String? tradeId,
    String? userId,
  }) async {
    try {
      var response = await _dioClient.dio.post(
        Constants.editBid,
        queryParameters: {
          "product_id": productId,
          "district_id": districtId,
          "commodity": commodity,
          "qty": qty,
          "type": type,
          "price": price,
          "trade_id": tradeId,
          "user_id": userId,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to edit bid: $e');
    }
  }

  @override
  Future<TradeListModel> fetchTradeList(String productId) async {
    try {
      var response = await _dioClient.dio.post(
        Constants.getTradeList,
        queryParameters: {"product_id": productId},

      );
      return TradeListModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to edit bid: $e');
    }
  }
}
