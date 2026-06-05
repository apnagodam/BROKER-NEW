// To parse this JSON data, do
//
//     final stackSellModel = stackSellModelFromMap(jsondynamic);

import 'dart:convert';

StackSellModel stackSellModelFromMap(dynamic str) =>
    StackSellModel.fromMap(json.decode(str));

dynamic stackSellModelToMap(StackSellModel data) => json.encode(data.toMap());

class StackSellModel {
  dynamic status;
  dynamic message;
  List<Datum>? data;

  StackSellModel({this.status, this.message, this.data});

  factory StackSellModel.fromMap(Map<dynamic, dynamic> json) => StackSellModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
  );

  Map<dynamic, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  dynamic id;
  dynamic sellerId;
  dynamic buyerId;
  dynamic warehouseName;
  dynamic warehouseAddress;
  dynamic commodityName;
  dynamic sellerPrice;
  dynamic stackNumber;
  dynamic quantity;
  dynamic minPrice;
  dynamic maxPrice;
  dynamic commodityImage;
  dynamic commodityPath;
  dynamic bestBuyerPrice;
  dynamic buyerPrice;
  List<StackBuySellConver>? stackBuySellConver;
  dynamic bidTime;

  Datum({
    this.id,
    this.sellerId,
    this.buyerId,
    this.warehouseName,
    this.warehouseAddress,
    this.commodityName,
    this.sellerPrice,
    this.stackNumber,
    this.quantity,
    this.minPrice,
    this.maxPrice,
    this.commodityImage,
    this.commodityPath,
    this.bestBuyerPrice,
    this.buyerPrice,
    this.stackBuySellConver,
    this.bidTime,
  });

  factory Datum.fromMap(Map<dynamic, dynamic> json) => Datum(
    id: json["id"],
    sellerId: json["seller_id"],
    buyerId: json["buyer_id"],
    warehouseName: json["warehouse_name"],
    warehouseAddress: json["warehouse_address"],
    commodityName: json["commodity_name"],
    sellerPrice: json["seller_price"],
    stackNumber: json["stack_number"],
    quantity: json["quantity"],
    minPrice: json["min_price"],
    maxPrice: json["max_price"],
    commodityImage: json["commodity_image"],
    commodityPath: json["commodity_path"],
    bestBuyerPrice: json["best_buyer_price"],
    buyerPrice: json["buyer_price"],
    stackBuySellConver: json["stack_buy_sell_conver"] == null
        ? []
        : List<StackBuySellConver>.from(
            json["stack_buy_sell_conver"]!.map(
              (x) => StackBuySellConver.fromMap(x),
            ),
          ),
    bidTime: json["bid_time"],
  );

  Map<dynamic, dynamic> toMap() => {
    "id": id,
    "seller_id": sellerId,
    "buyer_id": buyerId,
    "warehouse_name": warehouseName,
    "warehouse_address": warehouseAddress,
    "commodity_name": commodityName,
    "seller_price": sellerPrice,
    "stack_number": stackNumber,
    "quantity": quantity,
    "min_price": minPrice,
    "max_price": maxPrice,
    "commodity_image": commodityImage,
    "commodity_path": commodityPath,
    "best_buyer_price": bestBuyerPrice,
    "buyer_price": buyerPrice,
    "stack_buy_sell_conver": stackBuySellConver == null
        ? []
        : List<dynamic>.from(stackBuySellConver!.map((x) => x.toMap())),
    "bid_time": bidTime,
  };
}

class StackBuySellConver {
  dynamic id;
  dynamic userId;
  dynamic usersId;
  dynamic stackId;
  dynamic price;
  dynamic approveStatus;
  dynamic approveBy;
  dynamic rejectStatus;
  dynamic rejectBy;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic userName;
  StackBuySellConver({
    this.id,
    this.userId,
    this.usersId,
    this.stackId,
    this.price,
    this.approveStatus,
    this.approveBy,
    this.rejectStatus,
    this.rejectBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
  });

  factory StackBuySellConver.fromMap(Map<dynamic, dynamic> json) =>
      StackBuySellConver(
        id: json["id"],
        userId: json["user_id"],
        usersId: json["users_id"],
        stackId: json["stack_id"],
        price: json["price"],
        approveStatus: json["approve_status"],
        approveBy: json["approve_by"],
        rejectStatus: json["reject_status"],
        rejectBy: json["reject_by"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
      );

  Map<dynamic, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "users_id": usersId,
    "stack_id": stackId,
    "price": price,
    "approve_status": approveStatus,
    "approve_by": approveBy,
    "reject_status": rejectStatus,
    "reject_by": rejectBy,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user_name": userName,
  };
}
