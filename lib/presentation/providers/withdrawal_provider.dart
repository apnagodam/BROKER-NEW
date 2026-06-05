import 'package:ag_broker/data/repositories/wallet_repository_impl.dart';
import 'package:ag_broker/domain/entities/withdrawal_model.dart';
import 'package:ag_broker/domain/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class for withdrawal
class WithdrawalState {
  final WithdrawalListModel? withdrawalList;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  WithdrawalState({
    this.withdrawalList,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  WithdrawalState copyWith({
    WithdrawalListModel? withdrawalList,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
  }) {
    return WithdrawalState(
      withdrawalList: withdrawalList ?? this.withdrawalList,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      successMessage: successMessage,
    );
  }
}

// State Notifier for withdrawal operations
class WithdrawalStateNotifier extends StateNotifier<WithdrawalState> {
  final WalletRepository repository;

  WithdrawalStateNotifier(this.repository) : super(WithdrawalState());

  Future<bool> createWithdrawalRequest(String requestedAmount) async {
    state = state.copyWith(
      isSubmitting: true,
      error: null,
      successMessage: null,
    );

    try {
      final response = await repository.createWithdrawalRequest(
        requestedAmount: requestedAmount,
      );

      if (response['status'] == '1' || response['status'] == 1) {
        state = state.copyWith(
          isSubmitting: false,
          successMessage:
              response['message'] ??
              'Withdrawal request submitted successfully',
        );
        // Refresh the list after successful submission
        await fetchWithdrawalList();
        return true;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          error: response['message'] ?? 'Failed to submit withdrawal request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  Future<void> fetchWithdrawalList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final withdrawalList = await repository.getWithdrawalList();
      state = state.copyWith(withdrawalList: withdrawalList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }
}

// Provider for withdrawal state
final withdrawalStateProvider =
    StateNotifierProvider.family<
      WithdrawalStateNotifier,
      WithdrawalState,
      Locale
    >((ref, locale) {
      final repository = WalletRepositoryImpl(locale);
      return WithdrawalStateNotifier(repository);
    });
