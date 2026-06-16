// To parse this JSON data, do
//
//     final qualityParamsModel = qualityParamsModelFromJson(jsondynamic);

import 'dart:convert';

QualityParamsModel qualityParamsModelFromJson(dynamic str) =>
    QualityParamsModel.fromJson(json.decode(str));

dynamic qualityParamsModelToJson(QualityParamsModel data) =>
    json.encode(data.toJson());

class QualityParamsModel {
  List<QualityDatum>? data;
  dynamic status;
  dynamic message;

  QualityParamsModel({this.data, this.status, this.message});

  factory QualityParamsModel.fromJson(Map<dynamic, dynamic> json) =>
      QualityParamsModel(
        data: json["data"] == null
            ? []
            : List<QualityDatum>.from(
                json["data"]!.map((x) => QualityDatum.fromJson(x)),
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

class QualityDatum {
  dynamic id;
  dynamic producrId;
  dynamic commodityId;
  dynamic parameterId;
  dynamic min;
  dynamic max;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  Parameters? parameters;

  QualityDatum({
    this.id,
    this.producrId,
    this.commodityId,
    this.parameterId,
    this.min,
    this.max,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.parameters,
  });

  factory QualityDatum.fromJson(Map<dynamic, dynamic> json) => QualityDatum(
    id: json["id"],
    producrId: json["producr_id"],
    commodityId: json["commodity_id"],
    parameterId: json["parameter_id"],
    min: json["min"],
    max: json["max"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    parameters: json["parameters"] == null
        ? null
        : Parameters.fromJson(json["parameters"]),
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,  
    "producr_id": producrId,
    "commodity_id": commodityId,
    "parameter_id": parameterId,
    "min": min,
    "max": max,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "parameters": parameters?.toJson(),
  };
}

class Parameters {
  dynamic id;
  dynamic parameter;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  Parameters({
    this.id,
    this.parameter,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Parameters.fromJson(Map<dynamic, dynamic> json) => Parameters(
    id: json["id"],
    parameter: json["parameter"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "parameter": parameter,
    "status": status,
    "created_at": createdAt, 
    "updated_at": updatedAt,
  };
}
