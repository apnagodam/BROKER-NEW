import 'dart:io';
import 'package:ag_broker/domain/entities/lp_client_model.dart';

abstract class LpClientRepository {
  Future<LpClientListModel> getLpClientList();

  Future<Map<String, dynamic>> addLpClient({
    required String constitution,
    required String name,
    required String phone,
    String? bidStatus,
    File? aadharFrontImage,
    File? aadharBackImage,
    File? pancardImage,
    File? gstImage,
  });
}
