// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsondynamic);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(dynamic str) =>
    UserDetailsModel.fromJson(json.decode(str));

dynamic userDetailsModelToJson(UserDetailsModel data) =>
    json.encode(data.toJson());

class UserDetailsModel {
  UserDetails? userDetails;
  dynamic bookings;
  dynamic bookingId;
  dynamic ordersData;
  dynamic status;
  dynamic message;

  UserDetailsModel({
    this.userDetails,
    this.bookings,
    this.bookingId,
    this.ordersData,
    this.status,
    this.message,
  });

  factory UserDetailsModel.fromJson(Map<dynamic, dynamic> json) =>
      UserDetailsModel(
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
        bookings: json["bookings"],
        bookingId: json["booking_id"],
        ordersData: json["orders_data"],
        status: json["status"],
        message: json["message"],
      );

  Map<dynamic, dynamic> toJson() => {
    "user_details": userDetails?.toJson(),
    "bookings": bookings,
    "booking_id": bookingId,
    "orders_data": ordersData,
    "status": status,
    "message": message,
  };
}

class UserDetails {
  dynamic id;
  dynamic userId;
  dynamic type;
  dynamic uniqueId;
  dynamic phone;
  dynamic email;
  dynamic name;
  dynamic age;
  dynamic fullAddress;
  dynamic latitude;
  dynamic longitude;
  dynamic passportImage;
  dynamic drivingLicenceNo;
  dynamic drivingLicenceImage;
  dynamic drivingLicenceExpiryDate;
  dynamic facilities;
  dynamic bankName;
  dynamic bankIfscCode;
  dynamic accountNo;
  dynamic branchAddress;
  dynamic aadharNo;
  dynamic pancardNo;
  dynamic aadharImage;
  dynamic pancardImage;
  dynamic passbookImage;
  dynamic imagePath;
  dynamic onlineOffline;
  dynamic liveLat;
  dynamic liveLong;
  dynamic approveBy;
  dynamic verifyBy;
  dynamic lpPowerby;
  dynamic approve;
  dynamic verify;
  dynamic autoAccept;
  dynamic booked;
  dynamic lpPower;
  dynamic brokeragePower;
  dynamic lpCommission;
  dynamic dynamicentionLimit;
  dynamic tripStatus;
  dynamic power;
  dynamic priceAlertType;
  dynamic commodityName;
  dynamic stcmUserId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic vehicleNo;
  dynamic vehicleType;
  dynamic vehicleCapacityMin;
  dynamic vehicleCapacityMax;
  dynamic vehicleRcImage;
  dynamic vehicleInsurance;
  dynamic vehicleInsuranceNo;
  dynamic vehicleInsuranceImage;
  dynamic permitType;
  dynamic vehicleMileage;
  dynamic vehicleFuelType;
  dynamic pqpk;

  UserDetails({
    this.id,
    this.userId,
    this.type,
    this.uniqueId,
    this.phone,
    this.email,
    this.name,
    this.age,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.passportImage,
    this.drivingLicenceNo,
    this.drivingLicenceImage,
    this.drivingLicenceExpiryDate,
    this.facilities,
    this.bankName,
    this.bankIfscCode,
    this.accountNo,
    this.branchAddress,
    this.aadharNo,
    this.pancardNo,
    this.aadharImage,
    this.pancardImage,
    this.passbookImage,
    this.imagePath,
    this.onlineOffline,
    this.liveLat,
    this.liveLong,
    this.approveBy,
    this.verifyBy,
    this.lpPowerby,
    this.approve,
    this.verify,
    this.autoAccept,
    this.booked,
    this.lpPower,
    this.brokeragePower,
    this.lpCommission,
    this.dynamicentionLimit,
    this.tripStatus,
    this.power,
    this.priceAlertType,
    this.commodityName,
    this.stcmUserId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vehicleNo,
    this.vehicleType,
    this.vehicleCapacityMin,
    this.vehicleCapacityMax,
    this.vehicleRcImage,
    this.vehicleInsurance,
    this.vehicleInsuranceNo,
    this.vehicleInsuranceImage,
    this.permitType,
    this.vehicleMileage,
    this.vehicleFuelType,
    this.pqpk,
  });

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) => UserDetails(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    uniqueId: json["unique_id"],
    phone: json["phone"],
    email: json["email"],
    name: json["name"],
    age: json["age"],
    fullAddress: json["full_address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    passportImage: json["passport_image"],
    drivingLicenceNo: json["driving_licence_no"],
    drivingLicenceImage: json["driving_licence_image"],
    drivingLicenceExpiryDate: json["driving_licence_expiry_date"],
    facilities: json["facilities"],
    bankName: json["bank_name"],
    bankIfscCode: json["bank_ifsc_code"],
    accountNo: json["account_no"],
    branchAddress: json["branch_address"],
    aadharNo: json["aadhar_no"],
    pancardNo: json["pancard_no"],
    aadharImage: json["aadhar_image"],
    pancardImage: json["pancard_image"],
    passbookImage: json["passbook_image"],
    imagePath: json["image_path"],
    onlineOffline: json["online_offline"],
    liveLat: json["live_lat"],
    liveLong: json["live_long"],
    approveBy: json["approve_by"],
    verifyBy: json["verify_by"],
    lpPowerby: json["lp_powerby"],
    approve: json["approve"],
    verify: json["verify"],
    autoAccept: json["auto_accept"],
    booked: json["booked"],
    lpPower: json["lp_power"],
    brokeragePower: json["brokerage_power"],
    lpCommission: json["lp_commission"],
    dynamicentionLimit: json["dynamicention_limit"],
    tripStatus: json["trip_status"],
    power: json["power"],
    priceAlertType: json["price_alert_type"],
    commodityName: json["commodity_name"],
    stcmUserId: json["stcm_user_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    vehicleNo: json["vehicle_no"],
    vehicleType: json["vehicle_type"],
    vehicleCapacityMin: json["vehicle_capacity_min"],
    vehicleCapacityMax: json["vehicle_capacity_max"],
    vehicleRcImage: json["vehicle_rc_image"],
    vehicleInsurance: json["vehicle_insurance"],
    vehicleInsuranceNo: json["vehicle_insurance_no"],
    vehicleInsuranceImage: json["vehicle_insurance_image"],
    permitType: json["permit_type"],
    vehicleMileage: json["vehicle_mileage"],
    vehicleFuelType: json["vehicle_fuel_type"],
    pqpk: json["pqpk"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "unique_id": uniqueId,
    "phone": phone,
    "email": email,
    "name": name,
    "age": age,
    "full_address": fullAddress,
    "latitude": latitude,
    "longitude": longitude,
    "passport_image": passportImage,
    "driving_licence_no": drivingLicenceNo,
    "driving_licence_image": drivingLicenceImage,
    "driving_licence_expiry_date": drivingLicenceExpiryDate,
    "facilities": facilities,
    "bank_name": bankName,
    "bank_ifsc_code": bankIfscCode,
    "account_no": accountNo,
    "branch_address": branchAddress,
    "aadhar_no": aadharNo,
    "pancard_no": pancardNo,
    "aadhar_image": aadharImage,
    "pancard_image": pancardImage,
    "passbook_image": passbookImage,
    "image_path": imagePath,
    "online_offline": onlineOffline,
    "live_lat": liveLat,
    "live_long": liveLong,
    "approve_by": approveBy,
    "verify_by": verifyBy,
    "lp_powerby": lpPowerby,
    "approve": approve,
    "verify": verify,
    "auto_accept": autoAccept,
    "booked": booked,
    "lp_power": lpPower,
    "brokerage_power": brokeragePower,
    "lp_commission": lpCommission,
    "dynamicention_limit": dynamicentionLimit,
    "trip_status": tripStatus,
    "power": power,
    "price_alert_type": priceAlertType,
    "commodity_name": commodityName,
    "stcm_user_id": stcmUserId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "vehicle_no": vehicleNo,
    "vehicle_type": vehicleType,
    "vehicle_capacity_min": vehicleCapacityMin,
    "vehicle_capacity_max": vehicleCapacityMax,
    "vehicle_rc_image": vehicleRcImage,
    "vehicle_insurance": vehicleInsurance,
    "vehicle_insurance_no": vehicleInsuranceNo,
    "vehicle_insurance_image": vehicleInsuranceImage,
    "permit_type": permitType,
    "vehicle_mileage": vehicleMileage,
    "vehicle_fuel_type": vehicleFuelType,
    "pqpk": pqpk,
  };
}
