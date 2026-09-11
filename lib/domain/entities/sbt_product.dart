class SbtProductResponse {
  final dynamic status;
  final dynamic message;
  final List<SbtProduct> data;

  SbtProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SbtProductResponse.fromJson(Map<dynamic, dynamic> json) {
    return SbtProductResponse(
      status: json['status'] as dynamic,
      message: json['message'] as dynamic,
      data: (json['data'] as List<dynamic>)
          .map((item) => SbtProduct.fromJson(item as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((product) => product.toJson()).toList(),
    };
  }
}

class SbtProduct {
  final dynamic productId;
  final dynamic districtId;
  final dynamic district;
  final dynamic commodityId;
  final dynamic commodity;
  final dynamic upperCircuit;
  final dynamic lowerCircuit;
  final dynamic quantityLimit;
  final dynamic bestSeller;
  final dynamic bestBuyer;
  final dynamic date;
  final dynamic sbtType;
  final dynamic image;
  final dynamic video;
  final dynamic path;
  final dynamic bidTime;
  final dynamic ltp;

  SbtProduct({
    required this.productId,
    required this.districtId,
    required this.district,
    required this.commodityId,
    required this.commodity,
    required this.upperCircuit,
    required this.lowerCircuit,
    required this.quantityLimit,
    required this.bestSeller,
    required this.bestBuyer,
    required this.date,
    required this.sbtType,
    this.image,
    this.video,
    required this.path,
    this.bidTime,
    this.ltp,
  });

  factory SbtProduct.fromJson(Map<dynamic, dynamic> json) {
    return SbtProduct(
      productId: json['product_id'] as dynamic,
      districtId: json['district_id'] as dynamic,
      district: json['district'] as dynamic,
      commodityId: json['commodity_id'] as dynamic,
      commodity: json['commodity'] as dynamic,
      upperCircuit: json['upper_circuit'] as dynamic,
      lowerCircuit: json['lower_circuit'] as dynamic,
      quantityLimit: json['quantity_limit'] as dynamic,
      bestSeller: json['best_seller'] as dynamic,
      bestBuyer: json['best_buyer'] as dynamic,
      date: json['date'] as dynamic,
      sbtType: json['sbt_type'] as dynamic,
      image: json['image'] as dynamic,
      video: json['video'] as dynamic,
      path: json['path'] as dynamic,
      bidTime: json['bid_time'] as dynamic,
      ltp: json['ltp'] as dynamic,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {  
      'product_id': productId,
      'district_id': districtId,
      'district': district,
      'commodity_id': commodityId,
      'commodity': commodity,
      'upper_circuit': upperCircuit,
      'lower_circuit': lowerCircuit,
      'quantity_limit': quantityLimit,
      'best_seller': bestSeller,
      'best_buyer': bestBuyer,
      'date': date,
      'sbt_type': sbtType,
      'image': image,
      'video': video,
      'path': path,
      'bid_time': bidTime,
      'ltp': ltp,
    };
  }
}
