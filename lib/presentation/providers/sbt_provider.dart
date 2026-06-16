import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/data/repositories/sbt_repository_impl.dart';
import 'package:ag_broker/domain/entities/delivery_centers_model.dart';
import 'package:ag_broker/domain/entities/matched_orders_model.dart';
import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/sbt_repository.dart';
import 'package:ag_broker/l10n/app_localizations.dart';
import 'package:ag_broker/presentation/providers/bids_provider.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repositories
final sbtRepositoryProvider = Provider<SbtRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return SbtRepositoryImpl(locale);
});

// State
final sbtStateProvider = NotifierProvider<SbtNotifier, SbtState>(() {
  return SbtNotifier();
});

class SbtState {
  final bool isLoading;
  final bool isMatchedOrdersLoading;
  final String? error;
  final bool isAuthenticated;
  final SbtProductResponse? sbtProductData;
  final DeliveryCentersModel? deliveryCentersData;
  final bool isDeliveryLoading;
  final TradeListModel? tradeListData;
  final SbtMatchedOrderResponse? matchedOrdersData;

  SbtState({
    this.isLoading = false,
    this.isDeliveryLoading = false,
    this.isMatchedOrdersLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.sbtProductData,
    this.deliveryCentersData,
    this.tradeListData,
    this.matchedOrdersData,
  });

  SbtState copyWith({
    bool? isLoading,
    bool? isDeliveryLoading,
    bool? isMatchedOrdersLoading, 
    String? error,
    bool? isAuthenticated,
    SbtProductResponse? sbtProductData,
    TradeListModel? tradeListData,
    DeliveryCentersModel? deliveryCentersData,
    SbtMatchedOrderResponse? matchedOrdersData,
  }) {
    return SbtState(
      isLoading: isLoading ?? this.isLoading,
      isDeliveryLoading: isDeliveryLoading ?? this.isDeliveryLoading,
      isMatchedOrdersLoading:
          isMatchedOrdersLoading ?? this.isMatchedOrdersLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      sbtProductData: sbtProductData ?? this.sbtProductData,
      deliveryCentersData: deliveryCentersData ?? this.deliveryCentersData,
      tradeListData: tradeListData ?? this.tradeListData,
      matchedOrdersData: matchedOrdersData ?? this.matchedOrdersData,
    );
  }
}

class SbtNotifier extends Notifier<SbtState> {
  SbtRepository get repository => ref.read(sbtRepositoryProvider);

  @override
  SbtState build() {  
    return SbtState();
  }

  Future<void> fetchSbtProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sbtProducts = await repository.getSbtProducts();
      state = state.copyWith(isLoading: false, sbtProductData: sbtProducts);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch SBT products: $e',
      );
    }
  }

  Future<void> saveTrade({  
    required String productId,
    required String districtId,
    required String commodity,
    required String qty,
    required String type,
    required String price,
    required String userId,
  }) async {
    try {
      NavigationService.showLoading();
      final response = await repository.saveTrade(   
        productId,
        districtId,
        commodity,
        qty,
        type,
        price,
        userId,
      );

      if (response['status'].toString() == "1") {
        NavigationService.successSnackbar(
          response['message'] ?? 'Trade saved successfully',
        );

        await fetchSbtProducts();
        await getMatchedOrders(productId);
        await ref.read(bidsStateProvider.notifier).fetchTradeList(productId);
        NavigationService.isDialogShown
            ? NavigationService.hideLoading()
            : null;

        if (NavigationService.context!.mounted) {    
          Navigator.of(NavigationService.context!).pop();
        }
      } else {
        NavigationService.hideLoading();
        NavigationService.showDialogGlobal(
          builder: (dialogContext) {  
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(localizations.errorOccurred),
              content: Text(response['message'] ?? localizations.errorOccurred),
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
    } catch (e) {
      NavigationService.isDialogShown ? NavigationService.hideLoading() : null;
      NavigationService.showSnackBar('Failed to save trade: $e');
    }
  }

  Future<void> deleteBids(String productId, String tradeId) async {
    try {  
      NavigationService.showLoading();
      var response = await repository.deleteBid(tradeId).onError((e, s) {
        NavigationService.hideLoading();
        NavigationService.showSnackBar('Failed to delete bid: $e');
        return {};
      });

      if (response['status'].toString() == "1") {
        NavigationService.successSnackbar(
          response['message'] ?? 'Bid deleted successfully',
        );
      } else {
        NavigationService.showSnackBar(
          response['message'] ?? 'Error occurred while deleting bid',
        );
      }
      NavigationService.hideLoading();
      await fetchSbtProducts();
      await getMatchedOrders(productId);
      await ref.read(bidsStateProvider.notifier).fetchTradeList(productId);
    } catch (e) {}
  }

  Future<void> getDeliveryCenters(String productId) async {
    state = state.copyWith(isDeliveryLoading: true, error: null);
    try {
      final deliveryCenters = await repository.getDeliveryCenters(productId);
      state = state.copyWith(
        isDeliveryLoading: false,
        deliveryCentersData: deliveryCenters,
      );
    } catch (e) {  
      state = state.copyWith( 
        isDeliveryLoading: false,
        error: 'Failed to fetch delivery centers: $e',
      );
    }
  }

  Future<void> getMatchedOrders(String productId) async {
    try {
      final matchedOrders = await repository.getMatchedOrders(productId);
      state = state.copyWith(matchedOrdersData: matchedOrders);
    } catch (e) {}
  }

  Future<void> editBid({  
    String? productId,
    String? districtId,
    String? commodity,
    String? qty,
    String? type,
    String? price,
    String? tradeId,
    String? userId,
  }) async {
    try {
      NavigationService.showLoading();
      final response = await repository.editBid(
        productId: productId,
        districtId: districtId,
        commodity: commodity,
        qty: qty,
        type: type,
        price: price,
        tradeId: tradeId,
        userId: userId,
      );

      if (response['status'].toString() == "1") {
        NavigationService.successSnackbar(
          response['message'] ?? 'Bid edited successfully',
        );
        await fetchSbtProducts();
        await getMatchedOrders(productId!);
        if (NavigationService.context!.mounted) {
          Navigator.of(NavigationService.context!).pop();
        }
      } else {
        state = state.copyWith(error: response['message'] ?? 'Error occurred');
        NavigationService.showDialogGlobal(
          dismissLoadingFirst: true,
          builder: (dialogContext) { 
            final localizations = AppLocalizations.of(dialogContext)!;
            return AlertDialog( 
              title: Text(localizations.errorOccurred),
              content: Text(response['message'] ?? localizations.errorOccurred),
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
    } catch (e) {
      NavigationService.showSnackBar('Failed to edit bid: $e');
    }
    NavigationService.hideLoading();
  }

  Future<void> fetchTradeList(String productId) async {
    try {
      final tradeList = await repository.fetchTradeList(productId);
      state = state.copyWith(tradeListData: tradeList);
    } catch (e) {
      state = state.copyWith(error: 'Failed to fetch trade list: $e');
    }
  }
}
