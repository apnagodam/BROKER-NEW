// To parse this JSON data, do
//
//     final sbtMatchedOrderResponse = sbtMatchedOrderResponseFromJson(jsondynamic);

import 'dart:convert';

SbtMatchedOrderResponse sbtMatchedOrderResponseFromJson(dynamic str) =>
    SbtMatchedOrderResponse.fromJson(json.decode(str));

dynamic sbtMatchedOrderResponseToJson(SbtMatchedOrderResponse data) =>
    json.encode(data.toJson());

class SbtMatchedOrderResponse {
  final dynamic status;
  final dynamic message;
  final List<TradeOrderData>? tradeOrderData;

  SbtMatchedOrderResponse({this.status, this.message, this.tradeOrderData});

  factory SbtMatchedOrderResponse.fromJson(Map<dynamic, dynamic> json) {
    return SbtMatchedOrderResponse(
      status: json['status'] as dynamic,
      message: json['message'] as dynamic,
      tradeOrderData: (json['trade_order_data'] as List<dynamic>?)
          ?.map((e) => TradeOrderData.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'trade_order_data': tradeOrderData?.map((e) => e.toJson()).toList(),
    };
  }

  SbtMatchedOrderResponse copyWith({
    dynamic status,
    dynamic message,
    List<TradeOrderData>? tradeOrderData,
  }) {
    return SbtMatchedOrderResponse( 
      status: status ?? this.status,
      message: message ?? this.message,
      tradeOrderData: tradeOrderData ?? this.tradeOrderData,
    );
  }
}

class TradeOrderData {
  final dynamic orderId;
  final dynamic seller;
  final dynamic buyer;
  final dynamic commodity;
  final dynamic district;
  final dynamic rate;
  final dynamic qty;
  final dynamic date;
  final dynamic deliveryQty;
  final dynamic def;
  final dynamic expiryDate;
  final dynamic dealType;
  final dynamic brokerId;

  TradeOrderData({
    this.orderId,
    this.seller,
    this.buyer,
    this.commodity,
    this.district,
    this.rate,
    this.qty,
    this.date,
    this.deliveryQty,
    this.def,
    this.expiryDate,
    this.dealType,
    this.brokerId,
  });

  factory TradeOrderData.fromJson(Map<dynamic, dynamic> json) {
    return TradeOrderData(
      orderId: json['order_id'] as dynamic,
      seller: json['seller'] as dynamic,
      buyer: json['buyer'] as dynamic,
      commodity: json['commodity'] as dynamic,
      district: json['district'] as dynamic,
      rate: (json['rate'] as num?),
      qty: json['qty'] as dynamic,
      date: json['date'] as dynamic,
      deliveryQty: json['delivery_qty'] as dynamic,
      def: json['default'] as dynamic,
      expiryDate: json['expiry_date'] as dynamic,
      dealType: json['deal_type'] as dynamic,
      brokerId: json['broker_id'] as dynamic,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'order_id': orderId,
      'seller': seller,
      'buyer': buyer,
      'commodity': commodity,
      'district': district,
      'rate': rate,
      'qty': qty,
      'date': date,
      'delivery_qty': deliveryQty,
      'default': def,
      'expiry_date': expiryDate,
      'deal_type': dealType,
      'broker_id': brokerId,
    };
  }

  TradeOrderData copyWith({  
    dynamic orderId,  
    dynamic seller,
    dynamic buyer,
    dynamic commodity,
    dynamic district,
    dynamic rate,
    dynamic qty,
    dynamic date,
    dynamic deliveryQty,
    dynamic def,
    dynamic expiryDate,
    dynamic dealType,
    dynamic brokerId,
  }) {
    return TradeOrderData(
      orderId: orderId ?? this.orderId,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      commodity: commodity ?? this.commodity,
      district: district ?? this.district,
      rate: rate ?? this.rate,
      qty: qty ?? this.qty,
      date: date ?? this.date,
      deliveryQty: deliveryQty ?? this.deliveryQty,
      def: def ?? this.def,
      expiryDate: expiryDate ?? this.expiryDate,
      dealType: dealType ?? this.dealType,
      brokerId: brokerId ?? this.brokerId,
    );
  }

  // Helper method to calculate pending quantity
  dynamic get pendingQty {  
    final total = double.tryParse(qty ?? '0') ?? 0.0;
    final delivered = double.tryParse(deliveryQty ?? '0') ?? 0.0;
    return total - delivered;
  }
}
