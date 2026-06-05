import 'package:ag_broker/data/repositories/wallet_repository_impl.dart';
import 'package:ag_broker/domain/entities/wallet_statement_model.dart';
import 'package:ag_broker/domain/repositories/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final walletRepositoryProvider = Provider.family<WalletRepository, Locale>(
  (ref, locale) => WalletRepositoryImpl(locale),
);

// State class for wallet
class WalletState {
  final WalletStatementModel? walletStatement;
  final bool isLoading;
  final String? error;
  final String? fromDate;
  final String? toDate;
  WalletState({
    this.walletStatement,
    this.isLoading = false,
    this.error,
    this.fromDate,
    this.toDate,
  });

  WalletState copyWith({
    WalletStatementModel? walletStatement,
    bool? isLoading,
    String? error,
    String? fromDate,
    String? toDate,
  }) {
    return WalletState(
      walletStatement: walletStatement ?? this.walletStatement,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

// State Notifier for wallet operations
class WalletStateNotifier extends StateNotifier<WalletState> {
  final WalletRepository repository;

  WalletStateNotifier(this.repository) : super(WalletState());

  Future<void> fetchWalletStatement(String fromDate, String toDate) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final walletStatement = await repository.getWalletStatement(
        fromDate: fromDate,
        toDate: toDate,
      );
      state = state.copyWith(
        walletStatement: walletStatement,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for wallet state
final walletStateProvider =
    StateNotifierProvider.family<WalletStateNotifier, WalletState, Locale>((
      ref,
      locale,
    ) {
      final repository = ref.watch(walletRepositoryProvider(locale));
      return WalletStateNotifier(repository);
    });
