import 'dart:async';

import 'package:ag_broker/domain/entities/deals_model.dart';
import 'package:flutter/foundation.dart';

import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart';
import 'package:ag_broker/domain/entities/quality_params_model.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/stack_repository.dart';
import 'package:ag_broker/domain/repositories/bids_repository.dart';
import 'package:ag_broker/data/mock/stack_sell_dummy.dart';
import 'package:ag_broker/data/mock/client_list_dummy.dart';

class MockStackRepositoryImpl extends StackRepository {
  final StackSellModel _mock = getMockStackSellModel();

  @override
  Future<Map<String, dynamic>> getStackSellTerms() async {
    // Return a simple mock terms map
    return Future.value({
      'status': 1,
      'data': '<p>These are mock stack sell terms used in debug mode.</p>',
    });
  }

  @override
  Future<StackSellModel> getStackSellList() async {
    // Simulate network delay in debug
    await Future.delayed(Duration(milliseconds: 200));
    return Future.value(_mock);
  }

  @override
  Future<Map<String, dynamic>> postStackBid({
    required String stackId,
    required String price,
    required String userId,
  }) async {
    await Future.delayed(Duration(milliseconds: 150));
    return Future.value({
      'status': 1,
      'message': 'Mock bid placed successfully',
    });
  }
}

class MockBidsRepositoryImpl extends BidsRepository {
  final ClientListModel _clients = getMockClientListModel();

  @override
  Future<ClientListModel> getClientList() async {
    await Future.delayed(Duration(milliseconds: 150));
    return Future.value(_clients);
  }

  @override
  Future<Map<String, dynamic>> getBuySellTerms(
    String productId,
    String userType,
  ) async {
    await Future.delayed(Duration(milliseconds: 120));
    return Future.value({'status': 1, 'data': '<p>Mock buy/sell terms</p>'});
  }

  @override
  Future<QualityParamsModel> getQualityParams(String productId) async {
    // Return an empty QualityParamsModel if the real model isn't important for debug
    return Future.error('No mock for QualityParamsModel');
  }

  @override
  Future<TradeListModel> getTradeList(String productId) async {
    return Future.error('No mock for TradeListModel');
  }

  @override
  Future<DealsModel> getDealsList() {
    // TODO: implement getDealsList
    throw UnimplementedError();
  }
}
