import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/data/repositories/stack_repository_impl.dart';
import 'package:ag_broker/domain/entities/running_deal_model.dart';
import 'package:ag_broker/domain/entities/stack_sell_list_model.dart';
import 'package:ag_broker/domain/repositories/stack_repository.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repositories
final stackRepositoryProvider = Provider<StackRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return StackRepositoryImpl(locale);
});

// State
final stackStateProvider = NotifierProvider<StackNotifier, StackState>(() {
  return StackNotifier();
});

class StackState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final StackSellModel? stackSellData;
  final Map<String, dynamic>? stackSellTerms;
  final bool isTermsLoading;

  final RunningDealsResponse? runningDealsData;
  final RunningDealsResponse? deliveredDealsData;
  final bool isRunningDealsLoading;
  final bool isDeliveredDealsLoading;
  final bool isOutwardSubmitting;
  final int selectedSubTab;

  StackState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.stackSellData,
    this.stackSellTerms,
    this.isTermsLoading = false,
    this.runningDealsData,
    this.deliveredDealsData,
    this.isRunningDealsLoading = false,
    this.isDeliveredDealsLoading = false,
    this.isOutwardSubmitting = false,
    this.selectedSubTab = 0,
  });

  StackState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    StackSellModel? stackSellData,
    Map<String, dynamic>? stackSellTerms,
    bool? isTermsLoading,
    RunningDealsResponse? runningDealsData,
    RunningDealsResponse? deliveredDealsData,
    bool? isRunningDealsLoading,
    bool? isDeliveredDealsLoading,
    bool? isOutwardSubmitting,
    int? selectedSubTab,
  }) {
    return StackState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      stackSellData: stackSellData ?? this.stackSellData,
      stackSellTerms: stackSellTerms ?? this.stackSellTerms,
      isTermsLoading: isTermsLoading ?? this.isTermsLoading,
      runningDealsData: runningDealsData ?? this.runningDealsData,
      deliveredDealsData: deliveredDealsData ?? this.deliveredDealsData,
      isRunningDealsLoading:
          isRunningDealsLoading ?? this.isRunningDealsLoading,
      isDeliveredDealsLoading:
          isDeliveredDealsLoading ?? this.isDeliveredDealsLoading,
      isOutwardSubmitting: isOutwardSubmitting ?? this.isOutwardSubmitting,
      selectedSubTab: selectedSubTab ?? this.selectedSubTab,
    );
  }
}

class StackNotifier extends Notifier<StackState> {
  StackRepository get repository => ref.read(stackRepositoryProvider);

  @override
  StackState build() {
    Future.microtask(() {
      fetchStackSellTerms();
      fetchStackSellList();
      fetchRunningDeals();
      fetchDeliveredDeals();
      repository.saveAccessLog("truck_load_dashboard");
    });
    return StackState();
  }

  void setSubTab(int index) {
    state = state.copyWith(selectedSubTab: index);
    if (index == 0) {
      fetchRunningDeals();
    } else if (index == 1) {
      fetchDeliveredDeals();
    } else if (index == 2) {
      fetchStackSellList();
    }
  }

  Future<void> fetchStackSellList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stackSellList = await repository.getStackSellList();
      state = state.copyWith(isLoading: false, stackSellData: stackSellList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchRunningDeals() async {
    state = state.copyWith(isRunningDealsLoading: true, error: null);
    try {
      final response = await repository.getRunningDeals();
      state = state.copyWith(
        isRunningDealsLoading: false,
        runningDealsData: response,
      );
    } catch (e) {
      state = state.copyWith(
        isRunningDealsLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchDeliveredDeals() async {
    state = state.copyWith(isDeliveredDealsLoading: true, error: null);
    try {
      final response = await repository.getDeliveredDeals();
      state = state.copyWith(
        isDeliveredDealsLoading: false,
        deliveredDealsData: response,
      );
    } catch (e) {
      state = state.copyWith(
        isDeliveredDealsLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>?> fetchOrderOutwardInfo(String orderId) async {
    try {
      return await repository.getOrderOutwardRequest(orderId);
    } catch (e) {
      debugPrint("Error fetching outward info: $e");
      return null;
    }
  }

  Future<bool> submitBuyerOutwardRequest({
    required String orderId,
    required String truckNumber,
    required String driverNumber,
    required String weight,
  }) async {
    state = state.copyWith(isOutwardSubmitting: true);
    NavigationService.showLoading();
    try {
      final response = await repository.postBuyerOutwardRequest(
        orderId: orderId,
        truckNumber: truckNumber,
        driverNumber: driverNumber,
        weight: weight,
      );
      NavigationService.hideLoading();
      state = state.copyWith(isOutwardSubmitting: false);

      if (response['status'].toString() == "1" ||
          response['status'] == true ||
          response['success'] == true) {
        NavigationService.successSnackbar(
          response['message'] ?? 'Outward request submitted successfully',
        );
        fetchRunningDeals();
        return true;
      } else {
        NavigationService.showDialogGlobal(
          dismissLoadingFirst: true,
          builder: (dialogContext) {
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(localizations.errorOccurred),
              content: Text(
                response['message'] ?? localizations.errorOccurred,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(localizations.ok),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      NavigationService.hideLoading();
      state = state.copyWith(isOutwardSubmitting: false);
      NavigationService.showDialogGlobal(
        dismissLoadingFirst: true,
        builder: (dialogContext) {
          final localizations = AppLocalizations.of(dialogContext)!;
          return AlertDialog(
            title: Text(localizations.errorOccurred),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(localizations.ok),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  Future<bool> rejectOutwardRequest(String requestId) async {
    NavigationService.showLoading();
    try {
      final response = await repository.rejectOutwardRequest(requestId);
      NavigationService.hideLoading();

      final status = response['status']?.toString();
      final message =
          response['message'] ??
          response['msg'] ??
          'आउटवर्ड रिक्वेस्ट सफलतापूर्वक अस्वीकार कर दी गई है।';

      if (status == "1" || status == "true" || response['success'] == true) {
        NavigationService.successSnackbar(message);
        fetchRunningDeals();
        return true;
      } else {
        NavigationService.showDialogGlobal(
          dismissLoadingFirst: true,
          builder: (dialogContext) {
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(localizations.errorOccurred),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(localizations.ok),
                ),
              ],
            );
          },
        );
        return false;
      }
    } catch (e) {
      NavigationService.hideLoading();
      NavigationService.showDialogGlobal(
        dismissLoadingFirst: true,
        builder: (dialogContext) {
          final localizations = AppLocalizations.of(dialogContext)!;
          return AlertDialog(
            title: Text(localizations.errorOccurred),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(localizations.ok),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  Future<void> postStackBid({
    required String stackId,
    required String price,
    required String userId,
  }) async {
    NavigationService.showLoading();
    state = state.copyWith(isLoading: true, error: null);
    try {
      await repository
          .postStackBid(stackId: stackId, price: price, userId: userId)
          .then((value) async {
            if (value['status'].toString() == "1") {
              await fetchStackSellList();
              NavigationService.successSnackbar(
                value['message'] ?? 'Bid placed successfully',
              );
              ref.read(bidsStateProvider.notifier).setClient(null);
              NavigationService.goBack();
            } else {
              NavigationService.goBack();

              NavigationService.showDialogGlobal(
                dismissLoadingFirst: true,
                builder: (dialogContext) {
                  final localizations = AppLocalizations.of(dialogContext)!;
                  return AlertDialog(
                    title: Text(localizations.errorOccurred),
                    content: Text(
                      value['message'] ?? localizations.errorOccurred,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(localizations.ok),
                      ),
                    ],
                  );
                },
              );
            }
          });
      state = state.copyWith(isLoading: false);
      // Handle response if needed
      NavigationService.hideLoading();
    } catch (e) {
      NavigationService.hideLoading();

      state = state.copyWith(isLoading: false, error: e.toString());

      NavigationService.showDialogGlobal(
        dismissLoadingFirst: true,
        builder: (dialogContext) {
          final localizations = AppLocalizations.of(dialogContext)!;
          return AlertDialog(
            title: Text(localizations.errorOccurred),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(localizations.ok),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchStackSellTerms() async {
    state = state.copyWith(isTermsLoading: true, error: null);
    try {
      final response = await repository.getStackSellTerms();
      state = state.copyWith(isTermsLoading: false, stackSellTerms: response);
      // Handle response if needed
    } catch (e) {
      state = state.copyWith(isTermsLoading: false, error: e.toString());
    }
  }
}
