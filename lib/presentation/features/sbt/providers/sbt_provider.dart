import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/data/repositories/sbt_repository_impl.dart';
import 'package:ag_broker/domain/entities/delivery_centers_model.dart';
import 'package:ag_broker/domain/entities/matched_orders_model.dart';
import 'package:ag_broker/domain/entities/sbt_product.dart';
import 'package:ag_broker/domain/entities/trade_list_model.dart';
import 'package:ag_broker/domain/repositories/sbt_repository.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sbt_provider.freezed.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Provides SbtRepository with locale dependency
final sbtRepositoryProvider = Provider<SbtRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return SbtRepositoryImpl(locale);
});

// =============================================================================
// STATE MODELS
// =============================================================================

@freezed
class SbtProductsState with _$SbtProductsState {
  const factory SbtProductsState.initial() = _Initial;
  const factory SbtProductsState.loading() = _Loading;
  const factory SbtProductsState.loaded(SbtProductResponse products) = _Loaded;
  const factory SbtProductsState.error(String message) = _Error;
}

@freezed
class DeliveryCentersState with _$DeliveryCentersState {
  const factory DeliveryCentersState.initial() = _DeliveryCentersInitial;
  const factory DeliveryCentersState.loading() = _DeliveryCentersLoading;
  const factory DeliveryCentersState.loaded(DeliveryCentersModel centers) =
      _DeliveryCentersLoaded;
  const factory DeliveryCentersState.error(String message) =
      _DeliveryCentersError;
}

@freezed
class MatchedOrdersState with _$MatchedOrdersState {
  const factory MatchedOrdersState.initial() = _MatchedOrdersInitial;
  const factory MatchedOrdersState.loading() = _MatchedOrdersLoading;
  const factory MatchedOrdersState.loaded(SbtMatchedOrderResponse orders) =
      _MatchedOrdersLoaded;
  const factory MatchedOrdersState.error(String message) = _MatchedOrdersError;
}

@freezed
class TradeListState with _$TradeListState {
  const factory TradeListState.initial() = _TradeListInitial;
  const factory TradeListState.loading() = _TradeListLoading;
  const factory TradeListState.loaded(TradeListModel tradeList) =
      _TradeListLoaded;
  const factory TradeListState.error(String message) = _TradeListError;
}

// =============================================================================
// SBT PRODUCTS PROVIDER
// =============================================================================

/// Provides SBT products list with auto-refresh capability
final sbtProductsProvider =
    NotifierProvider<SbtProductsNotifier, SbtProductsState>(() {
      return SbtProductsNotifier();
    });

class SbtProductsNotifier extends Notifier<SbtProductsState> {
  SbtRepository get _repository => ref.read(sbtRepositoryProvider);

  @override
  SbtProductsState build() {
    // Auto-fetch on first access
    Future.microtask(() => fetchProducts());
    return const SbtProductsState.initial();
  }

  /// Fetch SBT products
  Future<void> fetchProducts() async {
    state = const SbtProductsState.loading();

    try {
      final products = await _repository.getSbtProducts();
      state = SbtProductsState.loaded(products);
    } catch (e) {
      state = SbtProductsState.error('Failed to fetch products: $e');
    }
  }

  /// Refresh products (for pull-to-refresh)
  Future<void> refresh() => fetchProducts();
}

// =============================================================================
// DELIVERY CENTERS PROVIDER (Family - Per Product)
// =============================================================================

/// Provides delivery centers for a specific product
final deliveryCentersProvider =
    NotifierProvider.family<
      DeliveryCentersNotifier,
      DeliveryCentersState,
      String
    >(() {
      return DeliveryCentersNotifier();
    });

class DeliveryCentersNotifier
    extends FamilyNotifier<DeliveryCentersState, String> {
  SbtRepository get _repository => ref.read(sbtRepositoryProvider);

  @override
  DeliveryCentersState build(String productId) {
    // Auto-fetch on first access
    Future.microtask(() => fetch());
    return const DeliveryCentersState.initial();
  }

  Future<void> fetch() async {
    state = const DeliveryCentersState.loading();

    try {
      final centers = await _repository.getDeliveryCenters(arg);
      state = DeliveryCentersState.loaded(centers);
    } catch (e) {
      state = DeliveryCentersState.error(
        'Failed to fetch delivery centers: $e',
      );
    }
  }
}

// =============================================================================
// MATCHED ORDERS PROVIDER (Family - Per Product)
// =============================================================================

/// Provides matched orders for a specific product
final matchedOrdersProvider =
    NotifierProvider.family<MatchedOrdersNotifier, MatchedOrdersState, String>(
      () {
        return MatchedOrdersNotifier();
      },
    );

class MatchedOrdersNotifier extends FamilyNotifier<MatchedOrdersState, String> {
  SbtRepository get _repository => ref.read(sbtRepositoryProvider);

  @override
  MatchedOrdersState build(String productId) {
    // Auto-fetch on first access
    Future.microtask(() => fetch());
    return const MatchedOrdersState.initial();
  }

  Future<void> fetch() async {
    state = const MatchedOrdersState.loading();

    try {
      final orders = await _repository.getMatchedOrders(arg);
      state = MatchedOrdersState.loaded(orders);
    } catch (e) {
      state = MatchedOrdersState.error('Failed to fetch matched orders: $e');
    }
  }
}

// =============================================================================
// TRADE LIST PROVIDER (Family - Per Product)
// =============================================================================

/// Provides trade list for a specific product
final tradeListProvider =
    NotifierProvider.family<TradeListNotifier, TradeListState, String>(() {
      return TradeListNotifier();
    });

class TradeListNotifier extends FamilyNotifier<TradeListState, String> {
  SbtRepository get _repository => ref.read(sbtRepositoryProvider);

  @override
  TradeListState build(String productId) {
    // Auto-fetch on first access
    Future.microtask(() => fetch());
    return const TradeListState.initial();
  }

  Future<void> fetch() async {
    state = const TradeListState.loading();

    try {
      final tradeList = await _repository.fetchTradeList(arg);
      state = TradeListState.loaded(tradeList);
    } catch (e) {
      state = TradeListState.error('Failed to fetch trade list: $e');
    }
  }
}

// =============================================================================
// TRADE ACTIONS PROVIDER (Mutations)
// =============================================================================

/// Provides trade action methods (save, edit, delete)
final tradeActionsProvider = Provider<TradeActions>((ref) {
  return TradeActions(ref);
});

class TradeActions {
  final Ref _ref;

  TradeActions(this._ref);

  SbtRepository get _repository => _ref.read(sbtRepositoryProvider);

  /// Save a new trade
  Future<bool> saveTrade({
    required String productId,
    required String districtId,
    required String commodity,
    required String qty,
    required String type,
    required String price,
    required String userId,
  }) async {
    try {
      final response = await _repository.saveTrade(
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
          response['message'] ?? 'tradeSavedSuccessfully',
        );

        // Refresh related data
        await _refreshAfterTrade(productId);
        return true;
      } else {
        final errorMessage = response['message'] ?? 'Error occurred';
        NavigationService.showSnackBar(errorMessage);
        return false;
      }
    } catch (e) {
      NavigationService.showSnackBar('Failed to save trade: $e');
      return false;
    }
  }

  /// Edit an existing bid
  Future<bool> editBid({
    required String productId,
    required String districtId,
    required String commodity,
    required String qty,
    required String type,
    required String price,
    required String tradeId,
    required String userId,
  }) async {
    try {
      final response = await _repository.editBid(
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
          response['message'] ?? 'bidEditedSuccessfully',
        );

        // Refresh related data
        await _refreshAfterTrade(productId);
        return true;
      } else {
        final errorMessage = response['message'] ?? 'Error occurred';
        NavigationService.showSnackBar(errorMessage);
        return false;
      }
    } catch (e) {
      NavigationService.showSnackBar('Failed to edit bid: $e');
      return false;
    }
  }

  /// Delete bids for a product
  Future<bool> deleteBids(String productId) async {
    try {
      await _repository.deleteBid(productId);

      // Refresh related data
      await _refreshAfterTrade(productId);
      return true;
    } catch (e) {
      NavigationService.showSnackBar('Failed to delete bids: $e');
      return false;
    }
  }

  /// Refresh data after trade operations
  Future<void> _refreshAfterTrade(String productId) async {
    // Refresh products list
    _ref.read(sbtProductsProvider.notifier).fetchProducts();

    // Refresh matched orders for this product
    _ref.read(matchedOrdersProvider(productId).notifier).fetch();
  }
}

// =============================================================================
// CONVENIENCE PROVIDERS
// =============================================================================

/// Check if products are loading
final sbtProductsLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(sbtProductsProvider);
  return state is _Loading;
});

/// Get products list or null
final sbtProductsListProvider = Provider<SbtProductResponse?>((ref) {
  final state = ref.watch(sbtProductsProvider);
  return state.maybeWhen(loaded: (products) => products, orElse: () => null);
});

/// Get error message or null
final sbtProductsErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(sbtProductsProvider);
  return state.maybeWhen(error: (message) => message, orElse: () => null);
});
