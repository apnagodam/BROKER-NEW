class RunningDealsResponse {
  dynamic status;
  dynamic message;
  List<RunningDealItem>? data;

  RunningDealsResponse({this.status, this.message, this.data});

  factory RunningDealsResponse.fromJson(dynamic json) {
    if (json is List) {
      return RunningDealsResponse(
        status: "1",
        data: json.map((x) => RunningDealItem.fromJson(x)).toList(),
      );
    }
    if (json is Map) {
      final listData =
          json['Dealdata'] ?? json['data'] ?? json['order_data'] ?? json['deals'] ?? [];
      return RunningDealsResponse(
        status: json['status'],
        message: json['message'],
        data: listData is List
            ? listData.map((x) => RunningDealItem.fromJson(x)).toList()
            : [],
      );
    }
    return RunningDealsResponse(data: []);
  }
}

class RunningDealItem {
  dynamic id;
  dynamic orderId;
  dynamic orderMatchDate;
  dynamic deliveryDays;
  dynamic clientName;
  dynamic buyerName;
  dynamic sellerName;
  dynamic productName;
  dynamic commodity;
  dynamic commodityName;
  dynamic price;
  dynamic weight;
  dynamic dealQty;
  dynamic deliveredWeight;
  dynamic delaverQty;
  dynamic truckNumber;
  dynamic driverNumber;
  dynamic status;
  dynamic brokeroutWardview;
  dynamic productId;

  RunningDealItem({
    this.id,
    this.orderId,
    this.orderMatchDate,
    this.deliveryDays,
    this.clientName,
    this.buyerName,
    this.sellerName,
    this.productName,
    this.commodity,
    this.commodityName,
    this.price,
    this.weight,
    this.dealQty,
    this.deliveredWeight,
    this.delaverQty,
    this.truckNumber,
    this.driverNumber,
    this.status,
    this.brokeroutWardview,
    this.productId,
  });

  factory RunningDealItem.fromJson(Map<dynamic, dynamic> json) {
    return RunningDealItem(
      id: json['id'] ?? json['order_id'],
      orderId: json['order_id'] ?? json['order_no'] ?? json['id'] ?? '',
      orderMatchDate:
          json['order_match_date'] ?? json['match_date'] ?? json['date'] ?? '',
      deliveryDays: json['deliveryDays'] ??
          json['delivery_days'] ??
          json['delivery_date'] ??
          json['days'] ??
          '',
      clientName: json['buyer_name'] ??
          json['client_name'] ??
          json['seller_name'] ??
          '',
      buyerName: json['buyer_name'] ?? json['client_name'] ?? '',
      sellerName: json['seller_name'] ?? '',
      productName: json['product_name'] ??
          json['product'] ??
          json['warehouse_name'] ??
          '',
      commodity: json['commodity_name'] ?? json['commodity'] ?? '',
      commodityName: json['commodity_name'] ?? json['commodity'] ?? '',
      price: json['price'] ?? json['rate'] ?? '0',
      weight: json['deal_qty'] ?? json['weight'] ?? json['qty'] ?? '0',
      dealQty: json['deal_qty'] ?? json['weight'] ?? '0',
      deliveredWeight:
          json['delaver_qty'] ?? json['delivered_weight'] ?? json['delivered_qty'] ?? '0',
      delaverQty: json['delaver_qty'] ?? json['delivered_weight'] ?? '0',
      truckNumber: json['truck_number'] ?? json['truck_no'] ?? '',
      driverNumber:
          json['driver_number'] ?? json['driver_no'] ?? json['mobile'] ?? '',
      status: json['deal_status'] ?? json['status'] ?? '',
      brokeroutWardview: json['brokeroutWardview']?.toString() ?? '',
      productId: json['productId'] ?? json['product_id'],
    );
  }
}
