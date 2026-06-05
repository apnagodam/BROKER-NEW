// To parse this JSON data, do
//
//     final tradeListModel = tradeListModelFromJson(jsondynamic);

import 'dart:convert';

TradeListModel tradeListModelFromJson(dynamic str) =>
    TradeListModel.fromJson(json.decode(str));

dynamic tradeListModelToJson(TradeListModel data) => json.encode(data.toJson());

class TradeListModel {
  dynamic status;
  dynamic message;
  List<BuyerDatum>? buyerData;
  List<SellerDatum>? sellerData;

  TradeListModel({this.status, this.message, this.buyerData, this.sellerData});

  factory TradeListModel.fromJson(Map<dynamic, dynamic> json) => TradeListModel(
    status: json["status"],
    message: json["message"],
    buyerData: json["buyer_data"] == null
        ? []
        : List<BuyerDatum>.from(
            json["buyer_data"]!.map((x) => BuyerDatum.fromJson(x)),
          ),
    sellerData: json["seller_data"] == null
        ? []
        : List<SellerDatum>.from(
            json["seller_data"]!.map((x) => SellerDatum.fromJson(x)),
          ),
  );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "message": message,
    "buyer_data": buyerData == null
        ? []
        : List<dynamic>.from(buyerData!.map((x) => x.toJson())),
    "seller_data": sellerData == null
        ? []
        : List<dynamic>.from(sellerData!.map((x) => x.toJson())),
  };
}

class BuyerDatum {
  dynamic brokerId;
  dynamic userId;
  dynamic userName;
  dynamic tradeId;
  dynamic districtId;
  dynamic commodity;
  dynamic rate;
  dynamic qty;
  dynamic type;
  dynamic userRating;
  dynamic date;

  BuyerDatum({
    this.brokerId,
    this.userId,
    this.userName,
    this.tradeId,
    this.districtId,
    this.commodity,
    this.rate,
    this.qty,
    this.type,
    this.userRating,
    this.date,
  });

  factory BuyerDatum.fromJson(Map<dynamic, dynamic> json) => BuyerDatum(
    brokerId: json["broker_id"],
    userId: json["user_id"],
    userName: json["user_name"],
    tradeId: json["trade_id"],
    districtId: json["district_id"],
    commodity: json["commodity"],
    rate: json["rate"],
    qty: json["qty"],
    type: json["type"],
    userRating: json["user_rating"],
    date: json["date"],
  );

  Map<dynamic, dynamic> toJson() => {
    "broker_id": brokerId,
    "user_id": userId,
    "user_name": userName,
    "trade_id": tradeId,
    "district_id": districtId,
    "commodity": commodity,
    "rate": rate,
    "qty": qty,
    "type": type,
    "user_rating": userRating,
    "date": date,
  };
}

class SellerDatum {
  dynamic brokerId;
  dynamic userId;
  dynamic userName;
  dynamic tradeId;
  dynamic districtId;
  dynamic commodity;
  dynamic rate;
  dynamic qty;
  dynamic type;
  dynamic userRating;
  dynamic date;

  SellerDatum({
    this.brokerId,
    this.userId,
    this.userName,
    this.tradeId,
    this.districtId,
    this.commodity,
    this.rate,
    this.qty,
    this.type,
    this.userRating,
    this.date,
  });

  factory SellerDatum.fromJson(Map<dynamic, dynamic> json) => SellerDatum(
    brokerId: json["broker_id"],
    userId: json["user_id"],
    userName: json["user_name"],
    tradeId: json["trade_id"],
    districtId: json["district_id"],
    commodity: json["commodity"],
    rate: json["rate"],
    qty: json["qty"],
    type: json["type"],
    userRating: json["user_rating"],
    date: json["date"],
  );

  Map<dynamic, dynamic> toJson() => {
    "broker_id": brokerId,
    "user_id": userId,
    "user_name": userName,
    "trade_id": tradeId,
    "district_id": districtId,
    "commodity": commodity,
    "rate": rate,
    "qty": qty,
    "type": type,
    "user_rating": userRating,
    "date": date,
  };
}
