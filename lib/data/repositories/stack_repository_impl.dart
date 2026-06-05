import 'dart:ui';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
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
}
