import 'package:ag_broker/domain/entities/user_details_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> checkUser(String phoneNumber);
  Future<Map<String, dynamic>> sendOtp({required int userId});
  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    String? fcmToken,
  });
  Future<Map<String, dynamic>> getBrokerage();

  Future<UserDetailsModel> getUserDetails();
}
