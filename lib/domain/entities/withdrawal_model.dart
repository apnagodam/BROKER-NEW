import 'dart:convert';

WithdrawalListModel withdrawalListModelFromJson(dynamic str) =>
    WithdrawalListModel.fromJson(json.decode(str));

dynamic withdrawalListModelToJson(WithdrawalListModel data) =>
    json.encode(data.toJson());

class WithdrawalListModel {
  dynamic status;
  dynamic message;
  List<WithdrawalData>? data;

  WithdrawalListModel({this.status, this.message, this.data});

  factory WithdrawalListModel.fromJson(Map<dynamic, dynamic> json) =>
      WithdrawalListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<WithdrawalData>.from(
                json["data"]!.map((x) => WithdrawalData.fromJson(x)),
              ),
      );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WithdrawalData {
  dynamic id;
  dynamic wrr;
  dynamic userId;
  dynamic requestedAmount;
  dynamic approvedAmount;
  dynamic bankName;
  dynamic accountNumber;
  dynamic ifscCode;
  dynamic bankBranch;
  dynamic paymentBy;
  dynamic referenceNo;
  dynamic poutId;
  dynamic fundAccountId;
  dynamic contactId;
  dynamic approvedBy;
  dynamic approvedDate;
  dynamic remark;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  WithdrawalData({
    this.id,
    this.wrr,
    this.userId,
    this.requestedAmount,
    this.approvedAmount,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.bankBranch,
    this.paymentBy,
    this.referenceNo,
    this.poutId,
    this.fundAccountId,
    this.contactId,
    this.approvedBy,
    this.approvedDate,
    this.remark,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawalData.fromJson(Map<dynamic, dynamic> json) => WithdrawalData(
    id: json["id"],
    wrr: json["wrr"],
    userId: json["user_id"],
    requestedAmount: json["requested_amount"],
    approvedAmount: json["approved_amount"],
    bankName: json["bank_name"],
    accountNumber: json["account_number"],
    ifscCode: json["ifsc_code"],
    bankBranch: json["bank_branch"],
    paymentBy: json["payment_by"],
    referenceNo: json["reference_no"],
    poutId: json["pout_id"],
    fundAccountId: json["fund_account_id"],
    contactId: json["contact_id"],
    approvedBy: json["approved_by"],
    approvedDate: json["approved_date"],
    remark: json["remark"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "wrr": wrr,
    "user_id": userId,
    "requested_amount": requestedAmount,
    "approved_amount": approvedAmount,
    "bank_name": bankName,
    "account_number": accountNumber,
    "ifsc_code": ifscCode,
    "bank_branch": bankBranch,
    "payment_by": paymentBy,
    "reference_no": referenceNo,
    "pout_id": poutId,
    "fund_account_id": fundAccountId,
    "contact_id": contactId,
    "approved_by": approvedBy,
    "approved_date": approvedDate,
    "remark": remark,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
