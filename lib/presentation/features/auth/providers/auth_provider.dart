import 'package:ag_broker/core/utils/shared_preferences_service.dart';
import 'package:ag_broker/data/repositories/auth_repository_impl.dart';
import 'package:ag_broker/domain/repositories/auth_repository.dart';
import 'package:ag_broker/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_provider.freezed.dart';

// =============================================================================
// REPOSITORY PROVIDER
// =============================================================================

/// Provides AuthRepository with locale dependency
/// keepAlive ensures repository persists throughout app lifecycle
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final locale = ref.watch(localeProvider);
  return AuthRepositoryImpl(locale);
});

// =============================================================================
// STATE MODEL
// =============================================================================

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.otpSent({required String phoneNumber}) = _OtpSent;
  const factory AuthState.authenticated({
    required Map<String, dynamic> userData,
  }) = _Authenticated;
  const factory AuthState.partialLogin({
    required String phoneNumber,
    required Map<String, dynamic> response,
  }) = _PartialLogin;
  const factory AuthState.error({required String message}) = _Error;
}

// =============================================================================
// STATE NOTIFIER
// =============================================================================

/// Provides authentication state management
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    // Check if user is already logged in on app start
    if (SharedPreferencesService.isLoggedIn) {
      // Try to get saved user data
      final token = SharedPreferencesService.token;
      final userId = SharedPreferencesService.userId;
      if (token != null && userId != null) {
        return AuthState.authenticated(
          userData: {'token': token, 'user_id': userId},
        );
      }
    }
    return const AuthState.initial();
  }

  /// Send OTP to user ID
  Future<void> sendOtp(int userId, {String phoneNumber = ''}) async {
    state = const AuthState.loading();

    try {
      final response = await _repository.sendOtp(userId: userId);

      if (response['status'].toString() == "1") {
        state = AuthState.otpSent(phoneNumber: phoneNumber);
      } else {
        state = AuthState.error(
          message: response['message']?.toString() ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Verify OTP and authenticate user
  Future<void> verifyOtp(int userId, String otp, {String phoneNumber = ''}) async {
    state = const AuthState.loading();

    try {
      final response = await _repository.verifyOtp(userId: userId, otp: otp);

      if (response['status'].toString() == "1") {
        // Complete login - save data and set authenticated state
        await SharedPreferencesService.saveCompleteLoginData(response);
        state = AuthState.authenticated(userData: response);
      } else if (response['status'].toString() == "3") {
        // Partial login - OTP verified but additional info needed
        state = AuthState.partialLogin(
          phoneNumber: phoneNumber,
          response: response,
        );
      } else {
        state = AuthState.error(
          message: response['message']?.toString() ?? 'Invalid OTP',
        );
      }
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Complete partial login with additional information
  Future<void> completePartialLogin(Map<String, dynamic> additionalData) async {
    state = const AuthState.loading();

    try {
      // Combine partial login data with additional data
      final currentState = state;
      if (currentState is _PartialLogin) {
        final completeData = {...currentState.response, ...additionalData};

        await SharedPreferencesService.saveCompleteLoginData(completeData);
        state = AuthState.authenticated(userData: completeData);
      } else {
        state = const AuthState.error(
          message: 'Invalid state for completing partial login',
        );
      }
    } catch (e) {
      state = AuthState.error(message: e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    await SharedPreferencesService.clearAuthData();
    state = const AuthState.initial();
  }

  /// Reset error state
  void clearError() {
    if (state is _Error) {
      state = const AuthState.initial();
    }
  }
}

// =============================================================================
// CONVENIENCE PROVIDERS
// =============================================================================

/// Provides current authentication status as boolean
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is _Authenticated;
});

/// Provides loading state
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState is _Loading;
});

/// Provides error message if any
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.maybeWhen(error: (message) => message, orElse: () => null);
});
