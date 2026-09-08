import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/data/repositories/auth_repository_impl.dart';
import 'package:ag_broker/domain/entities/user_details_model.dart';
import 'package:ag_broker/domain/repositories/auth_repository.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ag_broker/domain/entities/user_account_model.dart';

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return AuthRepositoryImpl(locale);
});

// State
final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final Map<String, dynamic>? response;
  final bool isBrokerageLoading;
  final Map<String, dynamic>? brokerageResponse;
  final UserDetailsModel? userDetails;
  final bool isUserDetailsLoading;
  final bool isCheckingUser;
  final List<UserAccount> accounts;
  final UserAccount? selectedAccount;
  final String? checkUserError;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.response,
    this.isBrokerageLoading = false,
    this.brokerageResponse,
    this.userDetails,
    this.isUserDetailsLoading = false,
    this.isCheckingUser = false,
    this.accounts = const [],
    this.selectedAccount,
    this.checkUserError,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    Map<String, dynamic>? response,
    bool? isBrokerageLoading,
    Map<String, dynamic>? brokerageResponse,
    UserDetailsModel? userDetails,
    bool? isUserDetailsLoading,
    bool? isCheckingUser,
    List<UserAccount>? accounts,
    UserAccount? selectedAccount,
    bool clearSelectedAccount = false,
    String? checkUserError,
    bool clearCheckUserError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      response: response ?? this.response,
      isBrokerageLoading: isBrokerageLoading ?? this.isBrokerageLoading,
      brokerageResponse: brokerageResponse ?? this.brokerageResponse,
      userDetails: userDetails ?? this.userDetails,
      isUserDetailsLoading: isUserDetailsLoading ?? this.isUserDetailsLoading,
      isCheckingUser: isCheckingUser ?? this.isCheckingUser,
      accounts: accounts ?? this.accounts,
      selectedAccount: clearSelectedAccount
          ? null
          : (selectedAccount ?? this.selectedAccount),
      checkUserError: clearCheckUserError
          ? null
          : (checkUserError ?? this.checkUserError),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    // Check if user is already logged in
    if (SharedPreferencesService.isLoggedIn) {
      return AuthState(isAuthenticated: true);
    }
    return AuthState();
  }

  Future<Map<String, dynamic>> checkUser(String phoneNumber) async {
    state = state.copyWith(
      isCheckingUser: true,
      clearCheckUserError: true,
      accounts: [],
      clearSelectedAccount: true,
    );
    try {
      final value = await repository.checkUser(phoneNumber);
      if (value['status'].toString() == "1") {
        final rawList = value['data'] as List? ?? [];
        final parsedAccounts = rawList
            .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
            .toList();

        // Auto-select if only 1 account exists
        final autoSelected =
            parsedAccounts.length == 1 ? parsedAccounts.first : null;

        state = state.copyWith(
          isCheckingUser: false,
          accounts: parsedAccounts,
          selectedAccount: autoSelected,
          clearCheckUserError: true,
        );
        return value;
      } else {
        state = state.copyWith(
          isCheckingUser: false,
          checkUserError: value['message']?.toString() ?? 'User not found',
          accounts: [],
          clearSelectedAccount: true,
        );
        return value;
      }
    } catch (e) {
      state = state.copyWith(
        isCheckingUser: false,
        checkUserError: e.toString(),
        accounts: [],
        clearSelectedAccount: true,
      );
      return {'status': '0', 'message': e.toString()};
    }
  }

  void selectAccount(UserAccount? account) {
    state = state.copyWith(selectedAccount: account);
  }

  void clearAccounts() {
    state = state.copyWith(
      accounts: [],
      clearSelectedAccount: true,
      clearCheckUserError: true,
    );
  }

  Future<Map<String, dynamic>> getBrokerage() async {
    state = state.copyWith(isBrokerageLoading: true, error: null);
    try {
      var response = await repository.getBrokerage();
      if (response['status'].toString() == "1") {
        state = state.copyWith(
          isBrokerageLoading: false,
          brokerageResponse: response,
        );
      } else {
        state = state.copyWith(
          isBrokerageLoading: false,
          error: response['message'] ?? 'failedToFetchBrokerage',
          brokerageResponse: response,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isBrokerageLoading: false,
        error: e.toString(),
        brokerageResponse: null,
      );
    }

    return state.brokerageResponse ?? {};
  }

  Future<Map<String, dynamic>> sendOtp(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final value = await repository.sendOtp(userId: userId);
      if (value['status'].toString() == "1") {
        state = state.copyWith(isLoading: false, response: value);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: value['message'] ?? 'failedToSendOtp',
          response: value,
        );
      }
      return value;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        response: null,
      );
      return {'status': '0', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    String? fcmToken,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      var response = await repository.verifyOtp(
        userId: userId,
        otp: otp,
        fcmToken: fcmToken,
      );
      if (response['status'].toString() == "1") {
        // Save complete login response data
        await SharedPreferencesService.saveCompleteLoginData(response);
        state = state.copyWith(
          isLoading: false,
          response: response,
          isAuthenticated: true,
        );
      } else if (response['status'].toString() == "3") {
        // Partial login - OTP verified but additional info needed
        state = state.copyWith(
          isLoading: false,
          response: response,
          isAuthenticated: false,
        );
        await SharedPreferencesService.clearAuthData();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'verificationFailed',
          response: response,
        );
      }
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        response: null,
      );
      return {'status': '0', 'message': e.toString()};
    }
  }

  Future<void> getUserDetails() async {  
    state = state.copyWith(isUserDetailsLoading: true, error: null);
    try {
      UserDetailsModel userDetails = await repository.getUserDetails();
      state = state.copyWith(
        isUserDetailsLoading: false,
        userDetails: userDetails,
      );
    } catch (e) { 
      state = state.copyWith(
        isUserDetailsLoading: false,
        error: e.toString(),
        userDetails: null,
      );
    }
  }

  Future<void> logout() async {  
    await SharedPreferencesService.clearAuthData();
    state = AuthState(); // Reset to initial state
  }
}
