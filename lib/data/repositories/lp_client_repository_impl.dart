import 'dart:io';
import 'dart:ui';

import 'package:ag_broker/core/utils/constants.dart';
import 'package:ag_broker/core/utils/dio_client.dart';
import 'package:ag_broker/domain/entities/lp_client_model.dart';
import 'package:ag_broker/domain/repositories/lp_client_repository.dart';
import 'package:dio/dio.dart';

class LpClientRepositoryImpl extends LpClientRepository {
  final DioClient _dioClient;

  LpClientRepositoryImpl(Locale locale) : _dioClient = DioClient(locale);

  @override
  Future<LpClientListModel> getLpClientList() async {
    try {
      final response = await _dioClient.dio.get(Constants.lpClientList);
      final model = LpClientListModel.fromJson(response.data);

      // Check status code in response
      if (model.status.toString() == "0") {
        throw Exception(model.message ?? 'Failed to fetch LP Client List');
      }

      return model;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.data != null && e.response!.data is Map) {
        final errorMessage =
            e.response!.data['message'] ?? 'Network error occurred';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Only wrap if it's not already an Exception
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to fetch LP Client List: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> addLpClient({
    required String constitution,
    required String name,
    required String phone,
    String? bidStatus,
    File? aadharFrontImage,
    File? aadharBackImage,
    File? pancardImage,
    File? gstImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'constitution': constitution,
        'name': name,
        'phone': phone,
        if (bidStatus != null) 'bid_status': bidStatus,
        if (aadharFrontImage != null)
          'aadhar_front_image': await MultipartFile.fromFile(
            aadharFrontImage.path,
          ),
        if (aadharBackImage != null)
          'aadhar_back_image': await MultipartFile.fromFile(
            aadharBackImage.path,
          ),
        if (pancardImage != null)
          'pancard_image': await MultipartFile.fromFile(pancardImage.path),
        if (gstImage != null)
          'gst_image': await MultipartFile.fromFile(gstImage.path),
      });

      final response = await _dioClient.dio.post(
        Constants.addLpClient,
        data: formData,
      );

      // Return response regardless of status - let provider handle it
      return response.data;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.data != null && e.response!.data is Map) {
        final errorMessage =
            e.response!.data['message'] ?? 'Network error occurred';
        throw Exception(errorMessage);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add LP Client: ${e.toString()}');
    }
  }
}
