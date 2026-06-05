import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';

abstract class StackRepository {
  Future<StackSellModel> getStackSellList();
  Future<Map<String, dynamic>> postStackBid({
    required String stackId,
    required String price,
    required String userId,
  });

  Future<Map<String, dynamic>> getStackSellTerms();
}
