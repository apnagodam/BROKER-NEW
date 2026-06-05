import 'package:ag_broker/domain/entities/wallet_statement_model.dart';
import 'package:ag_broker/domain/entities/withdrawal_model.dart';

abstract class WalletRepository {
  Future<WalletStatementModel> getWalletStatement({
    required String fromDate,
    required String toDate,
  });

  Future<Map<String, dynamic>> createWithdrawalRequest({
    required String requestedAmount,
  });

  Future<WithdrawalListModel> getWithdrawalList();
}
