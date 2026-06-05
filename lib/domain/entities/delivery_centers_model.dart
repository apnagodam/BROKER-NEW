// To parse this JSON data, do
//
//     final deliveryCentersModel = deliveryCentersModelFromJson(jsondynamic);

import 'dart:convert';

DeliveryCentersModel deliveryCentersModelFromJson(dynamic str) =>
    DeliveryCentersModel.fromJson(json.decode(str));

dynamic deliveryCentersModelToJson(DeliveryCentersModel data) =>
    json.encode(data.toJson());

class DeliveryCentersModel {
  List<DeliverCentersDatum>? data;
  dynamic status;
  dynamic message;

  DeliveryCentersModel({this.data, this.status, this.message});

  factory DeliveryCentersModel.fromJson(Map<dynamic, dynamic> json) =>
      DeliveryCentersModel(
        data: json["data"] == null
            ? []
            : List<DeliverCentersDatum>.from(
                json["data"]!.map((x) => DeliverCentersDatum.fromJson(x)),
              ),
        status: json["status"],
        message: json["message"],
      );

  Map<dynamic, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "message": message,
  };
}

class DeliverCentersDatum {
  dynamic id;
  dynamic warehouseName;
  dynamic warehouseAddress;
  dynamic labourRate;
  dynamic entryLoad;
  dynamic content;
  dynamic image;
  dynamic video;
  dynamic path;

  DeliverCentersDatum({
    this.id,
    this.warehouseName,
    this.warehouseAddress,
    this.labourRate,
    this.entryLoad,
    this.content,
    this.image,
    this.video,
    this.path,
  });

  factory DeliverCentersDatum.fromJson(Map<dynamic, dynamic> json) =>
      DeliverCentersDatum(
        id: json["id"],
        warehouseName: json["warehouse_name"],
        warehouseAddress: json["warehouse_address"],
        labourRate: json["labour_rate"],
        entryLoad: json["entry_load"],
        content: json["content"],
        image: json["image"],
        video: json["video"],
        path: json["path"],
      );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "warehouse_name": warehouseName,
    "warehouse_address": warehouseAddress,
    "labour_rate": labourRate,
    "entry_load": entryLoad,
    "content": content,
    "image": image,
    "video": video,
    "path": path,
  };
}
