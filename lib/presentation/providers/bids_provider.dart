import 'package:ag_broker/data/repositories/bids_repository_impl.dart';
import 'package:ag_broker/domain/entities/client_list_model.dart';
import 'package:ag_broker/domain/entities/deals_model.dart';
import 'package:ag_broker/domain/entities/quality_params_model.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/bids_repository.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repositories
final bidsRepositoryProvider = Provider<BidsRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return BidsRepositoryImpl(locale);
});

// State
final bidsStateProvider = NotifierProvider<BidsNotifier, BidsState>(() {
  return BidsNotifier();
});

class BidsState {
  final bool isLoadingTradeList;
  final bool isLoadingTerms;
  final bool isLoadingClients;
  final bool isLoadingQualityParams;
  final bool isLoadingDeals;
  final String? error;
  final bool isAuthenticated;
  final TradeListModel? tradeListData;
  final Map<String, dynamic>? buySellTerms;
  final List<OrderDatum>? buyList;
  final List<OrderDatum>? sellList;
  final ClientListModel? clientListData;
  final QualityParamsModel? qualityParamsData;
  final DealsModel? dealsListData;
  final Datum? selectedClient;

  BidsState({
    this.isLoadingTradeList = false,
    this.isLoadingTerms = false,
    this.isLoadingClients = false,
    this.isLoadingQualityParams = false,
    this.isLoadingDeals = false,
    this.error,
    this.isAuthenticated = false,
    this.tradeListData,
    this.buySellTerms,
    this.clientListData,
    this.qualityParamsData,
    this.dealsListData,
    this.selectedClient,
    this.buyList,
    this.sellList,
  });

  // Convenience getter for overall loading state
  bool get isLoading =>
      isLoadingTradeList ||
      isLoadingTerms ||
      isLoadingClients ||
      isLoadingQualityParams ||
      isLoadingDeals;

  BidsState copyWith({
    bool? isLoadingTradeList,
    bool? isLoadingTerms,
    bool? isLoadingClients,
    bool? isLoadingQualityParams,
    bool? isLoadingDeals,
    String? error,
    bool? isAuthenticated,
    TradeListModel? tradeListData,
    Map<String, dynamic>? buySellTerms,
    ClientListModel? clientListData,
    QualityParamsModel? qualityParamsData,
    DealsModel? dealsListData,
    List<OrderDatum>? buyList,
    List<OrderDatum>? sellList,
    bool clearError = false,
    Datum? selectedClient,
    // When true, explicitly clear selectedClient to null even if selectedClient param is null
    bool clearSelectedClient = false,
  }) {
    return BidsState(
      isLoadingTradeList: isLoadingTradeList ?? this.isLoadingTradeList,
      isLoadingTerms: isLoadingTerms ?? this.isLoadingTerms,
      isLoadingClients: isLoadingClients ?? this.isLoadingClients,
      isLoadingQualityParams:
          isLoadingQualityParams ?? this.isLoadingQualityParams,
      isLoadingDeals: isLoadingDeals ?? this.isLoadingDeals,
      error: clearError ? null : (error ?? this.error),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      tradeListData: tradeListData ?? this.tradeListData,
      buySellTerms: buySellTerms ?? this.buySellTerms,
      clientListData: clientListData ?? this.clientListData,
      qualityParamsData: qualityParamsData ?? this.qualityParamsData,
      dealsListData: dealsListData ?? this.dealsListData,
      buyList: buyList ?? this.buyList,
      sellList: sellList ?? this.sellList,
      selectedClient: clearSelectedClient
          ? null
          : (selectedClient ?? this.selectedClient),
    );
  }
}

class BidsNotifier extends Notifier<BidsState> {
  BidsRepository get repository => ref.read(bidsRepositoryProvider);

  @override
  BidsState build() {
    Future.microtask(() {
      fetchClientList();
    });
    return BidsState();
  }

  get selectedClient => state.selectedClient;

  void setClient(Datum? client) {
    state = state.copyWith(
      selectedClient: client,
      clearSelectedClient: client == null,
    );
  }

  Future<void> fetchTradeList(String productId) async {
    state = state.copyWith(isLoadingTradeList: true, clearError: true);
    try {
      final tradeList = await repository.getTradeList(productId);
      state = state.copyWith(
        isLoadingTradeList: false,
        tradeListData: tradeList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTradeList: false,
        error: 'Failed to fetch Trade List: $e',
      );
    }
  }

  Future<void> fetchBuySellTerms(String productId, String userType) async {
    state = state.copyWith(isLoadingTerms: true, clearError: true);
    try {
      final terms = await repository.getBuySellTerms(productId, userType);
      state = state.copyWith(isLoadingTerms: false, buySellTerms: terms);
    } catch (e) {
      state = state.copyWith(
        isLoadingTerms: false,
        error: 'Failed to fetch Buy Sell Terms: $e',
      );
    }
  }

  Future<void> fetchClientList() async {
    state = state.copyWith(isLoadingClients: true, clearError: true);
    try {
      final clients = await repository.getClientList();
      state = state.copyWith(isLoadingClients: false, clientListData: clients);
    } catch (e) {
      state = state.copyWith(
        isLoadingClients: false,
        error: 'Failed to fetch Client List: $e',
      );
    }
  }

  Future<void> fetchQualityParams(String productId) async {
    state = state.copyWith(isLoadingQualityParams: true, clearError: true);
    try {
      final qualityParams = await repository.getQualityParams(productId);
      // Handle qualityParams as needed
      state = state.copyWith(
        isLoadingQualityParams: false,
        qualityParamsData: qualityParams,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingQualityParams: false,
        error: 'Failed to fetch Quality Parameters: $e',
      );
    }
  }

  Future<void> fetchDealsList() async {
    state = state.copyWith(isLoadingDeals: true, clearError: true);
    try {
      final dealsList = await repository.getDealsList();
      List<OrderDatum> buyList = [];
      List<OrderDatum> sellList = [];
      for (var order in dealsList.orderData ?? []) {
        if (order.dealType == 'Buy') {
          buyList.add(order);
        } else if (order.dealType == 'Sell') {
          sellList.add(order);
        }
      }
      state = state.copyWith(
        isLoadingDeals: false,
        dealsListData: dealsList,
        buyList: buyList,
        sellList: sellList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingDeals: false,
        error: 'Failed to fetch Deals List: $e',
      );
    }
  }
}
