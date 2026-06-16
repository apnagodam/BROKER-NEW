// To parse this JSON data, do
//
//     final dealsModel = dealsModelFromJson(jsondynamic);

import 'dart:convert';

DealsModel dealsModelFromJson(dynamic str) =>
    DealsModel.fromJson(json.decode(str));

dynamic dealsModelToJson(DealsModel data) => json.encode(data.toJson());

class DealsModel {
  dynamic status;
  dynamic message;
  List<OrderDatum>? orderData;

  DealsModel({this.status, this.message, this.orderData});

  factory DealsModel.fromJson(Map<dynamic, dynamic> json) => DealsModel(
    status: json["status"],
    message: json["message"],
    orderData: json["order_data"] == null
        ? []
        : List<OrderDatum>.from(
            json["order_data"]!.map((x) => OrderDatum.fromJson(x)),
          ),
  );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "message": message,
    "order_data": orderData == null
        ? []
        : List<dynamic>.from(orderData!.map((x) => x.toJson())),
  };
}

class OrderDatum {
  dynamic dealType;
  dynamic dealStatus;
  dynamic orderId;
  dynamic price;
  dynamic dealQty;
  dynamic delaverQty;
  dynamic buyerName;
  dynamic sellerName;
  dynamic commodityName;
  dynamic orderMatchDate;
  dynamic productName;

  OrderDatum({
    this.dealType,
    this.dealStatus,
    this.orderId,
    this.price,
    this.dealQty,
    this.delaverQty,
    this.buyerName,
    this.sellerName,
    this.commodityName,
    this.orderMatchDate,
    this.productName,
  });

  factory OrderDatum.fromJson(Map<dynamic, dynamic> json) => OrderDatum(
    dealType: json["deal_type"],
    dealStatus: json["deal_status"],
    orderId: json["order_id"],
    price: json["price"],
    dealQty: json["deal_qty"],
    delaverQty: json["delaver_qty"],
    buyerName: json["buyer_name"],
    sellerName: json["seller_name"],
    commodityName: json["commodity_name"],
    orderMatchDate: json["order_match_date"],
    productName: json["product_name"],
  );

  Map<dynamic, dynamic> toJson() => {
    "deal_type": dealType,
    "deal_status": dealStatus,
    "order_id": orderId,
    "price": price, 
    "deal_qty": dealQty,
    "delaver_qty": delaverQty,
    "buyer_name": buyerName,
    "seller_name": sellerName,
    "commodity_name": commodityName,
    "order_match_date": orderMatchDate,
    "product_name": productName,
  };
}
