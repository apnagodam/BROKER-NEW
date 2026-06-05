import 'dart:io';
import 'package:ag_broker/data/repositories/lp_client_repository_impl.dart';
import 'package:ag_broker/domain/entities/lp_client_model.dart';
import 'package:ag_broker/domain/repositories/lp_client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final lpClientRepositoryProvider = Provider.family<LpClientRepository, Locale>(
  (ref, locale) => LpClientRepositoryImpl(locale),
);

// State class for LP Client
class LpClientState {
  final LpClientListModel? clientList;
  final bool isLoading;
  final String? error;

  LpClientState({this.clientList, this.isLoading = false, this.error});

  LpClientState copyWith({
    LpClientListModel? clientList,
    bool? isLoading,
    String? error,
  }) {
    return LpClientState(
      clientList: clientList ?? this.clientList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// State Notifier for LP Client operations
class LpClientStateNotifier extends StateNotifier<LpClientState> {
  final LpClientRepository repository;

  LpClientStateNotifier(this.repository) : super(LpClientState());

  Future<void> fetchLpClientList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final clientList = await repository.getLpClientList();
      state = state.copyWith(clientList: clientList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addLpClient({
    required String constitution,
    required String name,
    required String phone,
    String? bidStatus,
    File? aadharFrontImage,
    File? aadharBackImage,
    File? pancardImage,
    File? gstImage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await repository.addLpClient(
        constitution: constitution,
        name: name,
        phone: phone,
        bidStatus: bidStatus,
        aadharFrontImage: aadharFrontImage,
        aadharBackImage: aadharBackImage,
        pancardImage: pancardImage,
        gstImage: gstImage,
      );

      // Verify response status explicitly
      if (response['status']?.toString() == "0") {
        final errorMessage = response['Message'] ?? 'Failed to add LP Client';
        state = state.copyWith(isLoading: false, error: errorMessage);
        return false;
      }

      state = state.copyWith(isLoading: false, error: null);
      // Refresh the list after adding
      await fetchLpClientList();
      return true;
    } catch (e) {
      // Extract clean error message from exception
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for LP Client state
final lpClientStateProvider =
    StateNotifierProvider.family<LpClientStateNotifier, LpClientState, Locale>((
      ref,
      locale,
    ) {
      final repository = ref.watch(lpClientRepositoryProvider(locale));
      return LpClientStateNotifier(repository);
    });
