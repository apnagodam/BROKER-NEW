import 'dart:ui';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/domain/entities/wallet_statement_model.dart';
import 'package:ag_broker/domain/entities/withdrawal_model.dart';
import 'package:ag_broker/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl extends WalletRepository {
  final DioClient _dioClient;

  WalletRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);

  @override
  Future<WalletStatementModel> getWalletStatement({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        Constants.walletStatement,
        queryParameters: {'from_date': fromDate, 'to_date': toDate},
      );
      return WalletStatementModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch Wallet Statement: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createWithdrawalRequest({
    required String requestedAmount,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        Constants.withdrawRequest,
        data: {'requested_amount': requestedAmount},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to create withdrawal request: $e');
    }
  }

  @override
  Future<WithdrawalListModel> getWithdrawalList() async {
    try {
      final response = await _dioClient.dio.post(Constants.getWithdrawList);
      return WithdrawalListModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch withdrawal list: $e');
    }
  }
}
