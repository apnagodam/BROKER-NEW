import 'package:ag_broker/domain/entities/user_details_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> sendOtp(String phoneNumber);
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp);
  Future<Map<String, dynamic>> getBrokerage();

  Future<UserDetailsModel> getUserDetails();
}
