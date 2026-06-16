// To parse this JSON data, do
//
//     final clientListModel = clientListModelFromJson(jsondynamic);

import 'dart:convert';

ClientListModel clientListModelFromJson(dynamic str) =>
    ClientListModel.fromJson(json.decode(str));

dynamic clientListModelToJson(ClientListModel data) =>
    json.encode(data.toJson());

class ClientListModel {
  dynamic status;
  dynamic message;
  List<Datum>? data;

  ClientListModel({this.status, this.message, this.data});

  factory ClientListModel.fromJson(Map<dynamic, dynamic> json) =>
      ClientListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {   
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {    
  dynamic userId;
  dynamic name;
  dynamic phone;

  Datum({this.userId, this.name, this.phone});

  factory Datum.fromJson(Map<dynamic, dynamic> json) =>
      Datum(userId: json["user_id"], name: json["name"], phone: json["phone"]);

  Map<dynamic, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "phone": phone,
  };
}
