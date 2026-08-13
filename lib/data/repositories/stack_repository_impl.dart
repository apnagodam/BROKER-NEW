import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/domain/entities/running_deal_model.dart';
import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/domain/repositories/stack_repository.dart';

class StackRepositoryImpl extends StackRepository {
  final DioClient _dioClient;

  StackRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);
  @override
  Future<StackSellModel> getStackSellList() async {
    var response = await _dioClient.dio.get(Constants.stackSellList);
    return StackSellModel.fromMap(response.data);
  }

  @override
  Future<Map<String, dynamic>> postStackBid({
    required String stackId,
    required String price,
    required String userId,
  }) async {
    var response = await _dioClient.dio.post(
      Constants.postStackBid,
      data: {'stack_id': stackId, 'price': price, 'user_id': userId},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getStackSellTerms() async {
    var response = await _dioClient.dio.post(Constants.stackSellTerms);
    return response.data;
  }

  @override
  Future<RunningDealsResponse> getRunningDeals() async {
    final endpoints = [
      Constants.runningDeals,
      'lp-running-deals',
      'api/lp-running-deals',
      Constants.dealsHistory,
    ];

    for (var endpoint in endpoints) {
      try {
        var response = await _dioClient.dio.request(
          endpoint,
          options: Options(
            method: endpoint == Constants.dealsHistory ? 'POST' : 'GET',
          ),
        );
        if (response.data != null) {
          return RunningDealsResponse.fromJson(response.data);
        }
      } catch (e) {
        debugPrint("Endpoint $endpoint failed: $e");
      }
    }
    return RunningDealsResponse(data: []);
  }

  @override
  Future<RunningDealsResponse> getDeliveredDeals() async {
    final endpoints = [
      Constants.deliveredDeals,
      'lp-delivered-deals',
      'api/lp-delivered-deals',
      Constants.dealsHistory,
    ];

    for (var endpoint in endpoints) {
      try {
        var response = await _dioClient.dio.request(
          endpoint,
          options: Options(
            method: endpoint == Constants.dealsHistory ? 'POST' : 'GET',
          ),
        );
        if (response.data != null) {
          return RunningDealsResponse.fromJson(response.data);
        }
      } catch (e) {
        debugPrint("Endpoint $endpoint failed: $e");
      }
    }
    return RunningDealsResponse(data: []);
  }

  @override
  Future<Map<String, dynamic>> getOrderOutwardRequest(String orderId) async {
    final endpoints = [
      Constants.orderOutwardRequest,
      'getBrokerOutWardRequest',
      'lp-order-outward-request',
      'api/getBrokerOutWardRequest',
    ];

    for (var endpoint in endpoints) {
      try {
        var response = await _dioClient.dio.get(
          endpoint,
          queryParameters: {'OutWardOrderId': orderId, 'order_id': orderId},
        );
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(response.data);
          }
          return {'status': '1', 'Data': response.data};
        }
      } catch (e) {
        debugPrint("Endpoint $endpoint GET failed: $e");
        try {
          var postResponse = await _dioClient.dio.post(
            endpoint,
            data: {'OutWardOrderId': orderId, 'order_id': orderId},
          );
          if (postResponse.data != null && postResponse.data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(postResponse.data);
          }
        } catch (_) {}
      }
    }
    return {'status': '0', 'message': 'Not found'};
  }

  @override
  Future<Map<String, dynamic>> postBuyerOutwardRequest({
    required String orderId,
    required String truckNumber,
    required String driverNumber,
    required String weight,
  }) async {
    final endpoints = [
      Constants.buyerOutwardRequest,
      'brokerOutWardRequest',
      'lp-buyer-outward-request',
      'api/brokerOutWardRequest',
    ];

    for (var endpoint in endpoints) {
      try {
        var response = await _dioClient.dio.post(
          endpoint,
          data: {
            'OrderId': orderId,
            'truckNumber': truckNumber,
            'driverNumber': driverNumber,
            'outwardWeight': weight,
            'order_id': orderId,
            'truck_number': truckNumber,
            'driver_number': driverNumber,
            'weight': weight,
          },
        );
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(response.data);
          }
          return {
            'status': '1',
            'message': 'आउटवर्ड रिक्वेस्ट सफलतापूर्वक भेज दी गई है।'
          };
        }
      } catch (e) {
        debugPrint("Endpoint $endpoint failed: $e");
      }
    }
    return {
      'status': '0',
      'message': 'Failed to submit outward request. Please try again.'
    };
  }

  @override
  Future<Map<String, dynamic>> rejectOutwardRequest(String requestId) async {
    final endpoints = [
      Constants.rejectOutwardRequest,
      'rejectBrokerOutWardRequest',
      'lp_api/rejectBrokerOutWardRequest',
    ];

    for (var endpoint in endpoints) {
      try {
        var response = await _dioClient.dio.post(
          endpoint,
          data: {
            'requestId': requestId,
            'request_id': requestId,
            'id': requestId,
          },
        );
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(response.data);
          }
          return {
            'status': '1',
            'message': 'आउटवर्ड रिक्वेस्ट सफलतापूर्वक अस्वीकार कर दी गई है।',
          };
        }
      } catch (e) {
        debugPrint("Endpoint $endpoint failed: $e");
      }
    }
    return {
      'status': '0',
      'message': 'Outward request reject failed. Please try again.',
    };
  }

  @override
  Future<void> saveAccessLog(String pageName) async {
    final endpoints = [
      Constants.saveAccessLog,
      'save_access_log',
      'api/save_access_log',
    ];

    for (var endpoint in endpoints) {
      try {
        await _dioClient.dio.post(
          endpoint,
          data: {'page': pageName},
        );
        break;
      } catch (_) {}
    }
  }
}
