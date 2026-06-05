// To parse this JSON data, do
//
//     final lpClientListModel = lpClientListModelFromJson(jsonString);

import 'dart:convert';

LpClientListModel lpClientListModelFromJson(dynamic str) =>
    LpClientListModel.fromJson(json.decode(str));

dynamic lpClientListModelToJson(LpClientListModel data) =>
    json.encode(data.toJson());

class LpClientListModel {
  dynamic status;
  dynamic message;
  List<LpClient>? data;

  LpClientListModel({this.status, this.message, this.data});

  factory LpClientListModel.fromJson(Map<dynamic, dynamic> json) =>
      LpClientListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<LpClient>.from(
                json["data"]!.map((x) => LpClient.fromJson(x)),
              ),
      );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LpClient {
  dynamic constitution;
  dynamic userId;
  dynamic name;
  dynamic phone;
  dynamic aadharNumber;
  dynamic panNumber;
  dynamic gstNumber;
  dynamic approveBy;
  dynamic verifyBy;

  LpClient({
    this.constitution,
    this.userId,
    this.name,
    this.phone,
    this.aadharNumber,
    this.panNumber,
    this.gstNumber,
    this.approveBy,
    this.verifyBy,
  });

  factory LpClient.fromJson(Map<dynamic, dynamic> json) => LpClient(
    constitution: json["constitution"],
    userId: json["user_id"],
    name: json["name"],
    phone: json["phone"],
    aadharNumber: json["aadhar_number"],
    panNumber: json["pan_number"],
    gstNumber: json["gst_number"],
    approveBy: json["approve_by"],
    verifyBy: json["verify_by"],
  );

  Map<dynamic, dynamic> toJson() => {
    "constitution": constitution,
    "user_id": userId,
    "name": name,
    "phone": phone,
    "aadhar_number": aadharNumber,
    "pan_number": panNumber,
    "gst_number": gstNumber,
    "approve_by": approveBy,
    "verify_by": verifyBy,
  };
}
