import 'package:ag_broker/core/utils/navigation_service.dart';
import 'package:ag_broker/data/repositories/stack_repository_impl.dart';
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

  StackState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.stackSellData,
    this.stackSellTerms,
    this.isTermsLoading = false,
  });

  StackState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    StackSellModel? stackSellData,
    Map<String, dynamic>? stackSellTerms,
    bool? isTermsLoading,
  }) {
    return StackState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      stackSellData: stackSellData ?? this.stackSellData,
      stackSellTerms: stackSellTerms ?? this.stackSellTerms,
      isTermsLoading: isTermsLoading ?? this.isTermsLoading,
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
    });
    return StackState();
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
