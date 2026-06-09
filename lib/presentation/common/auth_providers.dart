import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/data/repositories/auth_repository_impl.dart';
import 'package:ag_broker/domain/entities/user_details_model.dart';
import 'package:ag_broker/domain/repositories/auth_repository.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.response,
    this.isBrokerageLoading = false,
    this.brokerageResponse,
    this.userDetails,
    this.isUserDetailsLoading = false,
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

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await repository.sendOtp(phoneNumber).then((value) {
        if (value['status'].toString() == "1") {
          state = state.copyWith(isLoading: false, response: value);
        } else {
          state = state.copyWith(
            isLoading: false,
            error: value['message'] ?? 'failedToSendOtp',
            response: value,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        response: null,
      );
    }

    return state.response ?? {};
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      var response = await repository.verifyOtp(phoneNumber, otp);
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        response: null,
      );
    }

    return state.response ?? {};
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
