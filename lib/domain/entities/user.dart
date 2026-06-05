class Bank {
  final dynamic bankName;

  Bank({required this.bankName});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(bankName: json['bank_name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'bank_name': bankName};
  }
}

class UserDetails {
  final dynamic id;
  final dynamic userId;
  final dynamic type;
  final dynamic uniqueId;
  final dynamic phone;
  final dynamic email;
  final dynamic name;
  final dynamic age;
  final dynamic fullAddress;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic passportImage;
  final dynamic drivingLicenceNo;
  final dynamic drivingLicenceImage;
  final dynamic drivingLicenceExpiryDate;
  final dynamic facilities;
  final dynamic bankName;
  final dynamic bankIfscCode;
  final dynamic accountNo;
  final dynamic aadharNo;
  final dynamic pancardNo;
  final dynamic aadharImage;
  final dynamic pancardImage;
  final dynamic passbookImage;
  final dynamic imagePath;
  final dynamic onlineOffline;
  final dynamic liveLat;
  final dynamic liveLong;
  final dynamic approveBy;
  final dynamic verifyBy;
  final dynamic lpPowerby;
  final dynamic approve;
  final dynamic verify;
  final dynamic autoAccept;
  final dynamic booked;
  final dynamic lpPower;
  final dynamic lpCommission;
  final dynamic intentionLimit;
  final dynamic tripStatus;
  final dynamic status;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic power;

  UserDetails({
    required this.id,
    required this.userId,
    required this.type,
    required this.uniqueId,
    required this.phone,
    this.email,
    required this.name,
    this.age,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.passportImage,
    this.drivingLicenceNo,
    this.drivingLicenceImage,
    this.drivingLicenceExpiryDate,
    required this.facilities,
    this.bankName,
    this.bankIfscCode,
    this.accountNo,
    this.aadharNo,
    this.pancardNo,
    this.aadharImage,
    this.pancardImage,
    this.passbookImage,
    required this.imagePath,
    required this.onlineOffline,
    required this.liveLat,
    required this.liveLong,
    required this.approveBy,
    required this.verifyBy,
    this.lpPowerby,
    required this.approve,
    required this.verify,
    required this.autoAccept,
    required this.booked,
    this.lpPower,
    required this.lpCommission,
    required this.intentionLimit,
    required this.tripStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.power,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? 0,
      uniqueId: json['unique_id'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      name: json['name'] ?? '',
      age: json['age'],
      fullAddress: json['full_address'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      passportImage: json['passport_image'],
      drivingLicenceNo: json['driving_licence_no'],
      drivingLicenceImage: json['driving_licence_image'],
      drivingLicenceExpiryDate: json['driving_licence_expiry_date'],
      facilities: json['facilities'] ?? 0,
      bankName: json['bank_name'],
      bankIfscCode: json['bank_ifsc_code'],
      accountNo: json['account_no'],
      aadharNo: json['aadhar_no'],
      pancardNo: json['pancard_no'],
      aadharImage: json['aadhar_image'],
      pancardImage: json['pancard_image'],
      passbookImage: json['passbook_image'],
      imagePath: json['image_path'] ?? '',
      onlineOffline: json['online_offline'] ?? 0,
      liveLat: json['live_lat'] ?? '0.0',
      liveLong: json['live_long'] ?? '0.0',
      approveBy: json['approve_by'] ?? 0,
      verifyBy: json['verify_by'] ?? 0,
      lpPowerby: json['lp_powerby'],
      approve: json['approve'] ?? 0,
      verify: json['verify'] ?? 0,
      autoAccept: json['auto_accept'] ?? 0,
      booked: json['booked'] ?? 0,
      lpPower: json['lp_power'],
      lpCommission: json['lp_commission'] ?? '0',
      intentionLimit: json['intention_limit'] ?? 0,
      tripStatus: json['trip_status'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      power: json['power'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'unique_id': uniqueId,
      'phone': phone,
      'email': email,
      'name': name,
      'age': age,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'passport_image': passportImage,
      'driving_licence_no': drivingLicenceNo,
      'driving_licence_image': drivingLicenceImage,
      'driving_licence_expiry_date': drivingLicenceExpiryDate,
      'facilities': facilities,
      'bank_name': bankName,
      'bank_ifsc_code': bankIfscCode,
      'account_no': accountNo,
      'aadhar_no': aadharNo,
      'pancard_no': pancardNo,
      'aadhar_image': aadharImage,
      'pancard_image': pancardImage,
      'passbook_image': passbookImage,
      'image_path': imagePath,
      'online_offline': onlineOffline,
      'live_lat': liveLat,
      'live_long': liveLong,
      'approve_by': approveBy,
      'verify_by': verifyBy,
      'lp_powerby': lpPowerby,
      'approve': approve,
      'verify': verify,
      'auto_accept': autoAccept,
      'booked': booked,
      'lp_power': lpPower,
      'lp_commission': lpCommission,
      'intention_limit': intentionLimit,
      'trip_status': tripStatus,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'power': power,
    };
  }
}

class LoginResponse {
  final dynamic authorization;
  final dynamic banks;
  final dynamic active;
  final dynamic userDetails;
  final dynamic status;
  final dynamic message;

  LoginResponse({
    required this.authorization,
    required this.banks,
    required this.active,
    required this.userDetails,
    required this.status,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      authorization: json['Authorization'] ?? '',
      banks:
          (json['banks'] as List<dynamic>?)
              ?.map((bank) => Bank.fromJson(bank))
              .toList() ??
          [],
      active: json['active'] ?? 0,
      userDetails: UserDetails.fromJson(json['user_details'] ?? {}),
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Authorization': authorization,
      'banks': banks.map((bank) => bank.toJson()).toList(),
      'active': active,
      'user_details': userDetails.toJson(),
      'status': status,
      'message': message,
    };
  }
}
