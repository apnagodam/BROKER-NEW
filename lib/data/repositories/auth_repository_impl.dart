import 'dart:convert';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/core/utils/notification_service.dart';
import 'package:ag_broker/domain/entities/user_details_model.dart';
import 'package:ag_broker/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;

  AuthRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);

  @override
  Future<Map<String, dynamic>> checkUser(String phoneNumber) async {
    final response = await _dioClient.dio.post(
      Constants.checkUser,
      data: {'number': phoneNumber},
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> sendOtp({required int userId}) async {
    final response = await _dioClient.dio.post(
      Constants.sendOtp,
      data: {'user_id': userId},
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
    String? fcmToken,
  }) async {
    final token = fcmToken ?? NotificationService.fcmToken ?? '';
    final response = await _dioClient.dio.post(
      Constants.verifyOtp,
      data: {
        'otp': otp,
        'user_id': userId,
        'fcm_token': token,
      },
    );
    if (response.data is String) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getBrokerage() async {
    final response = await _dioClient.dio.post(Constants.getBrokerage);
    return response.data;
  }

  @override
  Future<UserDetailsModel> getUserDetails() async {
    final response = await _dioClient.dio.get(Constants.getUserDetails);
    return response.data is String
        ? userDetailsModelFromJson(response.data)
        : UserDetailsModel.fromJson(response.data);
  }
}
