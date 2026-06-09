import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

class SharedPreferencesService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _completeLoginResponseKey = 'complete_login_response';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Authentication state
  static bool get isLoggedIn => _prefs?.getBool(_isLoggedInKey) ?? false;
  static set isLoggedIn(bool value) => _prefs?.setBool(_isLoggedInKey, value);

  // Complete login response
  static LoginResponse? get completeLoginResponse {
    final responseJson = _prefs?.getString(_completeLoginResponseKey);
    if (responseJson != null) {
      try {
        final Map<String, dynamic> responseMap = json.decode(responseJson);
        return LoginResponse.fromJson(responseMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }



  static set completeLoginResponse(LoginResponse? value) => value != null
      ? _prefs?.setString(
          _completeLoginResponseKey,
          json.encode(value.toJson()),
        )
      : _prefs?.remove(_completeLoginResponseKey);

  // Convenience getters for backward compatibility
  static String? get userId => completeLoginResponse?.userDetails.id.toString();
  static String? get phoneNumber => completeLoginResponse?.userDetails.phone;
  static String? get token => completeLoginResponse?.authorization;
  static List<Bank>? get banks => completeLoginResponse?.banks;
  static UserDetails? get userDetails => completeLoginResponse?.userDetails;
  static int? get active => completeLoginResponse?.active;
  static int? get status => completeLoginResponse?.status;
  static String? get message => completeLoginResponse?.message;
    // Add this alongside the other convenience getters
static int get memberType =>
    int.tryParse(
      completeLoginResponse?.userDetails.memberType?.toString() ?? '1',
    ) ??
    1;

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await _prefs?.remove(_isLoggedInKey);
    await _prefs?.remove(_completeLoginResponseKey);
  }

  // Save complete login response data
  static Future<void> saveCompleteLoginData(
    Map<String, dynamic> response,
  ) async {
    try {
      final loginResponse = LoginResponse.fromJson(response);
      completeLoginResponse = loginResponse;
      isLoggedIn = true;
    } catch (e) {
      // Fallback to old method if parsing fails
      await _saveRawResponse(response);
    }
  }

  // Fallback method for raw response saving
  static Future<void> _saveRawResponse(Map<String, dynamic> response) async {
    isLoggedIn = true;

    // Save Authorization token
    if (response.containsKey('Authorization')) {
      await _prefs?.setString('auth_token', response['Authorization']);
    }

    // Save banks list
    if (response.containsKey('banks')) {
      await _prefs?.setString('banks', json.encode(response['banks']));
    }

    // Save active status
    if (response.containsKey('active')) {
      await _prefs?.setInt('active', response['active']);
    }

    // Save status
    if (response.containsKey('status')) {
      await _prefs?.setInt('status', response['status']);
    }

    // Save message
    if (response.containsKey('message')) {
      await _prefs?.setString('message', response['message']);
    }

    // Save user details
    if (response.containsKey('user_details')) {
      final userDetails = response['user_details'];
      await _prefs?.setString('user_details', json.encode(userDetails));

      // Also save individual fields for easy access
      if (userDetails.containsKey('id')) {
        await _prefs?.setString('user_id', userDetails['id'].toString());
      }
      if (userDetails.containsKey('phone')) {
        await _prefs?.setString('phone_number', userDetails['phone']);
      }
    }
  }

  // Get complete user profile
  static Map<String, dynamic>? getCompleteUserProfile() {
    final loginResponse = completeLoginResponse;
    if (loginResponse != null) {
      return loginResponse.toJson();
    }

    // Fallback to raw data if model parsing failed
    final userDetailsJson = _prefs?.getString('user_details');
    final banksJson = _prefs?.getString('banks');
    final token = _prefs?.getString('auth_token');
    final active = _prefs?.getInt('active');
    final status = _prefs?.getInt('status');
    final message = _prefs?.getString('message');

    if (userDetailsJson == null) return null;

    return {
      'user_details': json.decode(userDetailsJson),
      'banks': banksJson != null ? json.decode(banksJson) : [],
      'active': active,
      'status': status,
      'message': message,
      'Authorization': token,
    };
  }
}
